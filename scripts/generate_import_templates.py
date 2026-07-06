"""Generate Excel import templates in the project root."""

from pathlib import Path

from app import create_app
from app.portal_admin_service import build_dts_template_workbook, build_rmt_template_workbook

ROOT = Path(__file__).resolve().parent.parent


def main():
    app = create_app()
    with app.app_context():
        dts_path = ROOT / "dts_docs_import_template.xlsx"
        rmt_path = ROOT / "rmt_records_import_template.xlsx"

        build_dts_template_workbook().save(dts_path)
        build_rmt_template_workbook().save(rmt_path)

        print(f"Created {dts_path}")
        print(f"Created {rmt_path}")


if __name__ == "__main__":
    main()
