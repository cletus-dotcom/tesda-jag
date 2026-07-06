# TESDA PTC-JAGNA Document Tracking System

Mobile-first document tracking application for **TESDA Provincial Training Center - Jagna**, built with Python, Flask, and PostgreSQL. Cloned from the MIS-Jag DTS module.

## Features

- Document routing with auto-generated route numbers
- Office-based document inbox (today's transactions)
- Document history audit trail
- Admin user and department management
- PDF export of document list
- Database backup (admin)

## Quick Start

### 1. Create PostgreSQL database

```sql
CREATE DATABASE tesda_jag;
```

### 2. Configure environment

Copy `.env.example` to `.env` and update your database credentials:

```
DB_USER=postgres
DB_PASS=your_password
DB_IP=127.0.0.1
DB_PORT=5432
DB_NAME=tesda_jag
SECRET_KEY=your-secret-key
FLASK_ENV=development
PORT=8030
```

### 3. Install dependencies

```bash
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

### 4. Run the app

```bash
python run.py
```

Open http://127.0.0.1:8030 in your browser.

### 5. First-time setup

On first visit, go to **Login** and use **Register Admin** to create the initial administrator account. Default department codes are seeded automatically (PTC Admin, Assessment, Finance, etc.).

## Project Structure

```
tesda-jag/
├── app/
│   ├── __init__.py      # App factory
│   ├── config.py        # DB config, offices, TESDA colors
│   ├── models.py        # User, DtsDoc, DtsHistory, DeptRef
│   ├── routes.py        # All DTS routes
│   └── utils.py         # Route number generation, backup
├── templates/           # Mobile-first Jinja2 templates
├── static/              # Bootstrap, TESDA logo
├── run.py               # Entry point
└── requirements.txt
```

## Branding

The UI uses TESDA's official blue (`#0033A0`) from the logo, with a mobile-first responsive layout.
