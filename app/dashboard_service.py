from sqlalchemy import and_

from app.config import display_action_needed, display_doc_type, display_recipient
from app.models import DtsDoc


def serialize_dashboard_doc(doc, include_details=False):
    payload = {
        "route_number": doc.route_number,
        "classification": doc.classification or "",
        "doc_type": display_doc_type(doc.doc_type, doc.doc_type_part),
        "subject": doc.subject or "",
        "status": doc.status or "Unknown",
        "origin": doc.origin or "",
        "recipient": display_recipient(
            doc.forwarded_to,
            doc.forwarded_to_part,
            doc.classification,
        ),
        "date_received": doc.date_received.strftime("%Y-%m-%d") if doc.date_received else "",
        "resp_unit": doc.resp_unit or "",
    }
    if include_details:
        payload.update({
            "action_needed": display_action_needed(doc.action_needed, doc.action_part),
            "action_particulars": doc.action_particulars or "",
            "action_provided": doc.action_provided or "",
            "responsible_person": doc.responsible_person or "",
            "remarks": doc.remarks or "",
            "other_office": doc.other_office or "",
            "recipient_label": (
                "Submitted To" if doc.classification == "Outbound" else "Forwarded To"
            ),
        })
    return payload


def classification_docs_query(classification):
    return (
        DtsDoc.query.filter(DtsDoc.classification == classification)
        .order_by(DtsDoc.date_received.desc(), DtsDoc.route_number.desc())
    )


def inbound_docs_query():
    return classification_docs_query("Inbound")


def outbound_docs_query():
    return classification_docs_query("Outbound")


def office_today_transactions_query(office):
    return (
        DtsDoc.query.filter(
            and_(
                DtsDoc.forwarded_to == office,
                DtsDoc.status != "Completed",
            )
        )
        .order_by(DtsDoc.date_updated.desc(), DtsDoc.route_number.desc())
    )


def office_dashboard_stats(office):
    inbound_docs = inbound_docs_query().all()
    outbound_docs = outbound_docs_query().all()
    today_docs = office_today_transactions_query(office).all()
    all_classified = inbound_docs + outbound_docs

    return {
        "inbound_total": len(inbound_docs),
        "outbound_total": len(outbound_docs),
        "today_transactions": len(today_docs),
        "pending_total": sum(1 for doc in all_classified if doc.status != "Completed"),
        "completed_total": sum(1 for doc in all_classified if doc.status == "Completed"),
        "office": office,
    }
