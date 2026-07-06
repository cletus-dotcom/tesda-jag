import sys
from pathlib import Path

# Ensure project root is importable when Vercel loads api/index.py
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from app import create_app

app = create_app()
