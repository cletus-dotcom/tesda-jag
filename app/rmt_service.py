from sqlalchemy import or_

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
    records = RmtRecord.query.all()
    cabinets = {record.cabinet_number for record in records if record.cabinet_number}
    return {
        "total_records": len(records),
        "total_cabinets": len(cabinets),
        "with_pdf": sum(1 for record in records if record.pdf_link or record.local_file_path),
    }
