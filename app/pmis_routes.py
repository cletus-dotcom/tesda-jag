from flask import Blueprint, flash, redirect, render_template, request, session, url_for

from app.auth import login_required
from app.config import can_edit_documents, normalize_role, safe_login_redirect
from app.models import User
from app.session_user import resolve_session_user

pmis_routes = Blueprint("pmis_routes", __name__, url_prefix="/pmis")


def _current_user():
    return resolve_session_user()


def _dashboard_context(user):
    return {
        "fullname": user.full_name or "Guest",
        "role": normalize_role(user.role),
        "office": user.office or "Unknown Office",
        "can_edit": can_edit_documents(user.role),
    }


@pmis_routes.route("/login")
def login():
    if "username" in session:
        next_url = safe_login_redirect(
            request.args.get("next"),
            default_endpoint="pmis_routes.dashboard",
        )
        return redirect(next_url)
    return redirect(url_for("main_routes.login", next=request.args.get("next", "/pmis/dashboard")))


@pmis_routes.route("/dashboard")
@login_required
def dashboard():
    user = _current_user()
    if not user:
        flash("User not found. Please log in again.", "danger")
        return redirect(url_for("main_routes.logout"))

    return render_template(
        "pmis_dash.html",
        **_dashboard_context(user),
    )
