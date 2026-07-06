from datetime import datetime

import pytz
from werkzeug.security import check_password_hash, generate_password_hash

from app import db


def local_time():
    philippine_tz = pytz.timezone("Asia/Manila")
    return datetime.now(philippine_tz).replace(tzinfo=None)


class Role(db.Model):
    __tablename__ = "roles"

    role_id = db.Column(db.Integer, primary_key=True)
    role_name = db.Column(db.String(50), unique=True, nullable=False)
    description = db.Column(db.Text)

    def __repr__(self):
        return f"<Role {self.role_name}>"


class User(db.Model):
    __tablename__ = "users"

    user_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(100), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    full_name = db.Column(db.String(150))
    office = db.Column(db.String(150))
    email = db.Column(db.String(120), unique=True)
    role = db.Column(db.String(20), default="Employee")
    status = db.Column(db.String(20), default="Active")

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def __repr__(self):
        return f"<User {self.username} ({self.role})>"


class DtsDoc(db.Model):
    __tablename__ = "dts_docs"

    id = db.Column(db.Integer, primary_key=True)
    doc_type = db.Column(db.String(40))
    doc_type_part = db.Column(db.String(80))
    date_received = db.Column(db.Date)
    origin = db.Column(db.String(40))
    other_office = db.Column(db.String(40))
    subject = db.Column(db.String(220))
    doc_link = db.Column(db.String(80))
    route_number = db.Column(db.String(20), unique=True, nullable=False)
    classification = db.Column(db.String(20))
    action_needed = db.Column(db.String(50))
    action_part = db.Column(db.String(80))
    action_particulars = db.Column(db.String(220))
    resp_unit = db.Column(db.String(40))
    responsible_person = db.Column(db.String(40))
    action_provided = db.Column(db.String(220))
    date_accomp = db.Column(db.Date)
    status = db.Column(db.String(20))
    forwarded_to = db.Column(db.String(40))
    forwarded_to_part = db.Column(db.String(80))
    date_encoded = db.Column(db.DateTime, default=local_time)
    remarks = db.Column(db.Text)
    date_updated = db.Column(db.DateTime, onupdate=local_time)

    def __repr__(self):
        return f"<DtsDoc {self.route_number} - {self.subject}>"


class DtsHistory(db.Model):
    __tablename__ = "dts_history"

    unique_id = db.Column(db.Integer, primary_key=True)
    route_number = db.Column(db.String(20), nullable=False)
    user_name = db.Column(db.String(100), nullable=False)
    action_provided = db.Column(db.String(220))
    status = db.Column(db.String(100))
    date_updated = db.Column(db.DateTime)
    forwarded_to = db.Column(db.String(40))
    forwarded_to_part = db.Column(db.String(80))
    resp_unit = db.Column(db.String(40))
    ip_address = db.Column(db.String(20))
    timestamp = db.Column(db.DateTime(timezone=True), default=local_time)
    date_received = db.Column(db.Date)
    origin = db.Column(db.String(40))
    other_office = db.Column(db.String(40))
    doc_type = db.Column(db.String(40))
    doc_type_part = db.Column(db.String(80))
    classification = db.Column(db.String(20))
    subject = db.Column(db.String(220))
    doc_link = db.Column(db.String(80))
    action_needed = db.Column(db.String(50))
    action_part = db.Column(db.String(80))
    action_particulars = db.Column(db.String(220))
    responsible_person = db.Column(db.String(40))

    def __repr__(self):
        return f"<DtsHistory {self.unique_id} - Route {self.route_number}>"


def log_history(doc, user_name, ip_address=None):
    history = DtsHistory(
        route_number=doc.route_number,
        user_name=user_name,
        action_provided=doc.action_provided,
        status=doc.status,
        date_updated=local_time(),
        forwarded_to=doc.forwarded_to,
        forwarded_to_part=doc.forwarded_to_part,
        resp_unit=doc.resp_unit,
        ip_address=ip_address,
        date_received=doc.date_received,
        origin=doc.origin,
        other_office=doc.other_office,
        doc_type=doc.doc_type,
        doc_type_part=doc.doc_type_part,
        classification=doc.classification,
        subject=doc.subject,
        doc_link=doc.doc_link,
        action_needed=doc.action_needed,
        action_part=doc.action_part,
        action_particulars=doc.action_particulars,
        responsible_person=doc.responsible_person,
    )
    db.session.add(history)
    db.session.commit()
    return history


class DeptRef(db.Model):
    __tablename__ = "dept_ref"

    id = db.Column(db.Integer, primary_key=True)
    dept_name = db.Column(db.String(150), unique=True, nullable=False)
    dept_code = db.Column(db.String(20), unique=True, nullable=False)

    def __repr__(self):
        return f"<DeptRef {self.dept_code} - {self.dept_name}>"


class RmtRecord(db.Model):
    __tablename__ = "rmt_records"

    id = db.Column(db.Integer, primary_key=True)
    record_number = db.Column(db.String(24), unique=True, nullable=False)
    title = db.Column(db.String(220), nullable=False)
    record_type = db.Column(db.String(60))
    record_type_part = db.Column(db.String(120))
    record_date = db.Column(db.Date)
    pdf_link = db.Column(db.String(500))
    local_file_path = db.Column(db.String(300))
    drive_file_id = db.Column(db.String(100))
    cabinet_number = db.Column(db.String(20), nullable=False)
    shelf_number = db.Column(db.String(20), nullable=False)
    keywords = db.Column(db.Text)
    remarks = db.Column(db.Text)
    encoded_by = db.Column(db.String(150))
    date_encoded = db.Column(db.DateTime, default=local_time)
    date_updated = db.Column(db.DateTime, onupdate=local_time)

    def __repr__(self):
        return f"<RmtRecord {self.record_number} - {self.title}>"
