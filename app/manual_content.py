from app.config import is_portal_admin_role, normalize_role

DEFAULT_MANUAL_ROLE = "Employee"


def resolve_manual_role(session_role):
    """Map session role to Admin, Staff, or Employee manual content."""
    if is_portal_admin_role(session_role):
        return "Admin"
    role = normalize_role(session_role)
    if role not in ("Admin", "Staff", "Employee"):
        return DEFAULT_MANUAL_ROLE
    return role


DTS_MANUALS = {
    "Admin": {
        "title": "DTS Admin User Manual",
        "summary": (
            "Administrators manage users, departments, and center-wide document records. "
            "Use this guide for the Document Tracking System (DTS) at TESDA PTC-Jagna."
        ),
        "sections": [
            {
                "heading": "Dashboard Overview",
                "items": [
                    "Open Dashboard from the sidebar to see today's transactions for your office, plus inbound and outbound document lists.",
                    "Use the search box inside each section to filter by route number, subject, origin, or status.",
                    "On mobile, scroll document lists inside each card to reach the next section quickly.",
                    "Stat tiles show inbound, outbound, pending, and completed counts for the whole center.",
                ],
            },
            {
                "heading": "Adding and Updating Documents",
                "items": [
                    "Select New Document from the welcome card or top bar to register inbound or outbound mail.",
                    "Route numbers are auto-generated as YYMMDD plus a two-digit daily sequence (example: 26010701).",
                    "Choose classification (Inbound or Outbound), document type, action needed, and action particulars before saving.",
                    "Use Update on any row to change status, forwarding, responsible unit, or remarks — each save is logged in document history.",
                ],
            },
            {
                "heading": "User and Department Management",
                "items": [
                    "Open Admin Options → Manage Users to add, edit, or remove accounts.",
                    "Assign roles carefully: Employee (view only), Staff (encode and update), Admin (full management).",
                    "Open Manage Departments to add office codes used in forwarding and responsible unit fields.",
                    "Do not delete a department that is still assigned to users or active documents.",
                ],
            },
            {
                "heading": "Reports and Maintenance",
                "items": [
                    "Open List Documents for a full searchable table of all DTS records.",
                    "Use Export PDF from the document list to download a printable summary for meetings or audits.",
                    "Database backup is available on local hosting only; on cloud hosting use Supabase Dashboard backups.",
                ],
            },
        ],
    },
    "Staff": {
        "title": "DTS Staff User Manual",
        "summary": (
            "Staff encode and route documents for TESDA PTC-Jagna. "
            "You can add, update, and track files but cannot manage users or departments."
        ),
        "sections": [
            {
                "heading": "Daily Workflow",
                "items": [
                    "Check Today's Transactions for documents forwarded to your office that still need action.",
                    "Review Inbound Documents for newly received files and Outbound Documents for items leaving the center.",
                    "Use New Document when mail arrives or when preparing an outbound submission.",
                ],
            },
            {
                "heading": "Encoding a Document",
                "items": [
                    "Set Date Received, origin, subject, and classification before saving.",
                    "For Inbound mail, specify action needed, responsible unit, and forwarding when routing to an office.",
                    "For Outbound mail, set Submitted To and status as the document moves through approval.",
                    "Add a document link (URL) when a scanned copy is stored in Drive or shared storage.",
                ],
            },
            {
                "heading": "Updating and History",
                "items": [
                    "Open Update on any document to change status, action provided, or forwarding destination.",
                    "View History to see who changed a record and when — useful for audit trails.",
                    "Use List Documents when you need to search across all records, not just dashboard sections.",
                ],
            },
            {
                "heading": "Account",
                "items": [
                    "Use Change Password in the sidebar to update your login credentials.",
                    "Contact an Admin if your office assignment or role needs to be changed.",
                ],
            },
        ],
    },
    "Employee": {
        "title": "DTS Employee User Manual",
        "summary": (
            "Employee accounts have view-only access to DTS. "
            "You can monitor document status but cannot add, edit, or delete records."
        ),
        "sections": [
            {
                "heading": "Viewing the Dashboard",
                "items": [
                    "Sign in and open Dashboard to see today's transactions and center-wide inbound/outbound lists.",
                    "Tap View details on a mobile card or the expand arrow on desktop to read full document information.",
                    "Use section search boxes to find a route number or subject quickly.",
                ],
            },
            {
                "heading": "What You Can Do",
                "items": [
                    "Browse List Documents for a complete read-only table.",
                    "Open View History on any document to see routing and status changes over time.",
                    "Use the portal Home page search (before login) to locate a route number, then sign in for full details.",
                ],
            },
            {
                "heading": "What You Cannot Do",
                "items": [
                    "Employees cannot add documents, update statuses, or delete records.",
                    "If a correction is needed, notify Staff or Admin in your office with the route number.",
                ],
            },
            {
                "heading": "Account",
                "items": [
                    "Use Change Password in the sidebar to keep your account secure.",
                    "Log out when using a shared device.",
                ],
            },
        ],
    },
}

RMT_MANUALS = {
    "Admin": {
        "title": "RMT Admin User Manual",
        "summary": (
            "Administrators oversee the Records Management Tool (RMT) — "
            "PTC-Jagna's digital vault for institutional PDF records and physical locations."
        ),
        "sections": [
            {
                "heading": "Dashboard and Search",
                "items": [
                    "Open RMT Dashboard to see total records, cabinets in use, and PDF attachment counts.",
                    "Use Quick Search to find records by number, title, keywords, cabinet, shelf, or encoder.",
                    "Review the records table or mobile cards for archive status at a glance.",
                ],
            },
            {
                "heading": "Adding and Editing Records",
                "items": [
                    "Select Add Record to register a new archive entry with title, record type, date, cabinet, and shelf.",
                    "Record numbers follow the same daily sequence pattern as DTS route numbers when auto-generated.",
                    "Attach a PDF by upload (Google Drive on cloud hosting) or paste a manual Drive link.",
                    "Use Edit to update metadata, replace PDFs, or refine keywords for future searches.",
                ],
            },
            {
                "heading": "Physical Archive Standards",
                "items": [
                    "Always enter cabinet number and shelf number matching the physical filing location.",
                    "Use keywords for graduate batches, program names, or document categories to speed up retrieval.",
                    "Keep record type consistent (e.g., Student Profile, Memorandum, Class Batch) for reporting.",
                ],
            },
            {
                "heading": "Administration",
                "items": [
                    "Admins share the same user and department tools as DTS — open Document Tracker → Admin Options when needed.",
                    "Deleting a record removes the database entry; verify Drive files separately if uploads were used.",
                ],
            },
        ],
    },
    "Staff": {
        "title": "RMT Staff User Manual",
        "summary": (
            "Staff maintain scanned records and location data in the Records Management Tool. "
            "You can add, edit, search, and attach PDFs to archive entries."
        ),
        "sections": [
            {
                "heading": "Adding a Record",
                "items": [
                    "Click Add Record and fill in title, record type, record date, cabinet, and shelf.",
                    "Upload a PDF or provide a Google Drive link if the file is already stored online.",
                    "Add keywords (program, batch year, student name fragments) to make later searches easier.",
                    "Save and confirm the auto-generated record number on the confirmation screen.",
                ],
            },
            {
                "heading": "Finding and Updating Records",
                "items": [
                    "Use dashboard search to locate records before creating duplicates.",
                    "Open Edit to fix titles, locations, keywords, or replace an outdated PDF.",
                    "Use View PDF to open the linked file in a new tab when a Drive or local link exists.",
                ],
            },
            {
                "heading": "PDF Upload Notes",
                "items": [
                    "On cloud hosting, PDF uploads require Google Drive to be configured by your administrator.",
                    "If upload is unavailable, save the file to Drive manually and paste the sharing link in the form.",
                    "Prefer PDF format for long-term readability.",
                ],
            },
            {
                "heading": "Account",
                "items": [
                    "Use Change Password from the sidebar when needed.",
                    "Contact Admin if you need delete access or role changes.",
                ],
            },
        ],
    },
    "Employee": {
        "title": "RMT Employee User Manual",
        "summary": (
            "Employee accounts can browse and search the archive but cannot add, edit, or delete RMT records."
        ),
        "sections": [
            {
                "heading": "Browsing the Archive",
                "items": [
                    "Open RMT Dashboard to see record statistics and the searchable list.",
                    "Use Quick Search to find records by number, title, or keywords.",
                    "Expand mobile cards or desktop rows to read cabinet, shelf, encoder, and remarks.",
                ],
            },
            {
                "heading": "Viewing PDFs",
                "items": [
                    "Select View PDF when a record has an attached link.",
                    "If no PDF appears, the record may be physical-only — note the cabinet and shelf for retrieval.",
                ],
            },
            {
                "heading": "Limitations",
                "items": [
                    "Employees cannot add records, upload files, edit entries, or delete archives.",
                    "Request Staff or Admin to encode new scans or correct location data.",
                ],
            },
            {
                "heading": "Account",
                "items": [
                    "Use Change Password to update your password.",
                    "Log out on shared computers after use.",
                ],
            },
        ],
    },
}


def get_dts_manual(role):
    return DTS_MANUALS.get(role, DTS_MANUALS[DEFAULT_MANUAL_ROLE])


def get_rmt_manual(role):
    return RMT_MANUALS.get(role, RMT_MANUALS[DEFAULT_MANUAL_ROLE])
