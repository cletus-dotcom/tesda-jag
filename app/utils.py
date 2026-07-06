from datetime import date, datetime, timedelta
import os
import subprocess
from email.utils import parsedate_to_datetime

import pytz

from app import db
from app.models import DtsDoc, RmtRecord


def local_time():
    philippine_tz = pytz.timezone("Asia/Manila")
    return datetime.now(philippine_tz).replace(tzinfo=None)


def parse_document_date(value):
    """Normalize a form/import date value to a naive datetime."""
    if value is None:
        raise ValueError("Date is required.")
    if isinstance(value, datetime):
        return value.replace(tzinfo=None)
    if isinstance(value, date):
        return datetime.combine(value, datetime.min.time())
    if isinstance(value, (int, float)) and not isinstance(value, bool):
        excel_epoch = datetime(1899, 12, 30)
        return excel_epoch + timedelta(days=float(value))
    if isinstance(value, str):
        value = value.strip()
        if not value:
            raise ValueError("Date is required.")

        candidates = [value]
        if len(value) >= 10:
            candidates.append(value[:10])
        if len(value) >= 19:
            candidates.append(value[:19])

        for candidate in candidates:
            for fmt in ("%Y-%m-%d", "%Y-%m-%dT%H:%M:%S", "%Y-%m-%d %H:%M:%S", "%d/%m/%Y", "%m/%d/%Y"):
                try:
                    return datetime.strptime(candidate, fmt)
                except ValueError:
                    continue

        try:
            return parsedate_to_datetime(value).replace(tzinfo=None)
        except (TypeError, ValueError, OverflowError):
            pass

        raise ValueError("Invalid date format.")
    raise ValueError("Invalid date value.")


def generate_route_number(for_date=None):
    """Generate document number as YYMMDD + 2-digit daily sequence, e.g. 26062101."""
    when = parse_document_date(for_date) if for_date is not None else local_time()
    date_prefix = when.strftime("%y%m%d")

    docs = DtsDoc.query.filter(DtsDoc.route_number.like(f"{date_prefix}%")).all()

    def extract_seq(route_number):
        if not route_number or len(route_number) < 8:
            return 0
        if route_number[:6] != date_prefix:
            return 0
        try:
            return int(route_number[6:8])
        except ValueError:
            return 0

    latest_seq = max([extract_seq(d.route_number) for d in docs], default=0)
    next_seq = latest_seq + 1

    if next_seq > 99:
        raise ValueError("Daily document limit (99) reached for this date.")

    route_number = f"{date_prefix}{next_seq:02d}"
    return route_number, f"{next_seq:02d}", date_prefix


def generate_record_number(for_date=None):
    """Generate RMT record number as RMT-YYMMDD-NN, e.g. RMT-260621-01."""
    when = parse_document_date(for_date) if for_date is not None else local_time()
    date_prefix = when.strftime("%y%m%d")
    prefix = f"RMT-{date_prefix}-"

    records = RmtRecord.query.filter(RmtRecord.record_number.like(f"{prefix}%")).all()

    def extract_seq(record_number):
        if not record_number or not record_number.startswith(prefix):
            return 0
        try:
            return int(record_number[len(prefix):])
        except ValueError:
            return 0

    latest_seq = max([extract_seq(record.record_number) for record in records], default=0)
    next_seq = latest_seq + 1

    if next_seq > 99:
        raise ValueError("Daily record limit (99) reached for this date.")

    return f"{prefix}{next_seq:02d}"


def backup_tesda_db(
    host="localhost",
    port="5432",
    user="postgres",
    db_name="tesda_jag",
    output_dir="C:/python",
    retain=7,
):
    os.makedirs(output_dir, exist_ok=True)
    timestamp = datetime.now().strftime("%m%d%y")
    filename = f"tesda_jag_{timestamp}.backup"
    filepath = os.path.join(output_dir, filename)

    pg_dump_path = r"C:\Program Files\PostgreSQL\15\bin\pg_dump.exe"
    if not os.path.exists(pg_dump_path):
        pg_dump_path = "pg_dump"

    cmd = [
        pg_dump_path,
        "-h", host,
        "-p", port,
        "-U", user,
        "-F", "c",
        "-f", filepath,
        db_name,
    ]

    subprocess.run(cmd, check=True, shell=True)

    backups = [
        f for f in os.listdir(output_dir)
        if f.startswith("tesda_jag_") and f.endswith(".backup")
    ]
    backups.sort(key=lambda f: os.path.getmtime(os.path.join(output_dir, f)), reverse=True)
    for old in backups[retain:]:
        os.remove(os.path.join(output_dir, old))

    return filepath
