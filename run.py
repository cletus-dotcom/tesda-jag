import os
import socket

from waitress import serve

from app import create_app

app = create_app()

if __name__ == "__main__":
    try:
        hostname = socket.gethostname()
        local_ip = socket.gethostbyname(hostname)
    except Exception:
        local_ip = "127.0.0.1"

    port = int(os.getenv("PORT", "8030"))
    debug_mode = os.getenv("FLASK_ENV", "development") == "development"

    if debug_mode:
        print(f"Local access: http://127.0.0.1:{port}")
        app.run(debug=True, host="0.0.0.0", port=port)
    else:
        print(f"Local access: http://127.0.0.1:{port}")
        print(f"LAN access:   http://{local_ip}:{port}")
        serve(app, host="0.0.0.0", port=port)
