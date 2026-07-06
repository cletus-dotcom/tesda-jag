import logging
import os
from pathlib import Path

from dotenv import load_dotenv
from flask import Flask, send_from_directory
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy

from app.database import (
    build_database_url,
    is_production,
    should_bootstrap_database,
    sqlalchemy_engine_options,
    writable_upload_root,
)
from app.config import (
    ACTIONS_NEEDED,
    INBOUND_ACTIONS_NEEDED,
    OUTBOUND_ACTIONS_NEEDED,
    display_action_needed,
    display_doc_type,
    display_recipient,
    DB_CONFIG,
    DEFAULT_DEPARTMENTS,
    DEFAULT_DEPT_CODES,
    LEGACY_DEPT_CODES,
    DOCUMENT_TYPES,
    INBOUND_DOCUMENT_TYPES,
    OUTBOUND_DOCUMENT_TYPES,
    SUBMITTED_TO_OPTIONS,
    recipient_label_for,
    CLASSIFICATIONS,
    OUTBOUND_DEFAULT_ORIGIN,
    ORIGINS,
    SECRET_KEY,
    STATUSES,
    TESDA_BLUE,
    TESDA_BLUE_DARK,
    TESDA_BLUE_LIGHT,
    USER_ROLES,
    can_edit_documents,
    is_admin_role,
    is_portal_admin_role,
    is_valid_user_role,
    RMT_RECORD_TYPES,
    display_rmt_record_type,
)

db = SQLAlchemy()


def create_app():
    base = Path(__file__).parent
    template_folder = str((base.parent / "templates").resolve())
    static_folder = str((base.parent / "static").resolve())

    app = Flask(__name__, template_folder=template_folder, static_folder=static_folder)
    app.secret_key = SECRET_KEY
    CORS(app)

    load_dotenv(base.parent / ".env")

    app.config["SQLALCHEMY_DATABASE_URI"] = build_database_url(DB_CONFIG)
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.config["SQLALCHEMY_ENGINE_OPTIONS"] = sqlalchemy_engine_options()

    if is_production():
        app.config["SESSION_COOKIE_SECURE"] = True
        app.config["SESSION_COOKIE_SAMESITE"] = "Lax"

    db.init_app(app)

    @app.context_processor
    def inject_globals():
        from app.dept_service import list_department_names

        department_names = list_department_names()
        return {
            "offices": department_names,
            "departments": department_names,
            "origins": ORIGINS,
            "outbound_default_origin": OUTBOUND_DEFAULT_ORIGIN,
            "resp_units": department_names,
            "document_types": DOCUMENT_TYPES,
            "document_types_inbound": INBOUND_DOCUMENT_TYPES,
            "document_types_outbound": OUTBOUND_DOCUMENT_TYPES,
            "actions_needed": ACTIONS_NEEDED,
            "actions_needed_inbound": INBOUND_ACTIONS_NEEDED,
            "actions_needed_outbound": OUTBOUND_ACTIONS_NEEDED,
            "display_action_needed": display_action_needed,
            "statuses": STATUSES,
            "classifications": CLASSIFICATIONS,
            "display_doc_type": display_doc_type,
            "display_recipient": display_recipient,
            "recipient_label_for": recipient_label_for,
            "forwarded_to_options": department_names,
            "submitted_to_options": SUBMITTED_TO_OPTIONS,
            "tesda_blue": TESDA_BLUE,
            "tesda_blue_dark": TESDA_BLUE_DARK,
            "tesda_blue_light": TESDA_BLUE_LIGHT,
            "user_roles": USER_ROLES,
            "can_edit_documents": can_edit_documents,
            "is_admin_role": is_admin_role,
            "is_portal_admin_role": is_portal_admin_role,
            "rmt_record_types": RMT_RECORD_TYPES,
            "display_rmt_record_type": display_rmt_record_type,
        }

    @app.route("/favicon.ico")
    def favicon():
        return send_from_directory(
            os.path.join(app.root_path, "static", "images"),
            "tesda_logo.png",
            mimetype="image/png",
        )

    from app.routes import main_routes
    from app.pmis_routes import pmis_routes
    from app.rmt_routes import rmt_routes
    from app.portal_admin_routes import portal_admin_routes

    app.register_blueprint(main_routes)
    app.register_blueprint(pmis_routes)
    app.register_blueprint(rmt_routes)
    app.register_blueprint(portal_admin_routes)

    uploads_dir = writable_upload_root(app.root_path) / "rmt"
    uploads_dir.mkdir(parents=True, exist_ok=True)

    if should_bootstrap_database():
        with app.app_context():
            db.create_all()
            _ensure_schema_columns()
            _sync_departments()
            _sync_roles()

    log = logging.getLogger("werkzeug")
    log.setLevel(logging.WARNING)

    return app


def _ensure_schema_columns():
    from sqlalchemy import text

    statements = [
        "ALTER TABLE dts_docs ADD COLUMN IF NOT EXISTS classification VARCHAR(20)",
        "ALTER TABLE dts_history ADD COLUMN IF NOT EXISTS classification VARCHAR(20)",
        "ALTER TABLE dts_docs ADD COLUMN IF NOT EXISTS doc_type_part VARCHAR(80)",
        "ALTER TABLE dts_history ADD COLUMN IF NOT EXISTS doc_type_part VARCHAR(80)",
        "ALTER TABLE dts_docs ADD COLUMN IF NOT EXISTS forwarded_to_part VARCHAR(80)",
        "ALTER TABLE dts_history ADD COLUMN IF NOT EXISTS forwarded_to_part VARCHAR(80)",
        "ALTER TABLE dts_docs ADD COLUMN IF NOT EXISTS action_particulars VARCHAR(220)",
        "ALTER TABLE dts_history ADD COLUMN IF NOT EXISTS action_particulars VARCHAR(220)",
    ]
    for stmt in statements:
        db.session.execute(text(stmt))
    db.session.commit()


def _sync_roles():
    from app.models import Role

    role_descriptions = {
        "Admin": "Full system access including user and department management.",
        "Staff": "Can add and update documents.",
        "Employee": "View-only access to documents.",
    }

    for role_name in USER_ROLES:
        role = Role.query.filter_by(role_name=role_name).first()
        if not role:
            db.session.add(
                Role(role_name=role_name, description=role_descriptions.get(role_name))
            )
        elif not role.description:
            role.description = role_descriptions.get(role_name)

    db.session.commit()


def _sync_departments():
    from app.models import DeptRef, User

    legacy_names = {
        "PTC Admin": "Administrative",
        "Assessment": "Administrative",
        "Finance": "Administrative",
        "Records": "Administrative",
        "MIS": "Administrative",
        "Registrar": "Administrative",
    }

    for old_name, new_name in legacy_names.items():
        dept = DeptRef.query.filter_by(dept_name=old_name).first()
        if dept and old_name != new_name:
            existing = DeptRef.query.filter_by(dept_name=new_name).first()
            if existing:
                db.session.delete(dept)
            else:
                dept.dept_name = new_name
                dept.dept_code = DEFAULT_DEPT_CODES.get(new_name, dept.dept_code)

        for user in User.query.filter_by(office=old_name).all():
            user.office = new_name

    for dept in DeptRef.query.all():
        if dept.dept_code in LEGACY_DEPT_CODES and dept.dept_name in DEFAULT_DEPT_CODES:
            dept.dept_code = DEFAULT_DEPT_CODES[dept.dept_name]

    for name in DEFAULT_DEPARTMENTS:
        dept = DeptRef.query.filter_by(dept_name=name).first()
        if not dept:
            db.session.add(DeptRef(dept_name=name, dept_code=DEFAULT_DEPT_CODES[name]))

    db.session.commit()
