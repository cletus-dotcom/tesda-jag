import os

DB_CONFIG = {
    "db_user": os.getenv("DB_USER", "postgres"),
    "db_pass": os.getenv("DB_PASS", "password"),
    "db_ip": os.getenv("DB_IP", "127.0.0.1"),
    "db_port": os.getenv("DB_PORT", "5432"),
    "db_name": os.getenv("DB_NAME", "tesda_jag"),
}

SECRET_KEY = os.getenv("SECRET_KEY", "tesda_ptc_jag_secret_key")

# TESDA brand colors (from official logo)
TESDA_BLUE = "#0033A0"
TESDA_BLUE_DARK = "#002080"
TESDA_BLUE_LIGHT = "#1a56c4"

# Default departments seeded into dept_ref on first run (editable via admin UI)
DEFAULT_DEPARTMENTS = [
    "Administrative",
    "Training",
    "Extension/Research",
]

DEFAULT_DEPT_CODES = {
    "Administrative": "ADM01",
    "Training": "TRN02",
    "Extension/Research": "EXT03",
}

DEPARTMENTS = DEFAULT_DEPARTMENTS
DEPT_CODES = DEFAULT_DEPT_CODES

# Old codes migrated on startup (e.g. ADM24 → ADM01)
LEGACY_DEPT_CODES = {
    "ADM24": "ADM01",
    "PTC24": "ADM01",
    "ASM24": "ADM01",
    "FIN24": "ADM01",
    "REC24": "ADM01",
    "MIS24": "ADM01",
    "REG24": "ADM01",
    "TRN24": "TRN02",
    "EXT24": "EXT03",
}

OFFICES = DEPARTMENTS
RESP_UNITS = DEPARTMENTS

OUTGOING_DEFAULT_ORIGIN = "PTC-Jagna"
# Backward-compatible alias (internal use only).
OUTBOUND_DEFAULT_ORIGIN = OUTGOING_DEFAULT_ORIGIN

ORIGINS = [
    "Central Office",
    "Regional Office",
    "Provincial Office",
    "Lila LGU",
    "Dimiao LGU",
    "Valencia LGU",
    "Garcia-Hernandez LGU",
    "Jagna LGU",
    "Duero LGU",
    "Guindulman LGU",
    "Candijay LGU",
    "Anda LGU",
    "Mabini LGU",
    OUTGOING_DEFAULT_ORIGIN,
    "Others",
]

INCOMING_DOCUMENT_TYPES = [
    "Memorandum",
    "Memorandum Circular",
    "Office Order",
    "TESDA Order",
    "TESDA Circular",
    "Bulletin",
    "Advisory",
    "Cluster Order",
    "Communication",
    "Others",
]

OUTGOING_DOCUMENT_TYPES = [
    "Reports",
    "Voucher",
    "Others",
]

INBOUND_DOCUMENT_TYPES = INCOMING_DOCUMENT_TYPES
OUTBOUND_DOCUMENT_TYPES = OUTGOING_DOCUMENT_TYPES

DOCUMENT_TYPES = INCOMING_DOCUMENT_TYPES

CLASSIFICATION_INCOMING = "Incoming"
CLASSIFICATION_OUTGOING = "Outgoing"
CLASSIFICATIONS = [CLASSIFICATION_INCOMING, CLASSIFICATION_OUTGOING]


def normalize_classification(classification):
    value = (classification or "").strip()
    legacy = {"Inbound": CLASSIFICATION_INCOMING, "Outbound": CLASSIFICATION_OUTGOING}
    return legacy.get(value, value)


def is_outgoing_classification(classification):
    return normalize_classification(classification) == CLASSIFICATION_OUTGOING


def classification_db_values(classification):
    normalized = normalize_classification(classification)
    if normalized == CLASSIFICATION_INCOMING:
        return (CLASSIFICATION_INCOMING, "Inbound")
    if normalized == CLASSIFICATION_OUTGOING:
        return (CLASSIFICATION_OUTGOING, "Outbound")
    return (normalized,)


def document_types_for(classification):
    if is_outgoing_classification(classification):
        return OUTGOING_DOCUMENT_TYPES
    return INCOMING_DOCUMENT_TYPES


def is_valid_doc_type(classification, doc_type):
    if not doc_type:
        return False
    return doc_type in document_types_for(classification)


def parse_doc_type_fields(doc_type, doc_type_part):
    doc_type = (doc_type or "").strip()
    doc_type_part = (doc_type_part or "").strip()
    if doc_type == "Others":
        if not doc_type_part:
            return None, None, "Please specify the document type."
        return doc_type, doc_type_part, None
    return doc_type, None, None


def display_doc_type(doc_type, doc_type_part=None):
    if doc_type == "Others" and doc_type_part:
        return doc_type_part
    return doc_type or ""

ACTIONS_NEEDED = [
    "For Information",
    "For Guidance",
    "For Reference",
    "For Appropriate Action",
    "For Dissemination",
    "Kindly Provide Feedback",
    "Let Us Discuss On This Concern",
    "For File",
    "For Nomination",
    "See Me",
    "Others",
]

INCOMING_ACTIONS_NEEDED = ACTIONS_NEEDED

OUTGOING_ACTIONS_NEEDED = ACTIONS_NEEDED + [
    "For Submission",
]

INBOUND_ACTIONS_NEEDED = INCOMING_ACTIONS_NEEDED
OUTBOUND_ACTIONS_NEEDED = OUTGOING_ACTIONS_NEEDED


def actions_needed_for(classification):
    if is_outgoing_classification(classification):
        return OUTGOING_ACTIONS_NEEDED
    return INCOMING_ACTIONS_NEEDED


def is_valid_action_needed(classification, action_needed):
    if not action_needed:
        return False
    return action_needed in actions_needed_for(classification)


def parse_action_fields(action_needed, action_part):
    action_needed = (action_needed or "").strip()
    action_part = (action_part or "").strip()
    if action_needed == "Others":
        if not action_part:
            return None, None, "Please specify the action needed."
        return action_needed, action_part, None
    return action_needed, None, None


def display_action_needed(action_needed, action_part=None):
    if action_needed == "Others" and action_part:
        return action_part
    return action_needed or ""


def resolve_origin_fields(classification, origin, other_office):
    if is_outgoing_classification(classification):
        return OUTGOING_DEFAULT_ORIGIN, None, None

    origin = (origin or "").strip()
    other_office = (other_office or "").strip() if origin == "Others" else None
    if not origin:
        return None, None, "Please select an origin."
    if origin not in ORIGINS:
        return None, None, "Invalid origin."
    if origin == "Others" and not other_office:
        return None, None, "Please specify the other office."
    return origin, other_office, None


SUBMITTED_TO_OPTIONS = [
    "Central Office",
    "Regional",
    "Provincial",
    "Others",
]


def recipient_options_for(classification):
    if is_outgoing_classification(classification):
        return SUBMITTED_TO_OPTIONS
    from app.dept_service import list_department_names

    return list_department_names()


def recipient_label_for(classification):
    if is_outgoing_classification(classification):
        return "Submitted To"
    return "Forwarded To"


def is_valid_recipient(classification, forwarded_to):
    if not forwarded_to:
        return True
    return forwarded_to in recipient_options_for(classification)


def parse_recipient_fields(classification, forwarded_to, forwarded_to_part):
    forwarded_to = (forwarded_to or "").strip()
    forwarded_to_part = (forwarded_to_part or "").strip()
    if not forwarded_to:
        return None, None, None
    if not is_valid_recipient(classification, forwarded_to):
        label = recipient_label_for(classification).lower()
        return None, None, f"Invalid {label} option."
    if forwarded_to == "Others":
        if not forwarded_to_part:
            label = recipient_label_for(classification).lower()
            return None, None, f"Please specify {label}."
        return forwarded_to, forwarded_to_part, None
    return forwarded_to, None, None


def display_recipient(forwarded_to, forwarded_to_part=None, classification=None):
    if forwarded_to == "Others" and forwarded_to_part:
        return forwarded_to_part
    return forwarded_to or ""


STATUSES = ["Pending", "In Progress", "Completed", "Forwarded", "Received"]

USER_ROLES = ["Admin", "Staff", "Employee"]

PORTAL_ADMIN_USERNAME = "PortalAdmin"
PORTAL_ADMIN_PASSWORD = "portal123"
PORTAL_ADMIN_ROLE = "PortalAdmin"


def verify_portal_admin_credentials(username, password):
    return (
        (username or "").strip() == PORTAL_ADMIN_USERNAME
        and (password or "").strip() == PORTAL_ADMIN_PASSWORD
    )


def is_reserved_username(username):
    return (username or "").strip() == PORTAL_ADMIN_USERNAME


def is_portal_admin_role(role=None):
    return (role or "").strip() == PORTAL_ADMIN_ROLE


def normalize_role(role):
    value = (role or "Employee").strip().capitalize()
    if value == "User":
        return "Employee"
    return value


def is_valid_user_role(role):
    return normalize_role(role) in USER_ROLES


def can_edit_documents(role=None):
    if is_portal_admin_role(role):
        return True
    return normalize_role(role).lower() in ("admin", "staff")


def is_admin_role(role=None):
    if is_portal_admin_role(role):
        return True
    return normalize_role(role).lower() == "admin"


def is_elevated_admin(role=None):
    return is_admin_role(role) or is_portal_admin_role(role)


RMT_RECORD_TYPES = [
    "Memorandum",
    "Office Order",
    "Reports",
    "Certificates",
    "Contracts",
    "Personnel Records",
    "Financial Records",
    "Training Records",
    "PTCACS",
    "UTPRAS",
    "201 File",
    "Others",
]


def is_valid_rmt_record_type(record_type):
    return bool(record_type) and record_type in RMT_RECORD_TYPES


def parse_rmt_record_type_fields(record_type, record_type_part):
    record_type = (record_type or "").strip()
    record_type_part = (record_type_part or "").strip()
    if record_type == "Others":
        if not record_type_part:
            return None, None, "Please specify the record type."
        return record_type, record_type_part, None
    return record_type, None, None


def display_rmt_record_type(record_type, record_type_part=None):
    if record_type == "Others" and record_type_part:
        return record_type_part
    return record_type or ""


def safe_login_redirect(next_param, default_endpoint="main_routes.dashboard"):
    from flask import url_for

    if not next_param:
        return url_for(default_endpoint)

    value = next_param.strip()
    if not value.startswith("/") or value.startswith("//"):
        return url_for(default_endpoint)

    allowed_prefixes = (
        "/dashboard",
        "/rmt",
        "/pmis",
        "/portal-admin",
        "/list_docs",
        "/add_document",
    )
    if any(value.startswith(prefix) for prefix in allowed_prefixes):
        return value
    return url_for(default_endpoint)
