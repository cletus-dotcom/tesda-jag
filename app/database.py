import os
from urllib.parse import parse_qsl, urlencode, urlparse, urlunparse


def is_serverless_runtime():
    return bool(os.getenv("VERCEL") or os.getenv("AWS_LAMBDA_FUNCTION_NAME"))


def is_production():
    return os.getenv("FLASK_ENV", "").lower() == "production" or is_serverless_runtime()


def normalize_database_url(url):
    if not url:
        return url

    value = url.strip()
    if value.startswith("postgres://"):
        value = "postgresql+psycopg2://" + value[len("postgres://") :]
    elif value.startswith("postgresql://") and "+psycopg2" not in value:
        value = "postgresql+psycopg2://" + value[len("postgresql://") :]

    parsed = urlparse(value)
    query = dict(parse_qsl(parsed.query, keep_blank_values=True))
    host = parsed.hostname or ""
    if "sslmode" not in query and "supabase.co" in host:
        query["sslmode"] = "require"
    return urlunparse(parsed._replace(query=urlencode(query)))


def build_database_url(db_config):
    explicit = (
        os.getenv("DATABASE_URL")
        or os.getenv("SUPABASE_DB_URL")
        or os.getenv("SUPABASE_DATABASE_URL")
    )
    if explicit:
        return normalize_database_url(explicit)

    return (
        f"postgresql+psycopg2://{db_config['db_user']}:{db_config['db_pass']}@"
        f"{db_config['db_ip']}:{db_config['db_port']}/{db_config['db_name']}"
    )


def sqlalchemy_engine_options():
    from sqlalchemy.pool import NullPool

    options = {"pool_pre_ping": True}
    if is_serverless_runtime():
        options["poolclass"] = NullPool
    return options


def writable_upload_root(app_root_path):
    """Return a writable uploads directory for the current runtime."""
    from pathlib import Path

    if is_serverless_runtime():
        return Path("/tmp") / "tesda-jag" / "uploads"
    return Path(app_root_path).parent / "uploads"


def should_bootstrap_database():
    return os.getenv("SKIP_DB_BOOTSTRAP", "").lower() not in ("1", "true", "yes")
