from functools import wraps

from flask import flash, jsonify, redirect, request, session, url_for

from app.config import can_edit_documents, is_admin_role, is_portal_admin_role
from app.session_user import is_portal_admin_session


def _is_rmt_request():
    return request.blueprint == "rmt_routes" or request.path.startswith("/rmt")


def _is_pmis_request():
    return request.blueprint == "pmis_routes" or request.path.startswith("/pmis")


def _login_redirect():
    return redirect(url_for("main_routes.login", next=request.path))


def _edit_denied_redirect():
    if _is_rmt_request():
        return redirect(url_for("rmt_routes.dashboard"))
    if _is_pmis_request():
        return redirect(url_for("pmis_routes.dashboard"))
    return redirect(url_for("main_routes.dashboard"))


def _admin_denied_redirect():
    return _edit_denied_redirect()


def login_required(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        if "username" not in session:
            flash("Please login first.", "warning")
            return _login_redirect()
        return func(*args, **kwargs)

    return wrapper


def staff_or_admin_required(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        if not can_edit_documents(session.get("role")):
            if request.is_json or request.method in ("POST", "PUT", "DELETE"):
                return jsonify({
                    "status": "error",
                    "msg": "You do not have permission to perform this action.",
                    "success": False,
                }), 403
            flash("You do not have permission to perform this action.", "danger")
            return _edit_denied_redirect()
        return func(*args, **kwargs)

    return wrapper


def admin_required(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        role = session.get("role")
        if not is_admin_role(role) and not is_portal_admin_session():
            if request.is_json or request.method in ("POST", "PUT", "DELETE"):
                return jsonify({
                    "status": "error",
                    "msg": "Unauthorized",
                    "success": False,
                    "message": "Unauthorized",
                }), 403
            flash("Access denied. Admins only.", "danger")
            return _admin_denied_redirect()
        return func(*args, **kwargs)

    return wrapper


def portal_admin_required(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        if not is_portal_admin_session():
            if request.is_json or request.method in ("POST", "PUT", "DELETE"):
                return jsonify({
                    "status": "error",
                    "msg": "Portal administrator access required.",
                    "success": False,
                    "message": "Portal administrator access required.",
                }), 403
            flash("Portal administrator access required.", "danger")
            return redirect(url_for("main_routes.dashboard"))
        return func(*args, **kwargs)

    return wrapper
