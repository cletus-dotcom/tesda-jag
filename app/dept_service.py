from app import db
from app.config import DEFAULT_DEPARTMENTS, DEFAULT_DEPT_CODES
from app.models import DeptRef


def list_department_names():
    names = [
        dept.dept_name
        for dept in DeptRef.query.order_by(DeptRef.dept_name.asc()).all()
    ]
    return names or list(DEFAULT_DEPARTMENTS)


def list_departments():
    departments = DeptRef.query.order_by(DeptRef.dept_name.asc()).all()
    if departments:
        return departments
    return [
        DeptRef(dept_name=name, dept_code=DEFAULT_DEPT_CODES[name])
        for name in DEFAULT_DEPARTMENTS
    ]


def dept_code_map():
    return {dept.dept_name: dept.dept_code for dept in DeptRef.query.all()}


def validate_dept_fields(dept_name, dept_code, exclude_id=None):
    dept_name = (dept_name or "").strip()
    dept_code = (dept_code or "").strip().upper()

    if not dept_name or not dept_code:
        return None, None, "Department name and code are required."

    query_name = DeptRef.query.filter_by(dept_name=dept_name)
    query_code = DeptRef.query.filter_by(dept_code=dept_code)
    if exclude_id:
        query_name = query_name.filter(DeptRef.id != exclude_id)
        query_code = query_code.filter(DeptRef.id != exclude_id)

    if query_name.first():
        return None, None, "Department name already exists."
    if query_code.first():
        return None, None, "Department code already exists."

    return dept_name, dept_code, None


def apply_department_rename(old_name, new_name):
    if not old_name or old_name == new_name:
        return

    from app.models import DtsDoc, User

    User.query.filter_by(office=old_name).update({"office": new_name})
    DtsDoc.query.filter_by(resp_unit=old_name).update({"resp_unit": new_name})
    DtsDoc.query.filter_by(forwarded_to=old_name).update({"forwarded_to": new_name})
    db.session.flush()


def department_in_use(dept_name):
    from app.models import DtsDoc, User

    if User.query.filter_by(office=dept_name).first():
        return True
    if DtsDoc.query.filter(
        (DtsDoc.resp_unit == dept_name) | (DtsDoc.forwarded_to == dept_name)
    ).first():
        return True
    return False
