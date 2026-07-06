from sqlalchemy import or_

from app.config import display_recipient
from app.dashboard_service import inbound_docs_query, outbound_docs_query
from app.models import DtsDoc, DtsHistory, RmtRecord
from app.rmt_service import rmt_dashboard_stats


def _format_history_action(entry):
    subject = (entry.subject or entry.route_number or "document").strip()
    if len(subject) > 48:
        subject = subject[:45] + "…"

    user = (entry.user_name or "Staff").strip()
    status = (entry.status or "updated").strip().lower()

    if entry.forwarded_to:
        target = display_recipient(
            entry.forwarded_to,
            entry.forwarded_to_part,
            entry.classification,
        )
        text = f"{user} routed '{subject}' to {target}"
    elif status == "completed":
        text = f"{user} completed '{subject}'"
    else:
        text = f"{user} updated '{subject}' ({entry.status or 'In Progress'})"

    timestamp = entry.timestamp or entry.date_updated
    return {
        "text": text,
        "time": timestamp.strftime("%Y-%m-%d %H:%M") if timestamp else "",
        "module": "dts",
    }


def _format_rmt_action(record):
    title = (record.title or record.record_number or "record").strip()
    if len(title) > 48:
        title = title[:45] + "…"
    user = (record.encoded_by or "Staff").strip()
    timestamp = record.date_encoded
    return {
        "text": f"{user} archived '{title}' in RMT",
        "time": timestamp.strftime("%Y-%m-%d %H:%M") if timestamp else "",
        "module": "rmt",
    }


def portal_pulse_data():
    inbound_docs = inbound_docs_query().all()
    outbound_docs = outbound_docs_query().all()
    all_docs = inbound_docs + outbound_docs

    new_inbound = sum(
        1 for doc in inbound_docs
        if (doc.status or "").lower() not in ("completed",)
    )
    pending_approvals = sum(
        1 for doc in all_docs
        if (doc.status or "").lower() == "pending"
    )

    rmt_stats = rmt_dashboard_stats()
    record_types = {
        (record.record_type or "General", record.record_type_part or "")
        for record in RmtRecord.query.all()
        if record.record_type
    }

    history_actions = [
        _format_history_action(entry)
        for entry in DtsHistory.query.order_by(DtsHistory.timestamp.desc()).limit(8).all()
    ]
    rmt_actions = [
        _format_rmt_action(record)
        for record in RmtRecord.query.order_by(RmtRecord.date_encoded.desc()).limit(4).all()
    ]

    combined = history_actions + rmt_actions
    combined.sort(key=lambda item: item["time"], reverse=True)
    recent_actions = combined[:10]

    if not recent_actions:
        recent_actions = [
            {
                "text": "Portal ready — activity will appear here as your team uses DTS, RMT, and PMIS.",
                "time": "",
                "module": "system",
            }
        ]

    return {
        "dts": {
            "new_inbound": new_inbound,
            "pending_approvals": pending_approvals,
        },
        "rmt": {
            "active_profiles": rmt_stats["total_records"],
            "class_batches": len(record_types) or rmt_stats["total_cabinets"],
        },
        "pmis": {
            "equipment_checked_out": 0,
            "maintenance_alerts": 0,
            "in_development": True,
        },
        "recent_actions": recent_actions,
    }


def portal_search(query):
    term = (query or "").strip()
    if not term:
        return []

    like = f"%{term}%"
    results = []

    docs = (
        DtsDoc.query.filter(
            or_(
                DtsDoc.route_number.ilike(like),
                DtsDoc.subject.ilike(like),
            )
        )
        .order_by(DtsDoc.date_updated.desc())
        .limit(5)
        .all()
    )
    for doc in docs:
        results.append({
            "module": "dts",
            "label": doc.route_number,
            "detail": doc.subject or "",
            "login_url": "/login?next=/dashboard",
        })

    records = (
        RmtRecord.query.filter(
            or_(
                RmtRecord.record_number.ilike(like),
                RmtRecord.title.ilike(like),
                RmtRecord.keywords.ilike(like),
            )
        )
        .order_by(RmtRecord.date_encoded.desc())
        .limit(5)
        .all()
    )
    for record in records:
        results.append({
            "module": "rmt",
            "label": record.record_number,
            "detail": record.title or "",
            "login_url": "/login?next=/rmt/dashboard",
        })

    return results
