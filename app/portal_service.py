from sqlalchemy import func, or_, tuple_

from app import db
from app.config import display_recipient
from app.models import DtsDoc, DtsHistory, RmtRecord


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


def _count_inbound_active():
    return (
        db.session.query(func.count(DtsDoc.id))
        .filter(
            DtsDoc.classification == "Inbound",
            or_(
                DtsDoc.status.is_(None),
                func.lower(DtsDoc.status) != "completed",
            ),
        )
        .scalar()
        or 0
    )


def _count_pending_approvals():
    return (
        db.session.query(func.count(DtsDoc.id))
        .filter(func.lower(DtsDoc.status) == "pending")
        .scalar()
        or 0
    )


def _count_rmt_records():
    return db.session.query(func.count(RmtRecord.id)).scalar() or 0


def _count_distinct_record_types():
    return (
        db.session.query(
            func.count(
                func.distinct(
                    tuple_(RmtRecord.record_type, RmtRecord.record_type_part)
                )
            )
        )
        .filter(
            RmtRecord.record_type.isnot(None),
            RmtRecord.record_type != "",
        )
        .scalar()
        or 0
    )


def _count_distinct_cabinets():
    return (
        db.session.query(func.count(func.distinct(RmtRecord.cabinet_number)))
        .filter(
            RmtRecord.cabinet_number.isnot(None),
            RmtRecord.cabinet_number != "",
        )
        .scalar()
        or 0
    )


def portal_pulse_data():
    new_inbound = _count_inbound_active()
    pending_approvals = _count_pending_approvals()
    total_records = _count_rmt_records()
    record_type_count = _count_distinct_record_types()
    cabinet_count = _count_distinct_cabinets()

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
            "active_profiles": total_records,
            "class_batches": record_type_count or cabinet_count,
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
