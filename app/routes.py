import os
import traceback
from datetime import datetime
from io import BytesIO

from flask import (
    Blueprint,
    current_app,
    flash,
    jsonify,
    redirect,
    render_template,
    request,
    send_file,
    session,
    url_for,
)
from werkzeug.security import generate_password_hash

from app import db
from app.auth import admin_required, login_required, staff_or_admin_required
from app.models import DeptRef, DtsDoc, DtsHistory, User, log_history
from app.config import (
    display_action_needed,
    display_doc_type,
    display_recipient,
    is_valid_action_needed,
    is_valid_doc_type,
    parse_action_fields,
    parse_doc_type_fields,
    parse_recipient_fields,
    resolve_origin_fields,
    can_edit_documents,
    is_admin_role,
    is_reserved_username,
    is_valid_user_role,
    normalize_role,
    safe_login_redirect,
    verify_portal_admin_credentials,
    PORTAL_ADMIN_ROLE,
    PORTAL_ADMIN_USERNAME,
)
from app.dept_service import (
    apply_department_rename,
    department_in_use,
    list_departments,
    validate_dept_fields,
)
from app.dashboard_service import (
    inbound_docs_query,
    office_dashboard_stats,
    office_today_transactions_query,
    outbound_docs_query,
    serialize_dashboard_doc,
)
from app.about_content import (
    ABOUT_DEVELOPER,
    ABOUT_EXTRAS,
    ABOUT_FEATURES,
    ABOUT_FLOW,
    ABOUT_PLATFORM,
)
from app.manual_content import get_dts_manual, resolve_manual_role
from app.portal_service import portal_pulse_data, portal_search
from app.session_user import is_portal_admin_session, resolve_session_user
from app.utils import backup_tesda_db, generate_route_number, local_time, parse_document_date

main_routes = Blueprint("main_routes", __name__)


@main_routes.route("/")
def index():
    return render_template("index.html")


@main_routes.route("/portal/pulse")
def portal_pulse():
    try:
        return jsonify(portal_pulse_data())
    except Exception as exc:
        return jsonify({"error": str(exc)}), 500


@main_routes.route("/portal/search")
def portal_search_route():
    try:
        return jsonify({"results": portal_search(request.args.get("q", ""))})
    except Exception as exc:
        return jsonify({"error": str(exc)}), 500


@main_routes.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("main_routes.index"))


@main_routes.route("/login", methods=["GET", "POST"])
def login():
    try:
        next_param = request.args.get("next", "")

        if request.method == "POST":
            data = request.get_json() if request.is_json else request.form
            username = data.get("username", "").strip()
            password = data.get("password", "").strip()
            next_param = data.get("next", next_param)

            user = db.session.query(User).filter_by(username=username).first()

            if verify_portal_admin_credentials(username, password):
                session.clear()
                session["username"] = PORTAL_ADMIN_USERNAME
                session["fullname"] = "Portal Administrator"
                session["role"] = PORTAL_ADMIN_ROLE
                session["is_portal_admin"] = True

                redirect_to = safe_login_redirect(
                    next_param,
                    default_endpoint="portal_admin_routes.console",
                )

                if request.is_json:
                    return jsonify({"success": True, "redirect": redirect_to})

                flash("Login successful", "success")
                return redirect(redirect_to)

            if user and user.check_password(password):
                session["user_id"] = user.user_id
                session["username"] = user.username
                session["fullname"] = user.full_name
                session["role"] = normalize_role(user.role)

                redirect_to = safe_login_redirect(next_param)

                if request.is_json:
                    return jsonify({"success": True, "redirect": redirect_to})

                flash("Login successful", "success")
                return redirect(redirect_to)

            message = "Invalid credentials"
            if request.is_json:
                return jsonify({"success": False, "message": message})
            flash(message, "danger")

        return render_template("login.html", next_url=next_param)

    except Exception as e:
        traceback.print_exc()
        return jsonify({"success": False, "message": f"Internal Server Error: {str(e)}"}), 500


@main_routes.route("/dashboard")
@login_required
def dashboard():
    user = resolve_session_user()

    if not user:
        flash("User not found. Please log in again.", "danger")
        return redirect(url_for("main_routes.logout"))

    return render_template(
        "dash.html",
        fullname=user.full_name or "Guest",
        role=normalize_role(user.role),
        office=user.office or "Unknown Office",
        can_edit=can_edit_documents(user.role),
    )


@main_routes.route("/help/dts-manual")
@login_required
def dts_user_manual():
    user = resolve_session_user()
    if not user:
        flash("User not found. Please log in again.", "danger")
        return redirect(url_for("main_routes.logout"))

    role = resolve_manual_role(session.get("role"))
    return render_template(
        "user_manual.html",
        manual=get_dts_manual(role),
        module="dts",
        module_label="Document Tracking System (DTS)",
        role=role,
        fullname=user.full_name or "Guest",
        office=user.office or "",
        sidebar_help_open=True,
        sidebar_help_page="dts",
    )


@main_routes.route("/help/about")
@login_required
def about_platform():
    user = resolve_session_user()
    if not user:
        flash("User not found. Please log in again.", "danger")
        return redirect(url_for("main_routes.logout"))

    return render_template(
        "about.html",
        platform=ABOUT_PLATFORM,
        features=ABOUT_FEATURES,
        process_flow=ABOUT_FLOW,
        developer=ABOUT_DEVELOPER,
        extras=ABOUT_EXTRAS,
        fullname=user.full_name or "Guest",
    )


@main_routes.route("/register_admin", methods=["GET", "POST"])
def register_admin():
    if User.query.count() > 0:
        flash("Admin registration is only available for initial setup.", "warning")
        return redirect(url_for("main_routes.login"))

    if request.method == "POST":
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "").strip()
        full_name = request.form.get("full_name", "").strip() or "System Administrator"

        if not username or not password:
            flash("All fields are required.", "danger")
            return redirect(url_for("main_routes.register_admin"))

        if is_reserved_username(username):
            flash("That username is reserved.", "danger")
            return redirect(url_for("main_routes.register_admin"))

        if User.query.filter_by(username=username).first():
            flash("Username already exists.", "danger")
            return redirect(url_for("main_routes.register_admin"))

        new_admin = User(
            username=username,
            full_name=full_name,
            office="Administrative",
            role="Admin",
            status="Active",
            password_hash=generate_password_hash(password),
        )
        db.session.add(new_admin)
        db.session.commit()

        flash("Admin user created successfully! You can now log in.", "success")
        return redirect(url_for("main_routes.login"))

    return render_template("register_admin.html")


@main_routes.route("/has_users")
def has_users():
    return jsonify({"has_users": User.query.count() > 0})


@main_routes.route("/list_users")
@login_required
@admin_required
def list_users():
    users = User.query.order_by(User.user_id.asc()).all()
    user_data = [{
        "id": u.user_id,
        "username": u.username,
        "full_name": u.full_name,
        "office": u.office,
        "email": u.email,
        "role": u.role,
        "status": u.status,
    } for u in users if not is_reserved_username(u.username)]
    return jsonify({"users": user_data})


@main_routes.route("/admin/update_user/<int:user_id>", methods=["POST"])
@login_required
@admin_required
def update_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({"status": "error", "msg": "User not found"}), 404

    password = request.form.get("password", "").strip()
    if password:
        user.password_hash = generate_password_hash(password)

    user.username = request.form.get("username", user.username)
    if is_reserved_username(user.username):
        return jsonify({"status": "error", "msg": "That username is reserved."}), 400
    user.full_name = request.form.get("full_name", user.full_name)
    user.office = request.form.get("office", user.office)
    user.email = request.form.get("email", user.email)
    role = request.form.get("role", user.role)
    if not is_valid_user_role(role):
        return jsonify({"status": "error", "msg": "Invalid role selected."}), 400
    user.role = normalize_role(role)

    try:
        db.session.commit()
        return jsonify({"status": "success", "msg": f"User '{user.username}' updated successfully."})
    except Exception as e:
        db.session.rollback()
        return jsonify({"status": "error", "msg": f"Database error: {str(e)}"}), 500


@main_routes.route("/account/change_password", methods=["POST"])
@login_required
def change_password():
    if is_portal_admin_session():
        return jsonify({
            "status": "error",
            "msg": "Portal administrator accounts cannot be changed here.",
        }), 403

    user = User.query.get(session.get("user_id"))
    if not user:
        return jsonify({"status": "error", "msg": "User not found. Please log in again."}), 404

    data = request.get_json(silent=True) or request.form
    current_password = data.get("current_password", "").strip()
    new_password = data.get("new_password", "").strip()
    confirm_password = data.get("confirm_password", "").strip()

    if not current_password or not new_password or not confirm_password:
        return jsonify({"status": "error", "msg": "All password fields are required."})
    if len(new_password) < 6:
        return jsonify({"status": "error", "msg": "New password must be at least 6 characters."})
    if new_password != confirm_password:
        return jsonify({"status": "error", "msg": "New passwords do not match."})
    if not user.check_password(current_password):
        return jsonify({"status": "error", "msg": "Current password is incorrect."})
    if user.check_password(new_password):
        return jsonify({"status": "error", "msg": "New password must be different from the current password."})

    try:
        user.set_password(new_password)
        db.session.commit()
        return jsonify({"status": "success", "msg": "Password changed successfully."})
    except Exception as e:
        db.session.rollback()
        return jsonify({"status": "error", "msg": f"Database error: {str(e)}"}), 500


@main_routes.route("/admin/delete_user", methods=["DELETE"])
@login_required
@admin_required
def delete_user():
    data = request.get_json()
    user = User.query.get(data.get("user_id"))
    if not user:
        return jsonify({"status": "error", "msg": "User not found"}), 404

    try:
        db.session.delete(user)
        db.session.commit()
        return jsonify({"status": "success", "msg": f"User '{user.username}' deleted successfully."})
    except Exception as e:
        db.session.rollback()
        return jsonify({"status": "error", "msg": f"Error deleting user: {str(e)}"}), 500


@main_routes.route("/admin/add_user", methods=["POST"])
@login_required
@admin_required
def add_user():
    try:
        username = request.form.get("username", "").strip()
        full_name = request.form.get("full_name", "").strip()
        office = request.form.get("office", "").strip()
        email = request.form.get("email", "").strip()
        role = request.form.get("role", "").strip()
        password = request.form.get("password", "").strip()

        if not username or not password or not full_name or not role:
            return jsonify({"status": "error", "msg": "All required fields must be filled."})
        if not is_valid_user_role(role):
            return jsonify({"status": "error", "msg": "Invalid role selected."})

        if is_reserved_username(username):
            return jsonify({"status": "error", "msg": "That username is reserved."})

        if User.query.filter_by(username=username).first():
            return jsonify({"status": "error", "msg": "Username already exists."})
        if email and User.query.filter_by(email=email).first():
            return jsonify({"status": "error", "msg": "Email already exists."})

        new_user = User(
            username=username,
            full_name=full_name,
            office=office,
            email=email,
            role=normalize_role(role),
            status="Active",
            password_hash=generate_password_hash(password),
        )
        db.session.add(new_user)
        db.session.commit()
        return jsonify({"status": "success", "msg": f"User '{username}' added successfully."})

    except Exception as e:
        db.session.rollback()
        return jsonify({"status": "error", "msg": f"Database error: {str(e)}"}), 500


@main_routes.route("/get_dashboard_stats")
@login_required
def get_dashboard_stats():
    user = resolve_session_user()
    if not user:
        return jsonify({"error": "User not found"}), 404
    try:
        return jsonify(office_dashboard_stats(user.office))
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@main_routes.route("/get_todays_docs")
@login_required
def get_todays_docs():
    user = resolve_session_user()
    if not user:
        return jsonify({"error": "User not found"}), 404

    try:
        docs = office_today_transactions_query(user.office).all()
        return jsonify([serialize_dashboard_doc(doc, include_details=True) for doc in docs])
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@main_routes.route("/get_inbound_docs")
@login_required
def get_inbound_docs():
    user = resolve_session_user()
    if not user:
        return jsonify({"error": "User not found"}), 404

    try:
        docs = inbound_docs_query().all()
        return jsonify([serialize_dashboard_doc(doc, include_details=True) for doc in docs])
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@main_routes.route("/get_outbound_docs")
@login_required
def get_outbound_docs():
    user = resolve_session_user()
    if not user:
        return jsonify({"error": "User not found"}), 404

    try:
        docs = outbound_docs_query().all()
        return jsonify([serialize_dashboard_doc(doc, include_details=True) for doc in docs])
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@main_routes.route("/view_history/<string:route_number>")
@login_required
def view_history(route_number):
    try:
        doc = DtsDoc.query.filter_by(route_number=route_number).first()
        histories = (
            DtsHistory.query
            .filter_by(route_number=route_number)
            .order_by(DtsHistory.date_updated.desc())
            .all()
        )
        return render_template(
            "history.html",
            doc=doc,
            histories=histories,
            route_number=route_number,
        )
    except Exception as e:
        return render_template("history.html", histories=[], route_number=route_number, error=str(e))


@main_routes.route("/update_document/<string:route_number>")
@login_required
@staff_or_admin_required
def update_document(route_number):
    doc = DtsDoc.query.filter_by(route_number=route_number).first()
    if not doc:
        flash("Document not found.", "warning")
        return redirect(url_for("portal_admin_routes.console") if is_portal_admin_session() else url_for("main_routes.dashboard"))
    return render_template("update_document.html", doc=doc)


@main_routes.route("/save_update/<string:route_number>", methods=["POST"])
@login_required
@staff_or_admin_required
def save_update(route_number):
    doc = DtsDoc.query.filter_by(route_number=route_number).first()
    if not doc:
        flash("Document not found.", "danger")
        return redirect(url_for("portal_admin_routes.console") if is_portal_admin_session() else url_for("main_routes.dashboard"))

    try:
        doc.classification = request.form.get("classification")
        doc_type, doc_type_part, doc_type_error = parse_doc_type_fields(
            request.form.get("doc_type"),
            request.form.get("doc_type_part"),
        )
        if doc_type_error:
            flash(doc_type_error, "danger")
            return redirect(url_for("main_routes.update_document", route_number=route_number))
        if not is_valid_doc_type(doc.classification, doc_type):
            flash("Invalid document type for the selected classification.", "danger")
            return redirect(url_for("main_routes.update_document", route_number=route_number))
        doc.doc_type = doc_type
        doc.doc_type_part = doc_type_part
        doc.date_received = request.form.get("date_received")
        doc.status = request.form.get("status")
        origin, other_office, origin_error = resolve_origin_fields(
            doc.classification,
            request.form.get("origin"),
            request.form.get("other_office"),
        )
        if origin_error:
            flash(origin_error, "danger")
            return redirect(url_for("main_routes.update_document", route_number=route_number))
        doc.origin = origin
        doc.other_office = other_office
        doc.subject = request.form.get("subject")
        action_needed, action_part, action_error = parse_action_fields(
            request.form.get("action_needed"),
            request.form.get("action_part"),
        )
        if action_error:
            flash(action_error, "danger")
            return redirect(url_for("main_routes.update_document", route_number=route_number))
        if not is_valid_action_needed(doc.classification, action_needed):
            flash("Invalid action needed for the selected classification.", "danger")
            return redirect(url_for("main_routes.update_document", route_number=route_number))
        doc.action_needed = action_needed
        doc.action_part = action_part
        doc.action_particulars = (request.form.get("action_particulars") or "").strip() or None
        doc.responsible_person = request.form.get("responsible_person")
        doc.resp_unit = request.form.get("resp_unit")
        forwarded_to, forwarded_to_part, recipient_error = parse_recipient_fields(
            doc.classification,
            request.form.get("forwarded_to"),
            request.form.get("forwarded_to_part"),
        )
        if recipient_error:
            flash(recipient_error, "danger")
            return redirect(url_for("main_routes.update_document", route_number=route_number))
        doc.forwarded_to = forwarded_to
        doc.forwarded_to_part = forwarded_to_part
        doc.action_provided = request.form.get("action_provided")
        doc.remarks = request.form.get("remarks")
        doc.date_updated = local_time()

        db.session.commit()
        log_history(doc, user_name=session.get("fullname", "Unknown"), ip_address=request.remote_addr)
        flash("Document successfully updated and logged.", "success")

    except Exception as e:
        db.session.rollback()
        flash(f"An error occurred while updating: {str(e)}", "danger")

    return redirect(url_for("portal_admin_routes.console") if is_portal_admin_session() else url_for("main_routes.dashboard"))


@main_routes.route("/add_document", methods=["GET", "POST"])
@login_required
@staff_or_admin_required
def add_document():
    user = resolve_session_user()
    if not user:
        flash("User not found. Please re-login.", "danger")
        return redirect(url_for("main_routes.login"))

    if is_portal_admin_session():
        dept = DeptRef.query.filter_by(dept_name="Administrative").first()
    else:
        dept = DeptRef.query.filter_by(dept_name=user.office).first()
    if not dept:
        flash(f"No department found for office '{user.office}'. Contact admin.", "danger")
        return redirect(url_for("portal_admin_routes.console") if is_portal_admin_session() else url_for("main_routes.dashboard"))

    if request.method == "POST":
        try:
            classification = request.form.get("classification")
            doc_type, doc_type_part, doc_type_error = parse_doc_type_fields(
                request.form.get("doc_type"),
                request.form.get("doc_type_part"),
            )
            if doc_type_error:
                flash(doc_type_error, "danger")
                return redirect(url_for("main_routes.add_document"))
            if not is_valid_doc_type(classification, doc_type):
                flash("Invalid document type for the selected classification.", "danger")
                return redirect(url_for("main_routes.add_document"))

            action_needed, action_part, action_error = parse_action_fields(
                request.form.get("action_needed"),
                request.form.get("action_part"),
            )
            if action_error:
                flash(action_error, "danger")
                return redirect(url_for("main_routes.add_document"))
            if not is_valid_action_needed(classification, action_needed):
                flash("Invalid action needed for the selected classification.", "danger")
                return redirect(url_for("main_routes.add_document"))

            origin, other_office, origin_error = resolve_origin_fields(
                classification,
                request.form.get("origin"),
                request.form.get("other_office"),
            )
            if origin_error:
                flash(origin_error, "danger")
                return redirect(url_for("main_routes.add_document"))

            forwarded_to, forwarded_to_part, recipient_error = parse_recipient_fields(
                classification,
                request.form.get("forwarded_to"),
                request.form.get("forwarded_to_part"),
            )
            if recipient_error:
                flash(recipient_error, "danger")
                return redirect(url_for("main_routes.add_document"))

            date_received_str = request.form.get("date_received")
            try:
                doc_date = parse_document_date(date_received_str)
            except ValueError as exc:
                flash(str(exc), "danger")
                return redirect(url_for("main_routes.add_document"))

            try:
                route_number, _, _ = generate_route_number(doc_date)
            except ValueError as exc:
                flash(str(exc), "danger")
                return redirect(url_for("main_routes.add_document"))

            new_doc = DtsDoc(
                route_number=route_number,
                classification=classification,
                doc_type=doc_type,
                doc_type_part=doc_type_part,
                date_received=doc_date.date(),
                origin=origin,
                other_office=other_office,
                subject=request.form.get("subject"),
                action_needed=action_needed,
                action_part=action_part,
                action_particulars=(request.form.get("action_particulars") or "").strip() or None,
                resp_unit=request.form.get("resp_unit"),
                responsible_person=request.form.get("responsible_person"),
                forwarded_to=forwarded_to,
                forwarded_to_part=forwarded_to_part,
                action_provided=request.form.get("action_provided"),
                status=request.form.get("status"),
                remarks=request.form.get("remarks"),
                date_encoded=local_time(),
            )
            db.session.add(new_doc)
            db.session.commit()
            log_history(new_doc, session.get("fullname", "Unknown"), request.remote_addr)
            flash(f"Document #{route_number} added successfully!", "success")
            return redirect(url_for("portal_admin_routes.console") if is_portal_admin_session() else url_for("main_routes.dashboard"))
        except Exception as e:
            db.session.rollback()
            flash(f"Error adding document: {e}", "danger")
            return redirect(url_for("main_routes.add_document"))

    today = local_time().date()
    route_number, _, _ = generate_route_number(today)
    return render_template(
        "add_document.html",
        preview_route=route_number,
        default_date=today.isoformat(),
    )


@main_routes.route("/preview_route_number")
@login_required
@staff_or_admin_required
def preview_route_number():
    date_str = request.args.get("date")
    try:
        doc_date = parse_document_date(date_str) if date_str else local_time()
        route_number, _, date_prefix = generate_route_number(doc_date)
    except ValueError as exc:
        return jsonify({"error": str(exc)}), 400
    return jsonify({"route_number": route_number, "date_prefix": date_prefix})


@main_routes.route("/validate_route_number", methods=["POST"])
@login_required
@staff_or_admin_required
def validate_route_number():
    data = request.get_json() or {}
    check_number = str(data.get("route_number", "")).strip()
    date_str = data.get("date")
    try:
        doc_date = parse_document_date(date_str) if date_str else local_time()
        latest_number, _, date_prefix = generate_route_number(doc_date)
    except ValueError as exc:
        return jsonify({"error": str(exc)}), 400

    if not check_number:
        return jsonify({
            "exists": False,
            "latest_number": latest_number,
            "date_prefix": date_prefix,
        })

    if len(check_number) != 8 or not check_number.isdigit():
        return jsonify({"error": "Invalid document number format (expected YYMMDDNN)"}), 400

    existing_doc = DtsDoc.query.filter_by(route_number=check_number).first()
    return jsonify({
        "exists": bool(existing_doc),
        "latest_number": latest_number,
        "date_prefix": date_prefix,
    })


@main_routes.route("/list_docs")
@login_required
def list_docs():
    try:
        docs = DtsDoc.query.order_by(DtsDoc.date_received.desc()).all()
        role = session.get("role")
        can_edit = can_edit_documents(role)
        is_admin = is_admin_role(role)
        return render_template("list_docs.html", docs=docs, can_edit=can_edit, is_admin=is_admin)
    except Exception as e:
        return render_template("list_docs.html", docs=[], can_edit=False, is_admin=False, error=str(e))


@main_routes.route("/delete_document/<route_number>", methods=["POST"])
@login_required
@admin_required
def delete_document(route_number):
    try:
        doc = DtsDoc.query.filter_by(route_number=route_number).first()
        if not doc:
            return jsonify({"success": False, "message": "Document not found"})
        db.session.delete(doc)
        db.session.commit()
        return jsonify({"success": True})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)})


@main_routes.route("/dept_ref_code")
@login_required
@admin_required
def dept_ref_code():
    return render_template("dept_ref_code.html", departments=list_departments())


@main_routes.route("/dept_ref/add", methods=["POST"])
@login_required
@admin_required
def add_dept_ref():
    data = request.get_json() or {}
    dept_name, dept_code, error = validate_dept_fields(
        data.get("dept_name"),
        data.get("dept_code"),
    )
    if error:
        return jsonify({"success": False, "message": error})

    try:
        db.session.add(DeptRef(dept_name=dept_name, dept_code=dept_code))
        db.session.commit()
        return jsonify({"success": True, "message": "Department added successfully!"})
    except Exception as e:
        db.session.rollback()
        return jsonify({"success": False, "message": str(e)})


@main_routes.route("/dept_ref/update/<int:id>", methods=["PUT"])
@login_required
@admin_required
def update_dept_ref(id):
    data = request.get_json() or {}
    dept = DeptRef.query.get(id)
    if not dept:
        return jsonify({"success": False, "message": "Department not found."})

    dept_name, dept_code, error = validate_dept_fields(
        data.get("dept_name"),
        data.get("dept_code"),
        exclude_id=id,
    )
    if error:
        return jsonify({"success": False, "message": error})

    try:
        old_name = dept.dept_name
        dept.dept_name = dept_name
        dept.dept_code = dept_code
        apply_department_rename(old_name, dept_name)
        db.session.commit()
        return jsonify({
            "success": True,
            "message": "Department updated successfully!",
            "department": {
                "id": dept.id,
                "dept_name": dept.dept_name,
                "dept_code": dept.dept_code,
            },
        })
    except Exception as e:
        db.session.rollback()
        return jsonify({"success": False, "message": str(e)})


@main_routes.route("/dept_ref/delete/<int:id>", methods=["DELETE"])
@login_required
@admin_required
def delete_dept_ref(id):
    dept = DeptRef.query.get(id)
    if not dept:
        return jsonify({"success": False, "message": "Department not found."})

    if department_in_use(dept.dept_name):
        return jsonify({
            "success": False,
            "message": "Cannot delete a department that is assigned to users or documents.",
        })

    if DeptRef.query.count() <= 1:
        return jsonify({"success": False, "message": "At least one department must remain."})

    try:
        db.session.delete(dept)
        db.session.commit()
        return jsonify({"success": True, "message": "Department deleted successfully!"})
    except Exception as e:
        db.session.rollback()
        return jsonify({"success": False, "message": str(e)})


@main_routes.route("/export_docs_pdf")
@login_required
def export_docs_pdf():
    from reportlab.lib import colors
    from reportlab.lib.enums import TA_CENTER, TA_LEFT
    from reportlab.lib.pagesizes import landscape, legal
    from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
    from reportlab.lib.units import inch
    from reportlab.platypus import Image, Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle

    buffer = BytesIO()
    docs = DtsDoc.query.order_by(DtsDoc.origin.asc(), DtsDoc.route_number.asc()).all()

    page_size = landscape(legal)
    margin = 0.5 * inch
    printable_width = page_size[0] - (2 * margin)

    pdf = SimpleDocTemplate(
        buffer,
        pagesize=page_size,
        leftMargin=margin,
        rightMargin=margin,
        topMargin=margin,
        bottomMargin=margin,
    )

    elements = []
    styles = getSampleStyleSheet()
    wrap_style = ParagraphStyle("wrap_style", parent=styles["Normal"], fontSize=9, leading=11, alignment=TA_LEFT)

    logo_path = os.path.join(current_app.static_folder, "images", "tesda_logo.png")
    logo = Image(logo_path, width=50, height=50) if os.path.exists(logo_path) else Paragraph("TESDA", styles["Normal"])

    header_style = ParagraphStyle("header", parent=styles["Normal"], fontSize=12, leading=14)
    subheader_style = ParagraphStyle("subheader", parent=styles["Normal"], fontSize=10, leading=12)
    title_style = ParagraphStyle("title_center", parent=styles["Heading1"], fontSize=14, alignment=TA_CENTER)

    header_block = [
        Paragraph("TESDA Provincial Training Center - Jagna", header_style),
        Paragraph("Jagna, Bohol", subheader_style),
    ]

    header_table = Table(
        [[logo, header_block]],
        colWidths=[70, printable_width - 70],
        style=[("VALIGN", (0, 0), (-1, -1), "MIDDLE"), ("LEFTPADDING", (0, 0), (-1, -1), 0)],
    )

    elements.extend([header_table, Spacer(1, 12), Paragraph("List of Documents", title_style), Spacer(1, 10)])

    table_data = [["Doc #", "Class", "Origin", "Subject", "Status", "Action Provided", "Forwarded / Submitted To"]]
    for d in docs:
        table_data.append([
            d.route_number,
            d.classification or "",
            d.origin or "",
            Paragraph(d.subject or "", wrap_style),
            d.status or "",
            Paragraph(d.action_provided or "", wrap_style),
            display_recipient(d.forwarded_to, d.forwarded_to_part, d.classification),
        ])

    col_widths = [
        printable_width * 0.09,
        printable_width * 0.06,
        printable_width * 0.06,
        printable_width * 0.44,
        printable_width * 0.09,
        printable_width * 0.17,
        printable_width * 0.09,
    ]
    col_widths[-1] += printable_width - sum(col_widths)

    table = Table(table_data, colWidths=col_widths, repeatRows=1)
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#0033A0")),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.whitesmoke),
        ("ALIGN", (0, 0), (-1, -1), "LEFT"),
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
        ("FONTSIZE", (0, 0), (-1, 0), 10),
        ("GRID", (0, 0), (-1, -1), 0.5, colors.black),
        ("FONTNAME", (0, 1), (-1, -1), "Helvetica"),
        ("FONTSIZE", (0, 1), (-1, -1), 9),
        ("VALIGN", (0, 1), (-1, -1), "TOP"),
    ]))

    elements.append(table)
    pdf.build(elements)
    buffer.seek(0)

    return send_file(buffer, as_attachment=True, download_name="document_list.pdf", mimetype="application/pdf")


@main_routes.route("/backup_database")
@login_required
@admin_required
def backup_database():
    from app.database import is_serverless_runtime

    if is_serverless_runtime():
        flash(
            "Database backup is not available on serverless hosting. "
            "Use Supabase Dashboard → Database → Backups instead.",
            "warning",
        )
        return redirect(
            url_for("portal_admin_routes.console")
            if is_portal_admin_session()
            else url_for("main_routes.dashboard")
        )

    try:
        from app.config import DB_CONFIG
        os.environ["PGPASSWORD"] = DB_CONFIG["db_pass"]
        backup_file = backup_tesda_db(
            host=DB_CONFIG["db_ip"],
            port=DB_CONFIG["db_port"],
            user=DB_CONFIG["db_user"],
            db_name=DB_CONFIG["db_name"],
        )
        flash(f"Backup completed successfully! File saved at: {backup_file}", "success")
    except Exception as e:
        flash(f"Backup failed: {e}", "danger")

    return redirect(url_for("portal_admin_routes.console") if is_portal_admin_session() else url_for("main_routes.dashboard"))


@main_routes.errorhandler(Exception)
def handle_exception(e):
    traceback.print_exc()
    return f"Internal Server Error: {str(e)}", 500
