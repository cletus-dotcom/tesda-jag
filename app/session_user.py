from types import SimpleNamespace

from flask import session

from app.config import PORTAL_ADMIN_ROLE, PORTAL_ADMIN_USERNAME
from app.models import User

PORTAL_ADMIN_USER = SimpleNamespace(
    user_id=None,
    username=PORTAL_ADMIN_USERNAME,
    full_name="Portal Administrator",
    office="System",
    role=PORTAL_ADMIN_ROLE,
    status="Active",
)


def is_portal_admin_session():
    return session.get("is_portal_admin") is True


def resolve_session_user():
    if is_portal_admin_session():
        return PORTAL_ADMIN_USER
    user_id = session.get("user_id")
    if not user_id:
        return None
    return User.query.get(user_id)
