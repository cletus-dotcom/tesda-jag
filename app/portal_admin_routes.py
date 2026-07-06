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

from app.auth import login_required, portal_admin_required
from app.config import can_edit_documents, normalize_role
from app.portal_admin_service import (
    build_dts_template_workbook,
    build_rmt_template_workbook,
    commit_dts_import,
    commit_rmt_import,
    module_record_counts,
    preview_dts_import,
    preview_rmt_import,
    purge_module_data,
    workbook_to_bytes,
)
from app.session_user import resolve_session_user

portal_admin_routes = Blueprint("portal_admin_routes", __name__, url_prefix="/portal-admin")


@portal_admin_routes.route("/")
@login_required
@portal_admin_required
def console():
    user = resolve_session_user()
    return render_template(
        "portal_admin.html",
        fullname=user.full_name or "Portal Administrator",
        role=normalize_role(user.role),
        office=user.office or "System",
        can_edit=can_edit_documents(user.role),
        counts=module_record_counts(),
    )


@portal_admin_routes.route("/template/dts")
@login_required
@portal_admin_required
def download_dts_template():
    workbook = build_dts_template_workbook()
    return send_file(
        workbook_to_bytes(workbook),
        as_attachment=True,
        download_name="dts_docs_import_template.xlsx",
        mimetype="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    )


@portal_admin_routes.route("/template/rmt")
@login_required
@portal_admin_required
def download_rmt_template():
    workbook = build_rmt_template_workbook()
    return send_file(
        workbook_to_bytes(workbook),
        as_attachment=True,
        download_name="rmt_records_import_template.xlsx",
        mimetype="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    )


def _preview_response(upload, preview_func):
    if not upload or not upload.filename:
        return jsonify({"ok": False, "errors": ["No file uploaded."]}), 400
    if not upload.filename.lower().endswith((".xlsx", ".xlsm")):
        return jsonify({"ok": False, "errors": ["Only Excel (.xlsx) files are supported."]}), 400
    result = preview_func(upload)
    status = 200 if result.get("ok") else 400
    return jsonify(result), status


@portal_admin_routes.route("/import/dts/preview", methods=["POST"])
@login_required
@portal_admin_required
def import_dts_preview():
    try:
        return _preview_response(request.files.get("file"), preview_dts_import)
    except Exception as exc:
        traceback.print_exc()
        return jsonify({"ok": False, "errors": [str(exc)]}), 500


@portal_admin_routes.route("/import/rmt/preview", methods=["POST"])
@login_required
@portal_admin_required
def import_rmt_preview():
    try:
        return _preview_response(request.files.get("file"), preview_rmt_import)
    except Exception as exc:
        traceback.print_exc()
        return jsonify({"ok": False, "errors": [str(exc)]}), 500


@portal_admin_routes.route("/import/dts", methods=["POST"])
@login_required
@portal_admin_required
def import_dts_commit():
    try:
        payload = request.get_json(silent=True) or {}
        rows = payload.get("rows") or []
        if not rows:
            return jsonify({"ok": False, "message": "No validated rows to import."}), 400

        invalid = [row for row in rows if not row.get("valid")]
        if invalid:
            return jsonify({
                "ok": False,
                "message": "Import blocked. Fix invalid rows before uploading.",
                "invalid_count": len(invalid),
            }), 400

        created = commit_dts_import(
            rows,
            session.get("fullname", "Portal Administrator"),
            request.remote_addr,
        )
        return jsonify({"ok": True, "created": created, "message": f"Imported {created} DTS record(s)."})
    except Exception as exc:
        traceback.print_exc()
        return jsonify({"ok": False, "message": str(exc)}), 500


@portal_admin_routes.route("/import/rmt", methods=["POST"])
@login_required
@portal_admin_required
def import_rmt_commit():
    try:
        payload = request.get_json(silent=True) or {}
        rows = payload.get("rows") or []
        if not rows:
            return jsonify({"ok": False, "message": "No validated rows to import."}), 400

        invalid = [row for row in rows if not row.get("valid")]
        if invalid:
            return jsonify({
                "ok": False,
                "message": "Import blocked. Fix invalid rows before uploading.",
                "invalid_count": len(invalid),
            }), 400

        created = commit_rmt_import(rows)
        return jsonify({"ok": True, "created": created, "message": f"Imported {created} RMT record(s)."})
    except Exception as exc:
        traceback.print_exc()
        return jsonify({"ok": False, "message": str(exc)}), 500


@portal_admin_routes.route("/purge/<string:module_key>", methods=["POST"])
@login_required
@portal_admin_required
def purge_module(module_key):
    try:
        data = request.get_json(silent=True) or {}
        confirm_text = (data.get("confirm_text") or "").strip()
        expected = f"PURGE {module_key.upper()}"
        if confirm_text != expected:
            return jsonify({
                "ok": False,
                "message": f"Confirmation text must be exactly '{expected}'.",
            }), 400

        result = purge_module_data(module_key)
        return jsonify({"ok": True, **result})
    except ValueError as exc:
        return jsonify({"ok": False, "message": str(exc)}), 400
    except Exception as exc:
        traceback.print_exc()
        return jsonify({"ok": False, "message": str(exc)}), 500
