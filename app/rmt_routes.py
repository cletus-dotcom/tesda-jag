import traceback

from flask import (
    Blueprint,
    flash,
    jsonify,
    redirect,
    render_template,
    request,
    send_file,
    session,
    url_for,
)
from werkzeug.utils import secure_filename

from app import db
from app.auth import admin_required, login_required, staff_or_admin_required
from app.config import (
    can_edit_documents,
    display_rmt_record_type,
    normalize_role,
    parse_rmt_record_type_fields,
    safe_login_redirect,
)
from app.session_user import is_portal_admin_session, resolve_session_user
from app.drive_service import (
    drive_configured,
    guess_pdf_mimetype,
    resolve_pdf_path,
    save_pdf_locally,
    upload_pdf_to_drive,
)
from app.manual_content import get_rmt_manual, resolve_manual_role
from app.models import RmtRecord, User
from app.rmt_service import (
    rmt_dashboard_stats,
    search_records_query,
    serialize_rmt_record,
)
from app.utils import generate_record_number, local_time, parse_document_date

rmt_routes = Blueprint("rmt_routes", __name__, url_prefix="/rmt")


def _current_user():
    return resolve_session_user()


def _dashboard_context(user):
    return {
        "fullname": user.full_name or "Guest",
        "role": normalize_role(user.role),
        "office": user.office or "Unknown Office",
        "can_edit": can_edit_documents(user.role),
    }


def _validate_record_form(form):
    title = form.get("title", "").strip()
    record_type, record_type_part, type_error = parse_rmt_record_type_fields(
        form.get("record_type"),
        form.get("record_type_part"),
    )
    cabinet_number = form.get("cabinet_number", "").strip()
    shelf_number = form.get("shelf_number", "").strip()
    keywords = form.get("keywords", "").strip()
    remarks = form.get("remarks", "").strip()
    pdf_link = form.get("pdf_link", "").strip()

    if not title:
        return None, "Title is required."
    if type_error:
        return None, type_error
    if not cabinet_number:
        return None, "Cabinet number is required."
    if not shelf_number:
        return None, "Shelf number is required."

    try:
        record_date = parse_document_date(form.get("record_date")).date()
    except ValueError as exc:
        return None, str(exc)

    return {
        "title": title,
        "record_type": record_type,
        "record_type_part": record_type_part,
        "record_date": record_date,
        "cabinet_number": cabinet_number,
        "shelf_number": shelf_number,
        "keywords": keywords or None,
        "remarks": remarks or None,
        "pdf_link": pdf_link or None,
    }, None


def _handle_pdf_upload(record, uploaded_file, manual_link=None):
    if not uploaded_file or not uploaded_file.filename:
        if manual_link:
            record.pdf_link = manual_link
        return None

    filename = secure_filename(uploaded_file.filename)
    if not filename.lower().endswith(".pdf"):
        return "Only PDF files are allowed."

    if drive_configured():
        link, file_id, error = upload_pdf_to_drive(uploaded_file, filename)
        if error:
            return error
        record.pdf_link = link
        record.drive_file_id = file_id
        record.local_file_path = None
        return None

    relative_path = save_pdf_locally(uploaded_file, record.id, filename)
    record.local_file_path = relative_path
    record.drive_file_id = None
    if manual_link:
        record.pdf_link = manual_link
    else:
        record.pdf_link = url_for("rmt_routes.serve_record_pdf", record_id=record.id, _external=True)
    return None


@rmt_routes.route("/login")
def login():
    if "username" in session:
        next_url = safe_login_redirect(
            request.args.get("next"),
            default_endpoint="rmt_routes.dashboard",
        )
        return redirect(next_url)
    return redirect(url_for("main_routes.login", next=request.args.get("next", "/rmt/dashboard")))


@rmt_routes.route("/dashboard")
@login_required
def dashboard():
    user = _current_user()
    if not user:
        flash("User not found. Please log in again.", "danger")
        return redirect(url_for("main_routes.logout"))

    return render_template(
        "rmt_dash.html",
        drive_configured=drive_configured(),
        **_dashboard_context(user),
    )


@rmt_routes.route("/help/rmt-manual")
@login_required
def rmt_user_manual():
    user = _current_user()
    if not user:
        flash("User not found. Please log in again.", "danger")
        return redirect(url_for("main_routes.logout"))

    role = resolve_manual_role(session.get("role"))
    return render_template(
        "user_manual.html",
        manual=get_rmt_manual(role),
        module="rmt",
        module_label="Records Management Tool (RMT)",
        role=role,
        fullname=user.full_name or "Guest",
        office=user.office or "",
        sidebar_help_open=True,
        sidebar_help_page="rmt",
    )


@rmt_routes.route("/get_stats")
@login_required
def get_stats():
    try:
        return jsonify(rmt_dashboard_stats())
    except Exception as exc:
        return jsonify({"error": str(exc)}), 500


@rmt_routes.route("/get_records")
@login_required
def get_records():
    try:
        term = request.args.get("q", "")
        records = search_records_query(term).all()
        return jsonify([serialize_rmt_record(record, include_details=True) for record in records])
    except Exception as exc:
        return jsonify({"error": str(exc)}), 500


@rmt_routes.route("/preview_record_number")
@login_required
def preview_record_number():
    date_str = request.args.get("date")
    try:
        for_date = parse_document_date(date_str) if date_str else local_time()
        return jsonify({"record_number": generate_record_number(for_date)})
    except ValueError as exc:
        return jsonify({"error": str(exc)}), 400


@rmt_routes.route("/add", methods=["GET", "POST"])
@login_required
@staff_or_admin_required
def add_record():
    user = _current_user()
    default_date = local_time().strftime("%Y-%m-%d")
    preview_number = generate_record_number(default_date)

    if request.method == "POST":
        try:
            payload, error = _validate_record_form(request.form)
            if error:
                flash(error, "danger")
                return redirect(url_for("rmt_routes.add_record"))

            record_number = generate_record_number(payload["record_date"])
            record = RmtRecord(
                record_number=record_number,
                encoded_by=user.full_name or session.get("username"),
                **payload,
            )
            db.session.add(record)
            db.session.flush()

            upload_error = _handle_pdf_upload(
                record,
                request.files.get("pdf_file"),
                manual_link=payload.get("pdf_link"),
            )
            if upload_error:
                db.session.rollback()
                flash(upload_error, "danger")
                return redirect(url_for("rmt_routes.add_record"))

            db.session.commit()
            flash("Record saved successfully.", "success")
            return redirect(url_for("rmt_routes.dashboard"))
        except Exception as exc:
            db.session.rollback()
            traceback.print_exc()
            flash(f"Error saving record: {exc}", "danger")
            return redirect(url_for("rmt_routes.add_record"))

    return render_template(
        "rmt_add.html",
        default_date=default_date,
        preview_number=preview_number,
        drive_configured=drive_configured(),
        **_dashboard_context(user),
    )


@rmt_routes.route("/edit/<int:record_id>", methods=["GET", "POST"])
@login_required
@staff_or_admin_required
def edit_record(record_id):
    user = _current_user()
    record = RmtRecord.query.get_or_404(record_id)

    if request.method == "POST":
        try:
            payload, error = _validate_record_form(request.form)
            if error:
                flash(error, "danger")
                return redirect(url_for("rmt_routes.edit_record", record_id=record_id))

            for key, value in payload.items():
                setattr(record, key, value)

            upload_error = _handle_pdf_upload(
                record,
                request.files.get("pdf_file"),
                manual_link=payload.get("pdf_link"),
            )
            if upload_error:
                flash(upload_error, "danger")
                return redirect(url_for("rmt_routes.edit_record", record_id=record_id))

            db.session.commit()
            flash("Record updated successfully.", "success")
            return redirect(url_for("rmt_routes.dashboard"))
        except Exception as exc:
            db.session.rollback()
            traceback.print_exc()
            flash(f"Error updating record: {exc}", "danger")
            return redirect(url_for("rmt_routes.edit_record", record_id=record_id))

    return render_template(
        "rmt_edit.html",
        record=record,
        display_record_type=display_rmt_record_type(record.record_type, record.record_type_part),
        drive_configured=drive_configured(),
        **_dashboard_context(user),
    )


@rmt_routes.route("/delete/<int:record_id>", methods=["POST"])
@login_required
@admin_required
def delete_record(record_id):
    record = RmtRecord.query.get_or_404(record_id)
    try:
        if record.local_file_path:
            file_path = resolve_pdf_path(record.local_file_path)
            if file_path.is_file():
                file_path.unlink()
            parent = file_path.parent
            if parent.exists() and not any(parent.iterdir()):
                parent.rmdir()

        db.session.delete(record)
        db.session.commit()
        return jsonify({"status": "success", "msg": "Record deleted."})
    except Exception as exc:
        db.session.rollback()
        return jsonify({"status": "error", "msg": str(exc)}), 500


@rmt_routes.route("/files/<int:record_id>")
@login_required
def serve_record_pdf(record_id):
    record = RmtRecord.query.get_or_404(record_id)
    if not record.local_file_path:
        flash("No local PDF file is available for this record.", "warning")
        return redirect(url_for("rmt_routes.dashboard"))

    file_path = resolve_pdf_path(record.local_file_path)
    if not file_path.is_file():
        flash("PDF file not found.", "danger")
        return redirect(url_for("rmt_routes.dashboard"))

    return send_file(
        file_path,
        mimetype=guess_pdf_mimetype(file_path.name),
        as_attachment=False,
        download_name=file_path.name,
    )
