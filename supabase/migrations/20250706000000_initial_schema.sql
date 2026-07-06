-- TESDA PTC-JAGNA initial schema for Supabase PostgreSQL
-- Apply via Supabase Dashboard → SQL Editor, or: supabase db push

create table if not exists roles (
    role_id serial primary key,
    role_name varchar(50) not null unique,
    description text
);

create table if not exists users (
    user_id serial primary key,
    username varchar(100) not null unique,
    password_hash varchar(255) not null,
    full_name varchar(150),
    office varchar(150),
    email varchar(120) unique,
    role varchar(20) default 'Employee',
    status varchar(20) default 'Active'
);

create table if not exists dept_ref (
    id serial primary key,
    dept_name varchar(150) not null unique,
    dept_code varchar(20) not null unique
);

create table if not exists dts_docs (
    id serial primary key,
    doc_type varchar(40),
    doc_type_part varchar(80),
    date_received date,
    origin varchar(40),
    other_office varchar(40),
    subject varchar(220),
    doc_link varchar(80),
    route_number varchar(20) not null unique,
    classification varchar(20),
    action_needed varchar(50),
    action_part varchar(80),
    action_particulars varchar(220),
    resp_unit varchar(40),
    responsible_person varchar(40),
    action_provided varchar(220),
    date_accomp date,
    status varchar(20),
    forwarded_to varchar(40),
    forwarded_to_part varchar(80),
    date_encoded timestamp without time zone default now(),
    remarks text,
    date_updated timestamp without time zone
);

create table if not exists dts_history (
    unique_id serial primary key,
    route_number varchar(20) not null,
    user_name varchar(100) not null,
    action_provided varchar(220),
    status varchar(100),
    date_updated timestamp without time zone,
    forwarded_to varchar(40),
    forwarded_to_part varchar(80),
    resp_unit varchar(40),
    ip_address varchar(20),
    timestamp timestamptz default now(),
    date_received date,
    origin varchar(40),
    other_office varchar(40),
    doc_type varchar(40),
    doc_type_part varchar(80),
    classification varchar(20),
    subject varchar(220),
    doc_link varchar(80),
    action_needed varchar(50),
    action_part varchar(80),
    action_particulars varchar(220),
    responsible_person varchar(40)
);

create table if not exists rmt_records (
    id serial primary key,
    record_number varchar(24) not null unique,
    title varchar(220) not null,
    record_type varchar(60),
    record_type_part varchar(120),
    record_date date,
    pdf_link varchar(500),
    local_file_path varchar(300),
    drive_file_id varchar(100),
    cabinet_number varchar(20) not null,
    shelf_number varchar(20) not null,
    keywords text,
    remarks text,
    encoded_by varchar(150),
    date_encoded timestamp without time zone default now(),
    date_updated timestamp without time zone
);

insert into roles (role_name, description) values
    ('Admin', 'Full system access including user and department management.'),
    ('Staff', 'Can add and update documents.'),
    ('Employee', 'View-only access to documents.')
on conflict (role_name) do nothing;

insert into dept_ref (dept_name, dept_code) values
    ('Administrative', 'ADM01'),
    ('Training', 'TRN02'),
    ('Extension/Research', 'EXT03')
on conflict (dept_name) do nothing;
