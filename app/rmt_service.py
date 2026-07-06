from sqlalchemy import and_, func, or_

from app import db
from app.config import display_rmt_record_type
from app.models import RmtRecord


def serialize_rmt_record(record, include_details=False):
    payload = {
        "id": record.id,
        "record_number": record.record_number,
        "title": record.title or "",
        "record_type": display_rmt_record_type(record.record_type, record.record_type_part),
        "record_date": record.record_date.strftime("%Y-%m-%d") if record.record_date else "",
        "cabinet_number": record.cabinet_number or "",
        "shelf_number": record.shelf_number or "",
        "pdf_link": record.pdf_link or "",
        "has_local_file": bool(record.local_file_path),
        "encoded_by": record.encoded_by or "",
        "date_encoded": record.date_encoded.strftime("%Y-%m-%d %H:%M") if record.date_encoded else "",
    }
    if include_details:
        payload.update({
            "keywords": record.keywords or "",
            "remarks": record.remarks or "",
            "drive_file_id": record.drive_file_id or "",
            "local_file_path": record.local_file_path or "",
            "date_updated": record.date_updated.strftime("%Y-%m-%d %H:%M") if record.date_updated else "",
        })
    return payload


def records_query():
    return RmtRecord.query.order_by(
        RmtRecord.record_date.desc(),
        RmtRecord.record_number.desc(),
    )


def search_records_query(term):
    query = records_query()
    if not term:
        return query

    like = f"%{term.strip()}%"
    return query.filter(
        or_(
            RmtRecord.record_number.ilike(like),
            RmtRecord.title.ilike(like),
            RmtRecord.record_type.ilike(like),
            RmtRecord.record_type_part.ilike(like),
            RmtRecord.cabinet_number.ilike(like),
            RmtRecord.shelf_number.ilike(like),
            RmtRecord.keywords.ilike(like),
            RmtRecord.remarks.ilike(like),
            RmtRecord.encoded_by.ilike(like),
        )
    )


def rmt_dashboard_stats():
    total_records = db.session.query(func.count(RmtRecord.id)).scalar() or 0
    total_cabinets = (
        db.session.query(func.count(func.distinct(RmtRecord.cabinet_number)))
        .filter(
            RmtRecord.cabinet_number.isnot(None),
            RmtRecord.cabinet_number != "",
        )
        .scalar()
        or 0
    )
    with_pdf = (
        db.session.query(func.count(RmtRecord.id))
        .filter(
            or_(
                and_(RmtRecord.pdf_link.isnot(None), RmtRecord.pdf_link != ""),
                and_(
                    RmtRecord.local_file_path.isnot(None),
                    RmtRecord.local_file_path != "",
                ),
            )
        )
        .scalar()
        or 0
    )
    return {
        "total_records": total_records,
        "total_cabinets": total_cabinets,
        "with_pdf": with_pdf,
    }
