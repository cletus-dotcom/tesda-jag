import json
import os
from pathlib import Path

from flask import current_app

from app.database import is_serverless_runtime, writable_upload_root


def drive_configured():
    folder_id = os.getenv("GOOGLE_DRIVE_FOLDER_ID", "").strip()
    service_file = os.getenv("GOOGLE_SERVICE_ACCOUNT_FILE", "").strip()
    service_json = os.getenv("GOOGLE_SERVICE_ACCOUNT_JSON", "").strip()
    has_file = bool(service_file and Path(service_file).is_file())
    has_json = bool(service_json)
    return bool(folder_id and (has_file or has_json))


def _google_credentials():
    from google.oauth2 import service_account

    service_json = os.getenv("GOOGLE_SERVICE_ACCOUNT_JSON", "").strip()
    if service_json:
        info = json.loads(service_json)
        return service_account.Credentials.from_service_account_info(
            info,
            scopes=["https://www.googleapis.com/auth/drive.file"],
        )

    service_file = os.getenv("GOOGLE_SERVICE_ACCOUNT_FILE", "").strip()
    if service_file and Path(service_file).is_file():
        return service_account.Credentials.from_service_account_file(
            service_file,
            scopes=["https://www.googleapis.com/auth/drive.file"],
        )
    return None


def upload_pdf_to_drive(file_storage, filename):
    """Upload a PDF to Google Drive. Returns (web_view_link, file_id, error_message)."""
    if not drive_configured():
        return None, None, "Google Drive is not configured."

    try:
        from googleapiclient.discovery import build
        from googleapiclient.http import MediaIoBaseUpload
    except ImportError:
        return None, None, "Google Drive libraries are not installed."

    folder_id = os.getenv("GOOGLE_DRIVE_FOLDER_ID", "").strip()

    try:
        credentials = _google_credentials()
        if credentials is None:
            return None, None, "Google Drive credentials are not configured."

        service = build("drive", "v3", credentials=credentials, cache_discovery=False)

        file_storage.stream.seek(0)
        media = MediaIoBaseUpload(
            file_storage.stream,
            mimetype="application/pdf",
            resumable=True,
        )
        metadata = {
            "name": filename,
            "parents": [folder_id],
        }
        created = service.files().create(
            body=metadata,
            media_body=media,
            fields="id, webViewLink",
        ).execute()

        file_id = created.get("id")
        link = created.get("webViewLink")
        if file_id and not link:
            link = f"https://drive.google.com/file/d/{file_id}/view"
        return link, file_id, None
    except Exception as exc:
        current_app.logger.exception("Google Drive upload failed")
        return None, None, f"Google Drive upload failed: {exc}"


def save_pdf_locally(file_storage, record_id, filename):
    """Save PDF under uploads/rmt/<record_id>/ and return relative path."""
    upload_root = writable_upload_root(current_app.root_path) / "rmt" / str(record_id)
    upload_root.mkdir(parents=True, exist_ok=True)
    safe_name = Path(filename).name
    target = upload_root / safe_name
    file_storage.save(str(target))
    if is_serverless_runtime():
        return str(target)
    return f"uploads/rmt/{record_id}/{safe_name}"


def resolve_pdf_path(relative_path):
    path = Path(relative_path)
    if path.is_absolute():
        return path
    base = Path(current_app.root_path).parent
    return base / relative_path


def guess_pdf_mimetype(filename):
    import mimetypes

    guessed, _ = mimetypes.guess_type(filename)
    return guessed or "application/pdf"
