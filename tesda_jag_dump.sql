--
-- PostgreSQL database dump
--

\restrict SjBJecWKCV4FVMhqNcF1Tkhub2Z6hwFXScwXZlRa0XXvcxXgaQR8CUzumzSaniV

-- Dumped from database version 15.18
-- Dumped by pg_dump version 15.18

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_username_key;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_key;
ALTER TABLE IF EXISTS ONLY public.roles DROP CONSTRAINT IF EXISTS roles_role_name_key;
ALTER TABLE IF EXISTS ONLY public.roles DROP CONSTRAINT IF EXISTS roles_pkey;
ALTER TABLE IF EXISTS ONLY public.rmt_records DROP CONSTRAINT IF EXISTS rmt_records_record_number_key;
ALTER TABLE IF EXISTS ONLY public.rmt_records DROP CONSTRAINT IF EXISTS rmt_records_pkey;
ALTER TABLE IF EXISTS ONLY public.dts_history DROP CONSTRAINT IF EXISTS dts_history_pkey;
ALTER TABLE IF EXISTS ONLY public.dts_docs DROP CONSTRAINT IF EXISTS dts_docs_route_number_key;
ALTER TABLE IF EXISTS ONLY public.dts_docs DROP CONSTRAINT IF EXISTS dts_docs_pkey;
ALTER TABLE IF EXISTS ONLY public.dept_ref DROP CONSTRAINT IF EXISTS dept_ref_pkey;
ALTER TABLE IF EXISTS ONLY public.dept_ref DROP CONSTRAINT IF EXISTS dept_ref_dept_name_key;
ALTER TABLE IF EXISTS ONLY public.dept_ref DROP CONSTRAINT IF EXISTS dept_ref_dept_code_key;
ALTER TABLE IF EXISTS public.users ALTER COLUMN user_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.roles ALTER COLUMN role_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.rmt_records ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.dts_history ALTER COLUMN unique_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.dts_docs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.dept_ref ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_user_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.roles_role_id_seq;
DROP TABLE IF EXISTS public.roles;
DROP SEQUENCE IF EXISTS public.rmt_records_id_seq;
DROP TABLE IF EXISTS public.rmt_records;
DROP SEQUENCE IF EXISTS public.dts_history_unique_id_seq;
DROP TABLE IF EXISTS public.dts_history;
DROP SEQUENCE IF EXISTS public.dts_docs_id_seq;
DROP TABLE IF EXISTS public.dts_docs;
DROP SEQUENCE IF EXISTS public.dept_ref_id_seq;
DROP TABLE IF EXISTS public.dept_ref;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dept_ref; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dept_ref (
    id integer NOT NULL,
    dept_name character varying(150) NOT NULL,
    dept_code character varying(20) NOT NULL
);


--
-- Name: dept_ref_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dept_ref_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dept_ref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dept_ref_id_seq OWNED BY public.dept_ref.id;


--
-- Name: dts_docs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dts_docs (
    id integer NOT NULL,
    doc_type character varying(40),
    date_received date,
    origin character varying(40),
    other_office character varying(40),
    subject character varying(220),
    doc_link character varying(80),
    route_number character varying(20) NOT NULL,
    action_needed character varying(50),
    action_part character varying(80),
    resp_unit character varying(40),
    responsible_person character varying(40),
    action_provided character varying(220),
    date_accomp date,
    status character varying(20),
    forwarded_to character varying(40),
    date_encoded timestamp without time zone,
    remarks text,
    date_updated timestamp without time zone,
    classification character varying(20),
    doc_type_part character varying(80),
    forwarded_to_part character varying(80),
    action_particulars character varying(220)
);


--
-- Name: dts_docs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dts_docs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dts_docs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dts_docs_id_seq OWNED BY public.dts_docs.id;


--
-- Name: dts_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dts_history (
    unique_id integer NOT NULL,
    route_number character varying(20) NOT NULL,
    user_name character varying(100) NOT NULL,
    action_provided character varying(220),
    status character varying(100),
    date_updated timestamp without time zone,
    forwarded_to character varying(40),
    resp_unit character varying(40),
    ip_address character varying(20),
    "timestamp" timestamp with time zone,
    date_received date,
    origin character varying(40),
    other_office character varying(40),
    doc_type character varying(40),
    subject character varying(220),
    doc_link character varying(80),
    action_needed character varying(50),
    action_part character varying(80),
    responsible_person character varying(40),
    classification character varying(20),
    doc_type_part character varying(80),
    forwarded_to_part character varying(80),
    action_particulars character varying(220)
);


--
-- Name: dts_history_unique_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dts_history_unique_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dts_history_unique_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dts_history_unique_id_seq OWNED BY public.dts_history.unique_id;


--
-- Name: rmt_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rmt_records (
    id integer NOT NULL,
    record_number character varying(24) NOT NULL,
    title character varying(220) NOT NULL,
    record_type character varying(60),
    record_type_part character varying(120),
    record_date date,
    pdf_link character varying(500),
    local_file_path character varying(300),
    drive_file_id character varying(100),
    cabinet_number character varying(20) NOT NULL,
    shelf_number character varying(20) NOT NULL,
    keywords text,
    remarks text,
    encoded_by character varying(150),
    date_encoded timestamp without time zone,
    date_updated timestamp without time zone
);


--
-- Name: rmt_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rmt_records_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rmt_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rmt_records_id_seq OWNED BY public.rmt_records.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    role_id integer NOT NULL,
    role_name character varying(50) NOT NULL,
    description text
);


--
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_role_id_seq OWNED BY public.roles.role_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    full_name character varying(150),
    office character varying(150),
    email character varying(120),
    role character varying(20),
    status character varying(20)
);


--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: dept_ref id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dept_ref ALTER COLUMN id SET DEFAULT nextval('public.dept_ref_id_seq'::regclass);


--
-- Name: dts_docs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dts_docs ALTER COLUMN id SET DEFAULT nextval('public.dts_docs_id_seq'::regclass);


--
-- Name: dts_history unique_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dts_history ALTER COLUMN unique_id SET DEFAULT nextval('public.dts_history_unique_id_seq'::regclass);


--
-- Name: rmt_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rmt_records ALTER COLUMN id SET DEFAULT nextval('public.rmt_records_id_seq'::regclass);


--
-- Name: roles role_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN role_id SET DEFAULT nextval('public.roles_role_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: dept_ref; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dept_ref (id, dept_name, dept_code) FROM stdin;
1	Administrative	ADM01
5	Training	TRN02
8	Extension/Research	EXT03
\.


--
-- Data for Name: dts_docs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dts_docs (id, doc_type, date_received, origin, other_office, subject, doc_link, route_number, action_needed, action_part, resp_unit, responsible_person, action_provided, date_accomp, status, forwarded_to, date_encoded, remarks, date_updated, classification, doc_type_part, forwarded_to_part, action_particulars) FROM stdin;
1	Memorandum	2026-01-05	Central Office	\N	Conduct of Inspection of Multimedia Development Equipment and Creative Cloud Software for 17 Innovation Centers & eTESDA PMO	\N	26010501	For Appropriate Action	\N	Extension/Research	\N	Sent via LBC Express address to PMO on Jan. 26, 2026	\N	Completed	\N	2026-07-06 15:19:36.229288	\N	\N	Inbound	\N	\N	Gunday to submit to PMO the required documents
2	TESDA Circular	2026-01-05	Central Office	\N	Promulgated Assessment Fees During the 148th TESDA Meeting	\N	26010502	For Information	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:19:36.238558	\N	\N	Inbound	\N	\N	Lozada to be informed of this new promulgated Assessment Fees
3	Advisory	2026-01-06	Provincial Office	\N	Attendance to Trainer's Moderation Program	\N	26010601	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.717531	\N	\N	Inbound	\N	\N	All Trainers are required to attend
4	Office Order	2026-01-06	Provincial Office	\N	Amendment re: Composition of Bid and Awards Committee (BAC) and Designation of OU	\N	26010602	For Guidance	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.723662	\N	\N	Inbound	\N	\N	Lozada, Suarez, Pechon and Gunday as members of BAC, to be informed
5	Advisory	2026-01-06	Provincial Office	\N	Agreement during the APTIB Year-End Fellowship	\N	26010603	For Information	\N	Administrative	\N	Posted to GC.	\N	Completed	\N	2026-07-06 15:21:37.726968	\N	\N	Inbound	\N	\N	For Information, Salazar to post to GC
6	Communication	2026-01-06	Others	BLECTEC President	Attendance to 1st Quarter BLECTEC, Inc. Meeting	\N	26010604	For Appropriate Action	\N	Training	\N	Noted.	\N	Completed	\N	2026-07-06 15:21:37.729596	\N	\N	Inbound	\N	\N	Pechon to encourage all CTECs of our STAR to attend.
7	Advisory	2026-01-08	Provincial Office	\N	Additional Instruction/ Reminders in the Conduct of Trainers Moderation on Jan. 15-16, 2026	\N	26010801	For Guidance	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.731864	\N	\N	Inbound	\N	\N	All trainers to be guided of all requirements for the trainer's moderation
8	Memorandum	2026-01-08	Provincial Office	\N	Use of TESDA Bohol Provincial Office Subscribed Zoom Account	\N	26010802	For Information	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.733487	\N	\N	Inbound	\N	\N	Lozada to take note of the Zoom Account for future use of Online Activities
9	Memorandum	2026-01-08	Others	Administrative Service	Dissemination of the Updated Contract of Service	\N	26010803	For Guidance	\N	Administrative	\N	Noted. Template already downloaded.	\N	Completed	\N	2026-07-06 15:21:37.735567	\N	\N	Inbound	\N	\N	Caido to be guided on the new COS Template
10	Memorandum	2026-01-08	Others	ROMO	Participation in the Agricultural Innovation Ecosystem Survey (SEEDS PROJECT)	\N	26010804	Others	N/A	Administrative	\N	Survey is not applicable to our institution	\N	Completed	\N	2026-07-06 15:21:37.737326	\N	\N	Inbound	\N	\N	Survey is not applicable to our institution
11	Memorandum	2026-01-08	Others	ROMO	Survey on the Readiness of TTIs in Implementing TVET Educators Development Programs	\N	26010805	For Appropriate Action	\N	Administrative	\N	Done fill-up.	\N	Completed	\N	2026-07-06 15:21:37.738892	\N	\N	Inbound	\N	\N	Lozada to fill up the survey
12	Office Order	2026-01-08	Provincial Office	\N	Attendance to Management Committee Meeting	\N	26010806	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.740566	\N	\N	Inbound	\N	\N	Caido to update OPCR Accomplishment 2025
13	Memorandum	2026-01-08	Regional Office	\N	Submission of Documents	\N	26010807	For Appropriate Action	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.742263	\N	\N	Inbound	\N	\N	All regular staff to be guided on the submission timeline.
14	Memorandum	2026-01-09	Others	Financial and Management Services	Submission of FY 2027 Budget Proposal	\N	26010901	Others	N/A	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:37.744345	\N	\N	Inbound	\N	\N	We will not submit.
15	Memorandum	2026-01-09	Others	Administration and Innovation	Registration to the Career Service Examination Review	\N	26010902	For Information	\N	Training	\N	Noted.	\N	Completed	\N	2026-07-06 15:21:37.746017	\N	\N	Inbound	\N	\N	RL MAdera to register if interested
16	Memorandum	2026-01-09	Others	PTC-Inabanga	Benchmarking Activity of PTC-Inabanga Trainers	\N	26010903	For Information	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.747561	\N	\N	Inbound	\N	\N	All trainers to prepare their areas
17	Memorandum	2026-01-13	Others	Policies and Planning Office	Request for Comments to the Proposed Enhanced IGs for the Recognition of Prior Learning in TVET	\N	26011301	For File	\N	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:37.749158	\N	\N	Inbound	\N	\N	No Comments
18	Memorandum	2026-01-13	Others	Administration and Innovation	Conduct of TNA for CY 2026-2028	\N	26011302	For Appropriate Action	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.75107	\N	\N	Inbound	\N	\N	Caido to facilitate submission of TNAs
19	Memorandum	2026-01-13	Others	PMO	Request for Technical Assistance on Industry Consultation	\N	26011303	For Appropriate Action	\N	Training	\N	Attended.	\N	Completed	\N	2026-07-06 15:21:37.753112	\N	\N	Inbound	\N	\N	Pechon & Gunday to serve as technical experts
20	Office Order	2026-01-13	Provincial Office	\N	Authority to Act as TESDA Rep during the Conduct of Competency Assessment and Certification	\N	26011304	For Information	\N	Administrative	\N	Posted to GC	\N	Completed	\N	2026-07-06 15:21:37.754807	\N	\N	Inbound	\N	\N	Salazar to post to GC for everyone's awareness
21	Office Order	2026-01-14	Regional Office	\N	Attendance to the ASSIST Project SustainABILITY- NextGen Workforce 2.0 Project Launch on January 16, 2026	\N	26011401	For Information	\N	Training	\N	On file	\N	Completed	\N	2026-07-06 15:21:37.756445	\N	\N	Inbound	\N	\N	Conflict to the schedule of Trainer's Moderation
22	Communication	2026-01-21	Jagna LGU	\N	Schedule of Offices to Lead the Zumba	\N	26012101	For Information	\N	Administrative	\N	Posted to GC	\N	Completed	\N	2026-07-06 15:21:37.758055	\N	\N	Inbound	\N	\N	Caido to plan & lead the zumba
23	Communication	2026-01-21	Others	PMO	Notice of Meeting for SIPTVETS-RTIC Beneficiaries	\N	26012102	For Information	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.760269	\N	\N	Inbound	\N	\N	Sir Inar will attend
24	Memorandum	2026-01-22	Others	ROMO	Request for Nomination on the National TVET Educators Development Programs	\N	26012201	For Appropriate Action	\N	Administrative	\N	Nomination Form sent to RO for RDs approval	\N	Completed	\N	2026-07-06 15:21:37.76198	\N	\N	Inbound	\N	\N	Ma'am Caido to send nomination
25	Communication	2026-01-23	Others	San Roque National High School	Request for Resource Speaker in Career Guidance of Grade 10 and 12 learners on February 3, 2026	\N	26012301	For Appropriate Action	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.763552	\N	\N	Inbound	\N	\N	MLO Caido will attend in behalf of JKT Gunday
26	Office Order	2026-01-22	Provincial Office	\N	Authority to Attend Meeting for the Preparation of Supplemental Requirements of the ECCDS NC III	\N	26012202	For Appropriate Action	\N	Training	\N	Attended	\N	Completed	\N	2026-07-06 15:21:37.765131	\N	\N	Inbound	\N	\N	Gomez and Pechon to attend the meeting
27	Office Order	2026-01-26	Provincial Office	\N	Working Committees in the Conduct of Closing Ceremony for Korean and Japanese Language and MOA Signing	\N	26012601	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.768087	\N	\N	Inbound	\N	\N	Lozada, Pechon & Suarez to prepare and take note of their responsibilies
28	Office Order	2026-01-27	Regional Office	\N	Authority to Attend the Technology Research Workshop	\N	26012701	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.770319	\N	\N	Inbound	\N	\N	Pechon and Gunday to attend on this workshop on Feb. 3-4, 2026
29	Communication	2026-01-27	Mabini LGU	\N	Request for Conduct of CBT on EIM, Driving and Housekeeping	\N	26012702	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.772199	\N	\N	Inbound	\N	\N	Sir Suarez to supervise implementation and Pechon to coordinate w/ Ms. Hiyangan
30	Communication	2026-01-27	Lila LGU	\N	Request for Resource Speaker for Career Guidance of Grade 10 & 12 learners of Lila National High School on February 12, 2026	\N	26012703	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.774013	\N	\N	Inbound	\N	\N	JKT Gunday will serve as speaker
34	Memorandum	2026-02-02	Others	ROMO	Submission of Documentary Reports on Donations Provided by Private Partners to the TTIs	\N	26020201	For File	\N	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:37.782384	\N	\N	Inbound	\N	\N	We have no donations provided by Private Partners
38	Advisory	2026-02-05	Provincial Office	\N	Full Cooperation in the Conduct of an Applied Research on a Web-Based...	\N	26020502	For Appropriate Action	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.789299	\N	\N	Inbound	\N	\N	Lozada to provide assistance to Mr. Nazareno
42	Communication	2026-02-10	Others	BOHECO II	Request for Resource Speaker for Safety & Electrical Procedures & Basic Bookkeeping	\N	26021001	For Appropriate Action	\N	Training	\N	Magadan & Abacial wasn't able to attend due to conflict in assessment schedule	\N	Completed	\N	2026-07-06 15:21:37.79642	\N	\N	Inbound	\N	\N	Magadan & Abacial as speakers on the said topics
46	Memorandum	2026-02-13	Others	Policies and Planning Office	Validation and Submission of Inputs to the TESDA FY GAD AR and FY 2026 GAD Plan and Budget	\N	26021302	For Appropriate Action	\N	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:37.803066	\N	\N	Inbound	\N	\N	Caido to take action on this matter
50	Office Order	2026-02-19	Provincial Office	\N	Attendance to the Pre-Planning Workshop Conference	\N	26021902	For Appropriate Action	\N	Administrative	\N	Attended	\N	Completed	\N	2026-07-06 15:21:37.810438	\N	\N	Inbound	\N	\N	Caido and Sir Inar attended
54	Communication	2026-02-24	Jagna LGU	\N	ESWM Board Meeting	\N	26022401	For Information	\N	Administrative	\N	Sir Inar didn't able to attend due to virtual meeting	\N	Completed	\N	2026-07-06 15:21:37.817013	\N	\N	Inbound	\N	\N	\N
58	Memorandum	2026-02-26	Others	Policies and Planning Office	Conduct of the 1st Survey Round for the 2026 User's Feedback Survey on the Policy Issuances of TESDA	\N	26022601	For Appropriate Action	\N	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:37.823918	\N	\N	Inbound	\N	\N	Sir Inar is already done with the survey
62	Advisory	2026-03-27	Provincial Office	\N	Attendance to APTIB Inc. General Assembly	\N	26032701	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.83256	\N	\N	Inbound	\N	\N	Sir Inar will attend on this meeting on March 6, 2026 at Reyna's
66	Advisory	2026-03-03	Others	Qualifications and Standards Office	Registration to the Deployment of Amended Omnibus Guidelines on TVET Micr-credentials and Developed National and ABDD TVET CS	\N	26030302	For Appropriate Action	\N	Administrative	\N	Attended by Caido	\N	Completed	\N	2026-07-06 15:21:37.839689	\N	\N	Inbound	\N	\N	Caido will attend
70	Advisory	2026-03-10	Provincial Office	\N	Participation to the 2026 Provincial Skills Olympics	\N	26031001	For Information	\N	Administrative	\N	Posted to GC for everyone's information	\N	Completed	\N	2026-07-06 15:21:37.847719	\N	\N	Inbound	\N	\N	\N
74	Office Order	2026-03-25	Provincial Office	\N	Amendment to Office Order No. 016 S. of 2026 re: Working Committees in the Conduct of the 2026 Provincial Skills Olympics	\N	26032502	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.855431	\N	\N	Inbound	\N	\N	\N
78	Memorandum	2026-03-25	Others	ROMO	Request for Nomination of Participants for the Conduct of various Regional Lead Trainers Development Programs	\N	26032506	For File	\N	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:37.86465	\N	\N	Inbound	\N	\N	Will not send participants
82	Memorandum	2026-04-07	Others	PMO	Training Notice for G101-A: Lot 1- Supply and Delivery of Multimedia Development Equipment for 17 RTICS and eTESDA PMO	\N	26040701	For Appropriate Action	\N	Extension/Research	\N	Noted.	\N	Completed	\N	2026-07-06 15:21:37.871968	\N	\N	Inbound	\N	\N	Gunday to attend to this meeting
86	Memorandum	2026-04-20	Others	ROMO	Request for Nomination of Participants for the Conduct of Various Regional Lead Trainers Development Program	\N	26042004	For Nomination	\N	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:37.879809	\N	\N	Inbound	\N	\N	Will not send participants
90	Memorandum	2026-04-28	Central Office	\N	Reiteration on the proper use of TESDA Motor Vehicles	\N	26042801	For Dissemination	\N	Administrative	\N	\N	\N	Completed	\N	2026-07-06 15:21:37.887415	\N	\N	Inbound	\N	\N	\N
94	Office Order	2026-04-30	Provincial Office	\N	Authority to Attend an Exposure Training in ECCD NC III	\N	26043004	For Appropriate Action	\N	Administrative	\N	Noted.	\N	Completed	\N	2026-07-06 15:21:37.893634	\N	\N	Inbound	\N	\N	Attention PMC Salazar and RA Gomez
98	Office Order	2026-05-13	Provincial Office	\N	Authority to attend the Trainer's Moderation and Assessor's Calibration Program	\N	26051302	For Guidance	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.900226	\N	\N	Inbound	\N	\N	attention Mr. Pechon
102	Memorandum	2026-06-02	Central Office	\N	Call for Nominations to the Technical Training on ''From Creation to Disposal: Pravtical Records Management for LGUs and NGAs''	\N	26060201	For Appropriate Action	\N	Administrative	\N	We will not send Participants	\N	Completed	\N	2026-07-06 15:21:37.907731	\N	\N	Inbound	\N	\N	we will not send Nomination
106	Memorandum	2026-06-02	Central Office	\N	Requesting COROPOTI's to provide inputs into and update entries in the TVET Research Monitoring Database	\N	26060205	For Appropriate Action	\N	Training	\N	Noted.	\N	Completed	\N	2026-07-06 15:21:37.914944	\N	\N	Inbound	\N	\N	attention all trainers
110	Memorandum	2026-06-03	Central Office	\N	Nomination to the CPSC Collaborative Regional Program on "Future-Ready Workforce and Skills Development''	\N	26060302	For Appropriate Action	\N	Administrative	\N	We will not send Participants	\N	Completed	\N	2026-07-06 15:21:37.92342	\N	\N	Inbound	\N	\N	we will not send Nomination
114	Communication	2026-06-08	Jagna LGU	\N	Observance of the 128th Anniversary of the proclamation of Philippine Independence Day	\N	26060801	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.930475	\N	\N	Inbound	\N	\N	Post on GC
118	Office Order	2026-06-15	Regional Office	\N	Athority to attend the 2nd Quarter RTESDC Meeting	\N	26061502	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.937831	\N	\N	Inbound	\N	\N	Sir inar will attend
122	Memorandum	2026-06-15	Regional Office	\N	Comments on the Submitted Registry of Relevant Risk and Opportunities (RRRO) as of April 15, 2026	\N	26061506	For Appropriate Action	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.945058	\N	\N	Inbound	\N	\N	Mr. Lozada Please see to it
126	Memorandum	2025-09-01	Central Office	\N	Conduct of the Third Survey Round for the 2025 Users Feedback Survey on the Policy Issuances/Guidelines of TESDA	https://bit.ly/3rdSun/eyRound2025UFS	25090101	For File	\N	Administrative	\N	Accomplished	\N	Completed	\N	2026-07-06 15:21:37.952195	\N	\N	Inbound	\N	\N	Accomplished
130	Advisory	2025-09-12	Central Office	\N	Submission of CY 2025 Applications for Asia Pacific Accreditation and Certification Commission (APACC)	https://tinyurl.com/2025APACC	25091201	For File	\N	Administrative	\N	Filed.	\N	Completed	\N	2026-07-06 15:21:37.959502	\N	\N	Inbound	\N	\N	We are not qualified for APACC
134	Office Order	2025-09-12	Regional Office	\N	Attendance at the Conduct of the Regional Multiplier Training on the Development of Training Plans for the CBTP	\N	25091205	For Information	\N	Training	\N	RL Madera attended the training on Sept. 15-16, 2025	\N	Completed	\N	2026-07-06 15:21:37.966475	\N	\N	Inbound	\N	\N	RL Madera to prepare for the training.
138	Office Order	2025-09-23	Regional Office	\N	Physical Count of PPE for PTCs Cebu, Bohol, Dumaguete & Siquijor, LTI...	\N	25092301	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.973648	\N	\N	Inbound	\N	\N	Gunday to prepare docs for this activity
31	Communication	2026-01-27	Lila LGU	\N	Request for Resource Speaker on Career Guidance for Grades 10 & 12 learners of Holy Rosary Academy on February 5, 2026	\N	26012704	For Appropriate Action	\N	Extension/Research	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.777046	\N	\N	Inbound	\N	\N	Sir JC will serve as speaker
35	Memorandum	2026-02-03	Regional Office	\N	CY 2025 4th Quarter Issue of the Central Visayas Journal	\N	26020301	For Information	\N	Administrative	\N	Link posted to GC	\N	Completed	\N	2026-07-06 15:21:37.784354	\N	\N	Inbound	\N	\N	Lozada to post link on GC for everyone's information
39	Memorandum	2026-02-05	Provincial Office	\N	Orientation on ACDI Multipurpose Cooperative Information Drive	\N	26020503	For Dissemination	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.791002	\N	\N	Inbound	\N	\N	Caido to ensure all regular staff will attend
43	Memorandum	2026-02-11	Others	ROMO	Survey on TVET Trainer's Educational Background for Career Pathway Support	\N	26021101	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.797897	\N	\N	Inbound	\N	\N	Caido to facilitate all trainers to accomplish the survey
47	Communication	2026-02-16	Provincial Office	\N	Summary of BSRS/T2MIS Feedback Monitoring as of December 31, 2025	\N	26021601	For Appropriate Action	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.804715	\N	\N	Inbound	\N	\N	\N
51	Memorandum	2026-02-19	Others	SIPTVETS PMO	Advisory on the Conduct of Design Thinking Workshop for TTIs	\N	26021903	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.812079	\N	\N	Inbound	\N	\N	Suarez,Pechon & Gunday as participants on this workshop
55	TESDA Order	2026-02-24	Central Office	\N	Attendance to the CBP on Strengthening Quality Assurance Practices through QMS for TESDA STAR ad TESDA SEAL Applicants (Batch 2,3 & 4)	\N	26022402	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.818909	\N	\N	Inbound	\N	\N	Caido & Lozada to be reminded
59	Memorandum	2026-02-27	Others	PMO	Advisory on the Conduct of the RTIC Visioning Workshop	\N	26022701	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.825655	\N	\N	Inbound	\N	\N	Sir Inar will Attend on March 2-4, 2026
63	Advisory	2026-03-02	Others	Certification Office	Reminders on the Capability Building Program on Strengthening Quality Assurance Practices Through QMS for TESDA STAR and TESDA SEAL Applicants	\N	26030201	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.834465	\N	\N	Inbound	\N	\N	For guidance of Caido and Lozada
67	Memorandum	2026-03-03	Regional Office	\N	Norming Activities for the Development of Career Profiling Instrument (CPI)	\N	26030303	For Appropriate Action	\N	Administrative	\N	Care of Lozada	\N	Completed	\N	2026-07-06 15:21:37.841336	\N	\N	Inbound	\N	\N	\N
71	Others	2026-03-12	Provincial Office	\N	Notice of Meeting: Preparation on the Conduct of 2026 Provincial Skills Olympics & Office Order: Working Committees in the Conduct of 2026 PSO	\N	26031201	For Information	\N	Administrative	\N	Meeting Attended by members of the committee	\N	Completed	\N	2026-07-06 15:21:37.849499	\N	\N	Inbound	N/A	\N	\N
75	Advisory	2026-03-25	Provincial Office	\N	Schedule for Site Visit	\N	26032503	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.85739	\N	\N	Inbound	\N	\N	Magadan, Gunday & Madera to go to the site inspection
79	Memorandum	2026-03-26	Others	Administration and Innovation	Nomination of Participants to the Earth Month 2026 Capacity Building Programs Sessions	\N	26032601	For Nomination	\N	Administrative	\N	Accomplished nomination form from the link provided.	\N	Completed	\N	2026-07-06 15:21:37.866488	\N	\N	Inbound	\N	\N	Nominate Gunday for this CBP Sessions
83	Memorandum	2026-04-20	Others	Administration and Innovation	Reiteration on the Updating of the Status of Motor Vehicle and Land Property Inventory of TESDA COROPOTIs	\N	26042001	For Appropriate Action	\N	Extension/Research	\N	No further updates, as advised by PO.	\N	Completed	\N	2026-07-06 15:21:37.873498	\N	\N	Inbound	\N	\N	Gunday to update
87	Memorandum	2026-04-22	Central Office	\N	Flexible Learning Arrangements in Times of Energy Crisis	\N	26042201	For Guidance	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.881574	\N	\N	Inbound	\N	\N	For guidance to all trainers
91	Advisory	2026-04-30	Others	ICTO	Attendance of the ROPOTI Officials and Personnel to the Training on the Deployment of Document & Records Management Info. System	\N	26043001	For File	\N	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:37.888892	\N	\N	Inbound	\N	\N	\N
95	Advisory	2026-04-30	Provincial Office	\N	Deployment of Learner's Satisfaction Survey to all TESDA Scholars	\N	26043005	For Appropriate Action	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.895385	\N	\N	Inbound	\N	\N	All trainers provide all survey at the end of training
99	Office Order	2026-05-13	Provincial Office	\N	Addendum to Office Order No. 030 of 2026 re; Authority to attend the Competency Assessor's Calibration	\N	26051303	For Guidance	\N	Training	\N	attention all concerned	\N	Completed	\N	2026-07-06 15:21:37.902322	\N	\N	Inbound	\N	\N	Attention GD Magadan, RL Madera and ER Salazar
103	Memorandum	2026-06-02	Regional Office	\N	2026 Search for ''Best Brigada Ahensiya''	\N	26060202	For File	\N	Administrative	\N	Just an info for us	\N	Completed	\N	2026-07-06 15:21:37.909955	\N	\N	Inbound	\N	\N	Just an Info for us
107	Memorandum	2026-06-02	Central Office	\N	Utilization of Newly Developed TOP Courses	\N	26060206	For Appropriate Action	\N	Administrative	\N	Chester informed so with NiÃ±o	\N	Completed	\N	2026-07-06 15:21:37.916548	\N	\N	Inbound	\N	\N	Coordinate with trainers for possibility of offering this qualifications
111	Memorandum	2026-06-03	Regional Office	\N	Work Instruction for the Implementation of TRAIN LOKAL	\N	26060303	For Appropriate Action	\N	Training	\N	Noted.	\N	Completed	\N	2026-07-06 15:21:37.925066	\N	\N	Inbound	\N	\N	Just like CBT Program ''Same dog - wearing another collar!
115	Memorandum	2026-06-10	Central Office	\N	Clarification on the Memorandum on the Reversion to the Five day Workout	\N	26061001	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.932009	\N	\N	Inbound	\N	\N	Noted
119	Memorandum	2026-06-15	Regional Office	\N	Call for Applicants/Nominations for the 2026 Blue Hearts Award	\N	26061503	For Appropriate Action	\N	Administrative	\N	This is unnecessary	\N	Completed	\N	2026-07-06 15:21:37.939464	\N	\N	Inbound	\N	\N	we have none
123	Advisory	2025-08-14	Provincial Office	\N	Invitation to ASEAN Toolbox Immersion Workshop	\N	25081401	For Appropriate Action	\N	Training	\N	Already registered.	\N	Completed	\N	2026-07-06 15:21:37.946575	\N	\N	Inbound	\N	\N	This is already due. RL Madera to register.
127	Communication	2025-09-04	Lila LGU	\N	Local and Overseas Jobs Fair	\N	25090401	For Appropriate Action	\N	Training	\N	Coordinated with PESO Lila, sent Confirmation Slip to the email provided.	\N	Completed	\N	2026-07-06 15:21:37.95405	\N	\N	Inbound	\N	\N	Coordinate with PESO Lila.
131	Memorandum	2025-09-12	Central Office	\N	Implementation of the AUP	\N	25091202	For Appropriate Action	\N	Administrative	\N	Accomplished AUP submitted to PO	\N	Completed	\N	2026-07-06 15:21:37.96158	\N	\N	Inbound	\N	\N	Caido to facilitate printing of AUP, distribute to all staff.
135	Others	2025-09-15	Others	BLECTEC President	Attendance to 3rd Quarter BLECTEC, Inc. Meeting	\N	25091501	For Appropriate Action	\N	Training	\N	MNL Pechon will attend	\N	Completed	\N	2026-07-06 15:21:37.968526	\N	\N	Inbound	N/A	\N	Pechon to attend on this meeting and follow-up our STAR CTECs
139	Memorandum	2025-09-24	Central Office	\N	Agency-Wide Conduct of the Information Process Flow Mapping Survey	\N	25092401	For Dissemination	\N	Administrative	\N	Facilitated	\N	Completed	\N	2026-07-06 15:21:37.975355	\N	\N	Inbound	\N	\N	MLO Caido to facilitate all staff accomplishing the survey
143	TESDA Order	2025-09-29	Central Office	\N	Reconstitution of the TWG for the Conduct of Training-Cum-Workshops on the Procurement of SIPTVETS-RTICs Equipment	\N	25092902	For Nomination	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.982567	\N	\N	Inbound	\N	\N	Gunday and Pechon to take note of the changes of TWG
32	Advisory	2026-01-29	Provincial Office	\N	Reiteration of Omnibus Guidelines for the Implementation of FY 2025 TESDA Scholarship Programs Section 5.2 Submission of Billing Documents	\N	26012901	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.77892	\N	\N	Inbound	\N	\N	Lozada to be reminded on this matter.
36	Memorandum	2026-02-03	Central Office	\N	Highlights during the Joint General Directorate & AdCon held on 19-21 January 2026	\N	26020302	For Information	\N	Administrative	\N	Link posted to GC	\N	Completed	\N	2026-07-06 15:21:37.786187	\N	\N	Inbound	\N	\N	Lozada to post the link on GC for everyone's access
40	Memorandum	2026-02-09	Central Office	\N	Designation of Sanitation Officer & Energy Conservation Officer	\N	26020901	For Appropriate Action	\N	Administrative	\N	Printed Office Order	\N	Completed	\N	2026-07-06 15:21:37.793055	\N	\N	Inbound	\N	\N	Caido to make Office Order, Gunday as Sanitation & Conservation Officer
44	Office Order	2026-02-13	Provincial Office	\N	Attendance to the 1st Quarter BLECTEC Meeting	\N	26021301	For Information	\N	Training	\N	Attended	\N	Completed	\N	2026-07-06 15:21:37.799504	\N	\N	Inbound	\N	\N	Sir Inar, Pechon & Leo Ampo attended
48	Communication	2026-02-18	Others	Jagna High School	Request for Resource Speaker (Career Guidance) on Feb. 25, 2026	\N	26021801	For Appropriate Action	\N	Extension/Research	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.806395	\N	\N	Inbound	\N	\N	Gunday to serve as Resource Speaker
52	Advisory	2026-02-20	Provincial Office	\N	Submission of Notarized Affidavit of Undertaking	\N	26022001	For Appropriate Action	\N	Administrative	\N	Submitted before deadline.	\N	Completed	\N	2026-07-06 15:21:37.813742	\N	\N	Inbound	\N	\N	Lozada have submitted to PO the notarized AOU on Feb. 24, 2026
56	Communication	2026-02-25	Others	Calabacita National High School	Request for Guest Speakers for Career Guidance Program on February 27, 2026	\N	26022501	For Appropriate Action	\N	Training	\N	Attended.	\N	Completed	\N	2026-07-06 15:21:37.82055	\N	\N	Inbound	\N	\N	Gunday to serve as Guest Speaker for Career Guidance
60	Memorandum	2026-02-27	Others	SEIAC	The Semiconductor Asia Summit 2026 on March 5-6, 20226 at Penang, Malaysia	\N	26022702	For Information	\N	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:37.828526	\N	\N	Inbound	\N	\N	\N
64	Communication	2026-03-03	Jagna LGU	\N	Attendance to the Municipal Convergence Committee 1st Quarter Meeting	\N	26030301	For Appropriate Action	\N	Training	\N	Attended by Leo Ampo (Pechon on travel)	\N	Completed	\N	2026-07-06 15:21:37.836461	\N	\N	Inbound	\N	\N	Pechon to attend on this meeting
68	Office Order	2026-03-04	Provincial Office	\N	Attendance to the 1st Quarter PTESDC Meeting	\N	26030401	For Appropriate Action	\N	Training	\N	Attended.	\N	Completed	\N	2026-07-06 15:21:37.843892	\N	\N	Inbound	\N	\N	Suarez to attend to the meeting
72	Advisory	2026-03-17	Provincial Office	\N	Prioritization of 4Ps SHS Graduates/Graduating Students under TESDA Scholarship Programs	\N	26031701	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.851745	\N	\N	Inbound	\N	\N	Lozada and Caido to be reminded
76	Memorandum	2026-03-25	Others	Certification Office	Clarifications on the Exemption from the Conduct of Compliance Audit	\N	26032504	For Information	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.859758	\N	\N	Inbound	\N	\N	\N
80	Advisory	2026-03-30	Provincial Office	\N	Participation to the 2026 Provincial Skills Olympics	\N	26033001	For Information	\N	Administrative	\N	Posted to GC	\N	Completed	\N	2026-07-06 15:21:37.868643	\N	\N	Inbound	\N	\N	PMC Salazar to post this Advisory to GC for information of everyone
84	TESDA Order	2026-04-20	Others	Administration and Innovation	Attendance of TESDA Personnel in the Conduct of Training of Trainers on 2D/3D Mechanical Design using Autodesk Inventor	\N	26042002	For Information	\N	Extension/Research	\N	Noted.	\N	Completed	\N	2026-07-06 15:21:37.87497	\N	\N	Inbound	\N	\N	Gunday to prepare for the training
88	Memorandum	2026-04-22	Others	ROMO	Request for Nomination of Participants for the Conduct of the Organizational Planning/Strategic Planning in TVET	\N	26042202	For Information	\N	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:37.883369	\N	\N	Inbound	\N	\N	Will not send participants
92	Office Order	2026-04-30	Provincial Office	\N	Designation of Facilitators for the Conduct of Calibration and Assessor's Moderation	\N	26043002	For Guidance	\N	Administrative	\N	called Leo, and prepared letter Request for replacement from sir Gundat to Pechon	\N	Completed	\N	2026-07-06 15:21:37.890225	\N	\N	Inbound	\N	\N	Pechon as replacement participant
96	Memorandum	2026-05-06	Regional Office	\N	Status update of GAA TVET Activities with tie-ups with industry	\N	26050601	For Appropriate Action	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.896893	\N	\N	Inbound	\N	\N	Please take action MR. Pechon
100	Communication	2026-05-20	Garcia-Hernandez LGU	\N	Electrical Installation Management NC II training	\N	26052001	For File	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.904138	\N	\N	Inbound	\N	\N	attention GD Magadan
104	Memorandum	2026-06-02	Regional Office	\N	TESDC 1st Quarter Status Report CY 2026	\N	26060203	For Information	\N	Administrative	\N	Just an info for us	\N	Completed	\N	2026-07-06 15:21:37.911818	\N	\N	Inbound	\N	\N	Just an Info for us
108	Memorandum	2026-06-02	Central Office	\N	Compliance with NPC Registration and Privacy Notice/Consent Requirements	\N	26060207	For Guidance	\N	Administrative	\N	Just an info for us	\N	Completed	\N	2026-07-06 15:21:37.919846	\N	\N	Inbound	\N	\N	Just an Info for us
112	Office Order	2026-06-03	Provincial Office	\N	Working Committees in the Conduct Various Activities on June 25, 2026	\N	26060304	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.92746	\N	\N	Inbound	\N	\N	attention Mr. Lloren
116	Communication	2026-06-11	Provincial Office	\N	Bohol Province PESO - CTEC 2026 by STAR	\N	26061101	For File	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.933807	\N	\N	Inbound	\N	\N	Mr. Pechon will facilitate this communication to reach the CTEC's
120	Memorandum	2026-06-15	Central Office	\N	Approved Joint Memorandum Circular (JMC) for Bagong Pilipinas Merit Scholarship Program (BPMSP)	\N	26061504	For Information	\N	Administrative	\N	Just an info for us	\N	Completed	\N	2026-07-06 15:21:37.941262	\N	\N	Inbound	\N	\N	Just an Info for us
124	Memorandum	2025-08-19	Provincial Office	\N	Approved and Signed(MOA) for SIL	\N	25081901	For File	\N	Administrative	\N	Already on file	\N	Completed	\N	2026-07-06 15:21:37.948326	\N	\N	Inbound	\N	\N	Keep the MOA on file
128	Memorandum	2025-09-04	Regional Office	\N	National Accomplishments on FY 2025 Compliance Audit for Registered Programs and Qualifications of Accredited Assessment Centers from January to July 2025	\N	25090402	Kindly Provide Feedback	\N	Administrative	\N	All 6 qualifications are compliant	\N	Completed	\N	2026-07-06 15:21:37.955842	\N	\N	Inbound	\N	\N	Are we all compliant?
132	Office Order	2025-09-12	Provincial Office	\N	Attendance to 3rd Quarter PTESDC Meeting	\N	25091203	For Information	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.963216	\N	\N	Inbound	\N	\N	Pechon to be reminded
136	Memorandum	2025-09-16	Provincial Office	\N	Attendance of CP Lozada to the Data Privacy Competency Protection Framework Training	\N	25091601	For Information	\N	Administrative	\N	Attended	\N	Completed	\N	2026-07-06 15:21:37.970237	\N	\N	Inbound	\N	\N	Lozada to attend as ordered
140	TESDA Order	2025-09-24	Central Office	\N	Amendment of 2025 CB on Data Management & Monitoring & Evaluation for the SIPTVET Project	\N	25092402	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.977452	\N	\N	Inbound	\N	\N	Caido, Lozada & Suarez to take note of the amendment of your CB on DM
144	Memorandum	2025-09-29	Regional Office	\N	Job Openings for Skilled Professionals from Cebu Doctor's University	\N	25092903	For Dissemination	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.984391	\N	\N	Inbound	\N	\N	Gunday to disseminate this job opportunity to our graduates
33	Memorandum	2026-01-29	Central Office	\N	Dissemination of the COA Schedule of Course Offerings for Agency Personnel CY 2026	\N	26012902	For File	\N	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:37.780607	\N	\N	Inbound	\N	\N	We will not send participants
37	Memorandum	2026-02-05	Central Office	\N	Call for Nomination to the ITAPS and Anti-Corruption Laws Seminar	\N	26020501	For Appropriate Action	\N	Administrative	\N	Nomination Form sent to PO	\N	Completed	\N	2026-07-06 15:21:37.787771	\N	\N	Inbound	\N	\N	Caido to ask interested regular staff and endorse to RO
41	Memorandum	2026-02-09	Others	DDG- Policies and Planning	Request for the Dissemination of the SNA Questionnaire for the RTIC Visioning Workshop	\N	26020902	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.794875	\N	\N	Inbound	\N	\N	Pechon to ensure all respondents to accomplish the SNA
45	Communication	2026-02-12	Others	Cogtong National High School	Request for Resource Speaker for Career Talk Symposium	\N	26021201	For Appropriate Action	\N	Extension/Research	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.801364	\N	\N	Inbound	\N	\N	Gunday to serve as Resource Speaker
49	Office Order	2026-02-19	Regional Office	\N	Authority to Attend the Pre-Planning Workshop	\N	26021901	For Appropriate Action	\N	Administrative	\N	Attended	\N	Completed	\N	2026-07-06 15:21:37.808077	\N	\N	Inbound	\N	\N	Caido and Sir Inar attended
53	Advisory	2026-02-23	Provincial Office	\N	Attendance to the Learning Session/ ROrientation in the Conduct of Compliance Audit for Program Registration & Competency Assessment & Certification	\N	26022301	For Appropriate Action	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.815501	\N	\N	Inbound	\N	\N	Caido & Lozada to attend on the Orientation
57	Memorandum	2026-02-25	Provincial Office	\N	Request of TTIs Staff Augmentation	\N	26022502	For Appropriate Action	\N	Administrative	\N	Abacial to report to PO every Monday	\N	Completed	\N	2026-07-06 15:21:37.822269	\N	\N	Inbound	\N	\N	Abacial to represent PTC-Jagna
61	Communication	2026-02-27	Others	PESO-Mabini	Invitation for Career Guidance	\N	26022703	For Appropriate Action	\N	Extension/Research	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.830744	\N	\N	Inbound	\N	\N	Gunday to serve as Guest Speaker for Career Guidance
65	Communication	2026-03-02	Others	N/A	Invitation for Career Guidance on MArch 18, 2026	\N	26030202	For Appropriate Action	\N	Extension/Research	\N	Attended	\N	Completed	\N	2026-07-06 15:21:37.838108	\N	\N	Inbound	\N	\N	Gunday to serve as Guest Speaker for Career Guidance
69	Communication	2026-03-06	Others	Unified TVET of the Philippines	3rd Visayas TVET Conference	\N	26030601	For Information	\N	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:37.8457	\N	\N	Inbound	\N	\N	\N
73	Memorandum	2026-03-25	Regional Office	\N	Appropriate Captions for Photo Images in After Activity Report for Clearer Context and Better Understanding	\N	26032501	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.853742	\N	\N	Inbound	\N	\N	PMC Salazar, Gomez & Pechon to take note of the recommendation
77	Memorandum	2026-03-25	Others	Administrative Service	Earth Hour 2026	\N	26032505	For Appropriate Action	\N	Administrative	\N	Posted to GC	\N	Completed	\N	2026-07-06 15:21:37.862572	\N	\N	Inbound	\N	\N	Salazar to post to GC for everyone's awareness
81	Memorandum	2026-04-06	Others	Administration and Innovation	Suspension of the Submission of the Fiscal Year 2025 Agency Procurement Compliance and Performance Indicator Results	\N	26040601	For File	\N	Administrative	\N	On file.	\N	Completed	\N	2026-07-06 15:21:37.870457	\N	\N	Inbound	\N	\N	\N
85	Memorandum	2026-04-20	Regional Office	\N	Submission of Green TVET Action Plan	\N	26042003	For Appropriate Action	\N	Extension/Research	\N	Submitted to PO on April 23, 2026	\N	Completed	\N	2026-07-06 15:21:37.877965	\N	\N	Inbound	\N	\N	Gunday to submit Green TVET Action Plan
89	Memorandum	2026-04-29	Others	ROMO	Reiteration of Duties in Preventing and Addressing Sexual Harassment in TTIs	\N	26042901	For Information	\N	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:37.88569	\N	\N	Inbound	\N	\N	\N
93	Office Order	2026-04-30	Provincial Office	\N	Designation of Facilitators for the Conduct of Calibration and Assessor's Moderation	\N	26043003	For Guidance	\N	Administrative	\N	called Leo, and prepared letter Request for replacement from sir Gundat to Pechon	\N	Completed	\N	2026-07-06 15:21:37.891594	\N	\N	Inbound	\N	\N	Pechon as replacement participant
97	Office Order	2026-05-13	Provincial Office	\N	Authority to attend the Assessor's Calibration	\N	26051301	For Guidance	\N	Administrative	\N	Mr. Suarez will attend and Mr. Gunday is conflict of Schedule	\N	Completed	\N	2026-07-06 15:21:37.898661	\N	\N	Inbound	\N	\N	attention to all concerned
101	Memorandum	2026-06-01	Central Office	\N	Call for Nominations to the Technical Training on ''From Creation to Disposal: Practical Records Management for LGU's and NGA's	\N	26060101	For Appropriate Action	\N	Administrative	\N	This is unnecessary	\N	Completed	\N	2026-07-06 15:21:37.905867	\N	\N	Inbound	\N	\N	\N
105	Memorandum	2026-06-02	Regional Office	\N	Participation in the TESDA Knowledge Management Portal Scoping Questionnaire	\N	26060204	For Information	\N	Administrative	\N	done already	\N	Completed	\N	2026-07-06 15:21:37.913424	\N	\N	Inbound	\N	\N	Done already
109	Memorandum	2026-06-03	Provincial Office	\N	Submission of Nominees for the 2025 Regional TESDA Model Employee of the Year Awards (TMEOYA)	\N	26060301	For Appropriate Action	\N	Administrative	\N	Noted already informed Mr. Pechon	\N	Completed	\N	2026-07-06 15:21:37.921784	\N	\N	Inbound	\N	\N	Pechon will be nominated from this
113	Office Order	2026-06-04	Provincial Office	\N	Attendance the 2nd Quarter Provincial Technical Education and Skills Development Committee (PTESDC) MeetingC	\N	26060401	For Reference	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.929022	\N	\N	Inbound	\N	\N	\N
117	Memorandum	2026-06-15	Regional Office	\N	Authority to attend the virtual Orientation on the CLGE Management Information System (CLGE MIS) and CTEC Information System (CTEC IS)	\N	26061501	For Guidance	\N	Administrative	\N	We will attend this Virtual	\N	Completed	\N	2026-07-06 15:21:37.936091	\N	\N	Inbound	\N	\N	Mr. Pechon and Ms. CadeliÃ±a will attend
121	Advisory	2026-06-15	Central Office	\N	Deferment of the Distribution of Competency Assessment Tools (CATs) Volume 46 via Intranet	\N	26061505	For Information	\N	Administrative	\N	No files yet in the Intranet	\N	Completed	\N	2026-07-06 15:21:37.943263	\N	\N	Inbound	\N	\N	Try to access the Intranet and download for reference purposes
125	Advisory	2025-08-22	Central Office	\N	TOP/MRTOP Technical Support Advisory	\N	25082201	For Information	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.950056	\N	\N	Inbound	\N	\N	\N
129	Memorandum	2025-09-04	Jagna LGU	\N	Memorandum Order Nos. 002-006 2025	\N	25090403	For Information	\N	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:37.957517	\N	\N	Inbound	\N	\N	\N
133	Memorandum	2025-09-12	Central Office	\N	Call for Nomination and Registration to the TVET Excellence: Mastering Technology Research Training Program	https://bit.ly/TVETExcellence2025	25091204	For File	\N	Administrative	\N	Already accomplished.	\N	Completed	\N	2026-07-06 15:21:37.964898	\N	\N	Inbound	\N	\N	Accomplished
137	Communication	2025-09-19	Jagna LGU	\N	International Coastal Clean-up 2025	\N	25091901	For Information	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.971984	\N	\N	Inbound	\N	\N	All staff to join the clean-up on Sept. 20, 2025 at 6:00 am
141	Memorandum	2025-09-25	Central Office	\N	Nomination to the Technology Transfer Training on Adobe....	\N	25092501	For Nomination	\N	Administrative	\N	Nomination Form sent to email provided	\N	Completed	\N	2026-07-06 15:21:37.978985	\N	\N	Inbound	\N	\N	Lozada and Pechon were nominated
145	Advisory	2025-09-30	Provincial Office	\N	Attendance to Virtual Training's Provider's Meeting	https://meet.ggogle.com/qky-jvib-ftj	25093001	For Information	\N	Administrative	\N	Already on file	\N	Completed	\N	2026-07-06 15:21:37.986427	\N	\N	Inbound	\N	\N	Sir Inar will attend on this meeting
142	Memorandum	2025-09-29	Central Office	\N	Guidelines for the 2025 Loyalty Award	\N	25092901	For Appropriate Action	\N	Administrative	\N	Posted to GC	\N	Completed	\N	2026-07-06 15:21:37.98081	\N	\N	Inbound	\N	\N	Abacial to download and post the Memo on the GC for information
146	Office Order	2025-10-02	Regional Office	\N	Amendment & Addendum to Office Order No. 0194, Physical Count of PPE for PTCs, etc.	\N	25100201	For Information	\N	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:37.988098	\N	\N	Inbound	\N	\N	\N
150	TESDA Order	2025-10-02	Central Office	\N	Attendance of TESDA Personnel to the Technology Research Forum back-to-back w/ 2025 International Roadshow	\N	25100205	For Dissemination	\N	Training	\N	Attended	\N	Completed	\N	2026-07-06 15:21:37.995389	\N	\N	Inbound	\N	\N	\N
154	Memorandum	2025-10-07	Central Office	\N	Request for Nomination of Participants to the SIPTVETS Project Workshop on Gender Equality, Environment & Social Safeguards	\N	25100701	For Nomination	\N	Administrative	\N	Nomination Form sent to RO for RDs approval	\N	Completed	\N	2026-07-06 15:21:38.00214	\N	\N	Inbound	\N	\N	MLO Caido and JKT Gunday were nominated
158	Memorandum	2025-10-14	Central Office	\N	Official Name Style for the Secretary	\N	25101402	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.008955	\N	\N	Inbound	\N	\N	Caido- Pls. ensure all docs. are all in accordance to this memo.
162	Office Order	2025-10-17	Provincial Office	\N	Attendance to the Re-Echo on the YAKAP Program of PhilHealth	\N	25101701	For Information	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.015779	\N	\N	Inbound	\N	\N	All regular staff to attend
166	Communication	2025-10-28	Provincial Office	\N	CPG Local & Overseas Job Fair	\N	25102801	For Dissemination	\N	Training	\N	Sent communication to trainers	\N	Completed	\N	2026-07-06 15:21:38.022869	\N	\N	Inbound	\N	\N	Trainers to contact graduates and share the QR Code for registration
170	Others	2025-11-05	Central Office	\N	Request to fill-out the hotel Canvass form	\N	25110502	Others	N/A	Administrative	\N	Forwarded to PO	\N	Completed	\N	2026-07-06 15:21:38.029949	\N	\N	Inbound	N/A	\N	Already forwarded to PO
174	Memorandum	2025-11-07	Central Office	\N	Guidelines on Trainings, Briefings, and Workshops per COA Circular No. 2025-003	\N	25110703	For File	\N	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:38.0375	\N	\N	Inbound	\N	\N	Put on file for future reference
178	Office Order	2025-11-12	Regional Office	\N	Authority to attend the Presentation of Granularized ABDD Skills priorities by Wadhwan Foundation	\N	25111201	For Appropriate Action	\N	Administrative	\N	Attended.	\N	Completed	\N	2026-07-06 15:21:38.044222	\N	\N	Inbound	\N	\N	Sir Inar will attend on this meeting via Zoom on Nov, 12, 2025
182	Memorandum	2025-11-13	Others	Policies and Training	Requesting COROPOTIs to provide inputs into and update entries in the TVET Research Monitoring Database	bit.ly/ResearchInitiatives	25111302	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.052082	\N	\N	Inbound	\N	\N	All trainers to submit your technology reasearch through the link
186	TESDA Order	2025-11-18	Central Office	\N	Regional Lead Trainers Development for Web Technologies (Web Design NC III, Web Development (Front-End) NC III, and Web Development (Back-End) NC III	\N	25111803	For Information	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.059652	\N	\N	Inbound	\N	\N	Lozada to Attend the Training
190	Communication	2025-11-20	Jagna LGU	\N	KALAHI- CIDSS Exit Conference cum MCC Meeting	\N	25112001	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.067504	\N	\N	Inbound	\N	\N	Pechon to attend on this meeting on Nov. 21, 2025
194	Memorandum	2025-12-03	Others	ICTO	Request for the Participation of TESDA Learners and Personnel in the Key Informant Interview for the Evaluation of the TESDA Online Program	\N	25120301	For Appropriate Action	\N	Administrative	\N	Attended by Sir Inar, Chester and two trainees	\N	Completed	\N	2026-07-06 15:21:38.075477	\N	\N	Inbound	\N	\N	\N
198	Advisory	2025-12-10	Others	NTTA	Virtual Orientation and Training on the Khan Academy (KA) Teacher Dashboard	\N	25121001	For Information	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.08263	\N	\N	Inbound	\N	\N	For all trainers
202	Office Order	2025-12-12	Regional Office	\N	Designation of RO Representative in the conduct of Ocular Inspection	\N	25121202	For Information	\N	Training	\N	Represented and conducted	\N	Completed	\N	2026-07-06 15:21:38.089416	\N	\N	Inbound	\N	\N	For Suarez
206	Advisory	2025-12-15	Provincial Office	\N	Recommended Program for the Conduct of Graduation Ceremony	\N	25121503	For Guidance	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.096032	\N	\N	Inbound	\N	\N	For guidance of Trainers
210	Communication	2025-12-23	Jagna LGU	\N	Rizal Day Celebration	\N	25122301	For Appropriate Action	\N	Administrative	\N	Attended	\N	Completed	\N	2026-07-06 15:21:38.102859	\N	\N	Inbound	\N	\N	Sir Inar and Ma'am Leil attended
147	Advisory	2025-10-02	Regional Office	\N	Cebu Earthquake Fund Drive	\N	25100202	For Appropriate Action	\N	Administrative	\N	Collected and sent to PO (Sir Leo)	\N	Completed	\N	2026-07-06 15:21:37.989692	\N	\N	Inbound	\N	\N	Collect money donation to all staff
151	Memorandum	2025-10-03	Central Office	\N	Request for Nomination of Master's Degree Program for TESDA Trainers & Administrators	\N	25100301	For Nomination	\N	Administrative	\N	Nomination Form sent to email provided	\N	Completed	\N	2026-07-06 15:21:37.996975	\N	\N	Inbound	\N	\N	AP CadeliÃ±a, Pechon & Gunday are nominated
155	Memorandum	2025-10-07	Central Office	\N	Mobilization of TTI to Provide Necessary Support for the EBET Program Registration	\N	25100702	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.003893	\N	\N	Inbound	\N	\N	Pechon to provide assistance to BOHECO II to register to EBET Program
159	Memorandum	2025-10-14	Regional Office	\N	Submission of the 3rd Quarter RRRO for CY 2025	\N	25101403	For Appropriate Action	\N	Administrative	\N	Submitted before deadline.	\N	Completed	\N	2026-07-06 15:21:38.010926	\N	\N	Inbound	\N	\N	Lozada to submit on time
163	Memorandum	2025-10-20	Central Office	\N	Proclamation No. 1006, Declaring the Regular Holidays & Special Non-Working Days for the Yr 2026	\N	25102001	For Information	\N	Administrative	\N	Post on GC	\N	Completed	\N	2026-07-06 15:21:38.017686	\N	\N	Inbound	\N	\N	\N
167	Office Order	2025-10-29	Provincial Office	\N	Authority to Attend the TESDA Bohol Industry Forum 2025	\N	25102901	For Information	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.024435	\N	\N	Inbound	\N	\N	Sir Inar, Lozada and Suarez will attend the forum on Nov. 5, 2025
171	Office Order	2025-11-05	Provincial Office	\N	Authority to Attend the Multiplier Training on Community Program Development Services	\N	25110503	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.031517	\N	\N	Inbound	\N	\N	Pechon to attend as ordered
175	Memorandum	2025-11-07	Central Office	\N	Future Port Youth Conference	\N	25110704	For Appropriate Action	\N	Administrative	\N	We will not send Participants	\N	Completed	\N	2026-07-06 15:21:38.03927	\N	\N	Inbound	\N	\N	\N
179	TESDA Circular	2025-11-12	Central Office	\N	Omnibus Guidelines for the Implementation of FY 2025 TESDA Scholarship Programs	\N	25111202	For Reference	\N	Administrative	\N	Copies provided	\N	Completed	\N	2026-07-06 15:21:38.046832	\N	\N	Inbound	\N	\N	Caido, Lozada & Pechon to secure own copies
183	Memorandum	2025-11-13	Regional Office	\N	TESDA VIIs Observance of the 18-Day Campaign to End VAWC on Nov. 25 to Dec. 12, 2025	\N	25111303	For Appropriate Action	\N	Administrative	\N	Noted. Activities prepared and posted to GC and Bulletin Board	\N	Completed	\N	2026-07-06 15:21:38.053617	\N	\N	Inbound	\N	\N	Caido to plan activities on this campaign
187	Memorandum	2025-11-19	Others	ROMO	Request for Nomination of Training of Trainers Workshop on "Artificial Intelligence for Digital Novice MSMEs" under Digital-PINAS	\N	25111901	For Nomination	\N	Administrative	\N	Nomination prepared and emailed by Salazar	\N	Completed	\N	2026-07-06 15:21:38.061728	\N	\N	Inbound	\N	\N	Caido to facilitate submission of nomination- Gunday and Pechon
191	Communication	2025-11-20	Others	T-Monte Integrated School	Invitation to Serve as Resource Speaker for Career Guidance Program	\N	25112002	For Appropriate Action	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.06986	\N	\N	Inbound	\N	\N	Caido as resource speaker since Gunday is on official travel at Cebu
195	Memorandum	2025-12-04	Provincial Office	\N	Conduct of Community-Based Trainers Methodology Course	\N	25120401	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.077552	\N	\N	Inbound	\N	\N	Magadan to prepare Course Design for the Training
199	Office Order	2025-12-10	Provincial Office	\N	Conduct of Ocular Inspection to Applicant TVIs for Mobile Training Program under UTPRAS	\N	25121002	For Guidance	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.08456	\N	\N	Inbound	\N	\N	Gunday-for guidance
203	Advisory	2025-12-12	Provincial Office	\N	2025 Year-End Performance Assessment (YEPA)	\N	25121203	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.091007	\N	\N	Inbound	\N	\N	Gunday to prepare presentation
207	Memorandum	2025-12-16	Central Office	\N	Submission of 2025 TTIs Reports and Deliverables	\N	25121601	For Appropriate Action	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.097741	\N	\N	Inbound	\N	\N	NiÃ±o to prepare IDP and Chester for Absorptive Capacity and Training Calendar
148	Memorandum	2025-10-02	Central Office	\N	Request for Comments/Additional Inputs and Recommendations on the Draft IGs for the conduct of Tagsanay Award	\N	25100203	For File	\N	Administrative	\N	Already on file	\N	Completed	\N	2026-07-06 15:21:37.991421	\N	\N	Inbound	\N	\N	No Comment
152	Communication	2025-10-03	Mabini LGU	\N	List of Trainees in Hilot Wellness Massage Training- CBTP	\N	25100302	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:37.998517	\N	\N	Inbound	\N	\N	Pechon to communicate with RL Madera regarding the training
156	Memorandum	2025-10-07	Central Office	\N	Hiring of GIP Intern for FY 2026	\N	25100703	For Appropriate Action	\N	Administrative	\N	Google sheet filled-up for proposal	\N	Completed	\N	2026-07-06 15:21:38.005452	\N	\N	Inbound	\N	\N	To submit proposal
160	Memorandum	2025-10-14	Central Office	\N	Memo 434- Nomination to the SCP Course on Industry 4.0 & the Future of AI & Big Data Analytics	\N	25101404	For Nomination	\N	Administrative	\N	Filed.	\N	Completed	\N	2026-07-06 15:21:38.01252	\N	\N	Inbound	\N	\N	No Qualified
164	Advisory	2025-10-21	Provincial Office	\N	Conduct of Industry Forum for TVET Partners	\N	25102101	For Appropriate Action	\N	Training	\N	\N	\N	Completed	\N	2026-07-06 15:21:38.01965	\N	\N	Inbound	\N	\N	Pechon to make a communication and invite industry partner in EIM and SMAW
168	Memorandum	2025-10-29	Central Office	\N	CSC eService Online Application for 8 March 2026 CSE	\N	25102902	For Information	\N	Administrative	\N	Informed Yeth & Dan	\N	Completed	\N	2026-07-06 15:21:38.026504	\N	\N	Inbound	\N	\N	Inform JOs
172	Memorandum	2025-11-07	Central Office	\N	Request for the List of Participants in the Conduct of CBP on Strengthening Quality Assurance Practices through QMS for TESDA STAR	\N	25110701	For Appropriate Action	\N	Administrative	\N	Posted to GC by Sir Inar	\N	Completed	\N	2026-07-06 15:21:38.03318	\N	\N	Inbound	\N	\N	\N
176	Communication	2025-11-10	Provincial Office	\N	Request for Resource Speaker	\N	25111001	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.040737	\N	\N	Inbound	\N	\N	Suarez to facilitate as resource speaker for DAR personnel as requested
180	Others	2025-11-12	Others	SIPTVETS PMU	Notice of Meeting Agenda: ACMI Presentation of Delivery Plan & Schedule, etc.	\N	25111203	For Appropriate Action	\N	Training	\N	Attended.	\N	Completed	\N	2026-07-06 15:21:38.048743	\N	\N	Inbound	N/A	\N	Gunday to attend on this meeting
184	Memorandum	2025-11-18	Regional Office	\N	Invitation from Visayas TVET Association on the Conduct of E-Commerce Operations Level III Training Workshop	\N	25111801	For File	\N	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:38.055459	\N	\N	Inbound	\N	\N	\N
188	Memorandum	2025-11-19	Central Office	\N	Internal Beta Testing for TESDA Best Skills Passport Application	\N	25111902	For Appropriate Action	\N	Training	\N	Informed trainers and provided link	\N	Completed	\N	2026-07-06 15:21:38.063569	\N	\N	Inbound	\N	\N	Caido to facilitate the testing to our trainees and staff
192	Office Order	2025-11-25	Provincial Office	\N	Inspection to 2024 STEP Toolkits	\N	25112501	For Appropriate Action	\N	Training	\N	Inspected	\N	Completed	\N	2026-07-06 15:21:38.071757	\N	\N	Inbound	\N	\N	RD Suarez
196	Advisory	2025-12-04	Others	PMO	Advisory on the Coduct of Key Informant Interview for the TESDA Online Program Evaluation	\N	25120402	For Appropriate Action	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.079345	\N	\N	Inbound	\N	\N	Glenn and Roldan to orient their trainees for possible questions
200	Communication	2025-12-10	Others	BLECTEC President	Attendance to 4th Quarter BLECTEC, Inc. Meeting	\N	25121003	For Guidance	\N	Administrative	\N	Attended	\N	Completed	\N	2026-07-06 15:21:38.086404	\N	\N	Inbound	\N	\N	Pechon and Sir Inar will attend.
204	Memorandum	2025-12-15	Provincial Office	\N	Schedule of Ocular Inspection	\N	25121501	For Appropriate Action	\N	Administrative	\N	Facilitated.	\N	Completed	\N	2026-07-06 15:21:38.092719	\N	\N	Inbound	\N	\N	Caido to facilitate inspection process
208	Memorandum	2025-12-18	Regional Office	\N	Medical/Health Card Allocation from the Collective Negotiation Agreement (CNA) Incentive	\N	25121801	For Information	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.099355	\N	\N	Inbound	\N	\N	For Information to All Regulars
149	Memorandum	2025-10-02	Central Office	\N	Request for Nomination on the Conduct of the Regional Lead Trainers Devt. Program on Web Technologies	\N	25100204	For Nomination	\N	Administrative	\N	Already on file	\N	Completed	\N	2026-07-06 15:21:37.993609	\N	\N	Inbound	\N	\N	No Qualified
153	Office Order	2025-09-29	Provincial Office	\N	Authority to Attend the 3rd Quarter BLECTEC Meeting	\N	25092904	For Information	\N	Training	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.000034	\N	\N	Inbound	\N	\N	Pechon will attend the meeting
157	Memorandum	2025-10-14	Central Office	\N	Official Name Style for the Secretary	\N	25101401	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.007197	\N	\N	Inbound	\N	\N	Caido- Pls. ensure all docs. are all in accordance to this memo.
161	TESDA Order	2025-10-16	Central Office	\N	TESDA Order 695: Designation of TESDA Officials & Personnel on the Compliance w/ the Data Privacy Act	\N	25101601	For Information	\N	Administrative	\N	Posted to GC.	\N	Completed	\N	2026-07-06 15:21:38.014108	\N	\N	Inbound	\N	\N	Caido- Pls. post on GC
165	Memorandum	2025-10-27	Central Office	\N	JDS Phils. Promotional Seminar	bit.ly/JDS2025Seminar	25102701	For Information	\N	Administrative	\N	Sir Inar will attend	\N	Completed	\N	2026-07-06 15:21:38.021354	\N	\N	Inbound	\N	\N	Seminar on Nov. 12 9:30 to 11:00am via zoom
169	Others	2025-11-05	Central Office	\N	Request for Venue or Certification of Non-Availability of Venue	\N	25110501	For Appropriate Action	\N	Administrative	\N	Certification done and sent to PMO	\N	Completed	\N	2026-07-06 15:21:38.028318	\N	\N	Inbound	N/A	\N	Salazar to create a certification
173	Memorandum	2025-11-07	Central Office	\N	Conduct of Comprehensive Inventory of Computer Systems and Network Assessment	\N	25110702	For Appropriate Action	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.035343	\N	\N	Inbound	\N	\N	Lozada to assist ICTO personnel on Nov. 17, 2025
177	Office Order	2025-11-11	Regional Office	\N	Authority to attend the 2nd Semester 2025 Regional Quality Management Committee (RQMC) cum Management Committee (ManCom)Meeting	\N	25111101	For Dissemination	\N	Administrative	\N	On file	\N	Completed	\N	2026-07-06 15:21:38.042392	\N	\N	Inbound	\N	\N	\N
181	Memorandum	2025-11-13	Others	ICTO	Request to Participate in the Evaluation of the TESDA Online Program and Nomination of Participants to the Key Informant Interview (KII)	\N	25111301	For Appropriate Action	\N	Administrative	\N	Submitted	\N	Completed	\N	2026-07-06 15:21:38.050148	\N	\N	Inbound	\N	\N	Caido and Lozada to facilitate survey for learners
185	Memorandum	2025-11-18	Central Office	\N	Memo Circular No. 105, Directing All Government Agencies to Support the Observance of the 2025 Drug Abuse Prevention and Control Week	\N	25111802	For Appropriate Action	\N	Administrative	\N	Activity to be conducted on Nov. 25, Film Showing & Talk about Mental Health	\N	Completed	\N	2026-07-06 15:21:38.057357	\N	\N	Inbound	\N	\N	Caido to organize activity regarding the subjuct
189	Memorandum	2025-11-19	Others	ROMO	Request for Nomination of TESDFA Technology Trainers to the Khan Academy (KA) Orientation and Training on KA Teacher Dashboard	\N	25111903	For Nomination	\N	Administrative	\N	Nominees: Suarez, Gunday, Pechon, Madera and Magadan. Nomination Form sent	\N	Completed	\N	2026-07-06 15:21:38.065342	\N	\N	Inbound	\N	\N	Caido to facilitate nomination
193	Memorandum	2025-11-28	Others	PMO	Request of Physical and Financial Performance Report	\N	25112801	For Appropriate Action	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.073592	\N	\N	Inbound	\N	\N	Gunday and Abacial to Prepare the document requested
197	Communication	2025-12-09	Others	PTESDC Bohol	Notice of Meeting: Provincial TESD Committee Meeting	\N	25120901	For Appropriate Action	\N	Training	\N	Sir NiÃ±o will attend on behalf of Sir Inar who is currently on sick leave	\N	Completed	\N	2026-07-06 15:21:38.080852	\N	\N	Inbound	\N	\N	Sir NiÃ±o will attend
201	Office Order	2025-12-12	Provincial Office	\N	Authority to Attend 2025 Year-End Performance Assessment (YEPA)	\N	25121201	For Information	\N	Administrative	\N	Will attend	\N	Completed	\N	2026-07-06 15:21:38.087906	\N	\N	Inbound	\N	\N	All regular staff to attend on this activity
205	Communication	2025-12-15	Jagna LGU	\N	YEar End Assessment of LGU-Jagna	\N	25121502	For Guidance	\N	Administrative	\N	Noted	\N	Completed	\N	2026-07-06 15:21:38.094486	\N	\N	Inbound	\N	\N	Caido and JOs to attend on this activity
209	Communication	2025-12-19	Others	Lonoy Heroes Memorial High School	Invitation to Serve as Resource Speaker at the Career Guidance Symposium and Culmination	\N	25121901	For Appropriate Action	\N	Extension/Research	\N	Attended	\N	Completed	\N	2026-07-06 15:21:38.101117	\N	\N	Inbound	\N	\N	Gunday served as the Resource Speaker
\.


--
-- Data for Name: dts_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dts_history (unique_id, route_number, user_name, action_provided, status, date_updated, forwarded_to, resp_unit, ip_address, "timestamp", date_received, origin, other_office, doc_type, subject, doc_link, action_needed, action_part, responsible_person, classification, doc_type_part, forwarded_to_part, action_particulars) FROM stdin;
1	26010501	test	Sent via LBC Express address to PMO on Jan. 26, 2026	Completed	2026-07-06 15:19:36.233702	\N	Extension/Research	127.0.0.1	2026-07-06 15:19:36.235715+08	2026-01-05	Central Office	\N	Memorandum	Conduct of Inspection of Multimedia Development Equipment and Creative Cloud Software for 17 Innovation Centers & eTESDA PMO	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Gunday to submit to PMO the required documents
2	26010502	test	Noted	Completed	2026-07-06 15:19:36.239041	\N	Administrative	127.0.0.1	2026-07-06 15:19:36.239226+08	2026-01-05	Central Office	\N	TESDA Circular	Promulgated Assessment Fees During the 148th TESDA Meeting	\N	For Information	\N	\N	Inbound	\N	\N	Lozada to be informed of this new promulgated Assessment Fees
3	26010601	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.719047	\N	Training	127.0.0.1	2026-07-06 15:21:37.72026+08	2026-01-06	Provincial Office	\N	Advisory	Attendance to Trainer's Moderation Program	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	All Trainers are required to attend
4	26010602	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.724561	\N	Training	127.0.0.1	2026-07-06 15:21:37.724881+08	2026-01-06	Provincial Office	\N	Office Order	Amendment re: Composition of Bid and Awards Committee (BAC) and Designation of OU	\N	For Guidance	\N	\N	Inbound	\N	\N	Lozada, Suarez, Pechon and Gunday as members of BAC, to be informed
5	26010603	Portal Administrator	Posted to GC.	Completed	2026-07-06 15:21:37.727884	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.728179+08	2026-01-06	Provincial Office	\N	Advisory	Agreement during the APTIB Year-End Fellowship	\N	For Information	\N	\N	Inbound	\N	\N	For Information, Salazar to post to GC
6	26010604	Portal Administrator	Noted.	Completed	2026-07-06 15:21:37.730325	\N	Training	127.0.0.1	2026-07-06 15:21:37.73057+08	2026-01-06	Others	BLECTEC President	Communication	Attendance to 1st Quarter BLECTEC, Inc. Meeting	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Pechon to encourage all CTECs of our STAR to attend.
7	26010801	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.732404	\N	Training	127.0.0.1	2026-07-06 15:21:37.732613+08	2026-01-08	Provincial Office	\N	Advisory	Additional Instruction/ Reminders in the Conduct of Trainers Moderation on Jan. 15-16, 2026	\N	For Guidance	\N	\N	Inbound	\N	\N	All trainers to be guided of all requirements for the trainer's moderation
8	26010802	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.734147	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.734405+08	2026-01-08	Provincial Office	\N	Memorandum	Use of TESDA Bohol Provincial Office Subscribed Zoom Account	\N	For Information	\N	\N	Inbound	\N	\N	Lozada to take note of the Zoom Account for future use of Online Activities
9	26010803	Portal Administrator	Noted. Template already downloaded.	Completed	2026-07-06 15:21:37.736099	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.736357+08	2026-01-08	Others	Administrative Service	Memorandum	Dissemination of the Updated Contract of Service	\N	For Guidance	\N	\N	Inbound	\N	\N	Caido to be guided on the new COS Template
10	26010804	Portal Administrator	Survey is not applicable to our institution	Completed	2026-07-06 15:21:37.737788	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.737985+08	2026-01-08	Others	ROMO	Memorandum	Participation in the Agricultural Innovation Ecosystem Survey (SEEDS PROJECT)	\N	Others	N/A	\N	Inbound	\N	\N	Survey is not applicable to our institution
11	26010805	Portal Administrator	Done fill-up.	Completed	2026-07-06 15:21:37.739373	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.739585+08	2026-01-08	Others	ROMO	Memorandum	Survey on the Readiness of TTIs in Implementing TVET Educators Development Programs	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Lozada to fill up the survey
12	26010806	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.74109	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.741294+08	2026-01-08	Provincial Office	\N	Office Order	Attendance to Management Committee Meeting	\N	For Guidance	\N	\N	Inbound	\N	\N	Caido to update OPCR Accomplishment 2025
13	26010807	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.742927	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.743181+08	2026-01-08	Regional Office	\N	Memorandum	Submission of Documents	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	All regular staff to be guided on the submission timeline.
14	26010901	Portal Administrator	On file	Completed	2026-07-06 15:21:37.744855	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.745081+08	2026-01-09	Others	Financial and Management Services	Memorandum	Submission of FY 2027 Budget Proposal	\N	Others	N/A	\N	Inbound	\N	\N	We will not submit.
15	26010902	Portal Administrator	Noted.	Completed	2026-07-06 15:21:37.746479	\N	Training	127.0.0.1	2026-07-06 15:21:37.746687+08	2026-01-09	Others	Administration and Innovation	Memorandum	Registration to the Career Service Examination Review	\N	For Information	\N	\N	Inbound	\N	\N	RL MAdera to register if interested
16	26010903	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.748064	\N	Training	127.0.0.1	2026-07-06 15:21:37.748275+08	2026-01-09	Others	PTC-Inabanga	Memorandum	Benchmarking Activity of PTC-Inabanga Trainers	\N	For Information	\N	\N	Inbound	\N	\N	All trainers to prepare their areas
17	26011301	Portal Administrator	On file	Completed	2026-07-06 15:21:37.74958	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.749807+08	2026-01-13	Others	Policies and Planning Office	Memorandum	Request for Comments to the Proposed Enhanced IGs for the Recognition of Prior Learning in TVET	\N	For File	\N	\N	Inbound	\N	\N	No Comments
18	26011302	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.751711	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.751976+08	2026-01-13	Others	Administration and Innovation	Memorandum	Conduct of TNA for CY 2026-2028	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Caido to facilitate submission of TNAs
19	26011303	Portal Administrator	Attended.	Completed	2026-07-06 15:21:37.753646	\N	Training	127.0.0.1	2026-07-06 15:21:37.753857+08	2026-01-13	Others	PMO	Memorandum	Request for Technical Assistance on Industry Consultation	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Pechon & Gunday to serve as technical experts
20	26011304	Portal Administrator	Posted to GC	Completed	2026-07-06 15:21:37.75529	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.755503+08	2026-01-13	Provincial Office	\N	Office Order	Authority to Act as TESDA Rep during the Conduct of Competency Assessment and Certification	\N	For Information	\N	\N	Inbound	\N	\N	Salazar to post to GC for everyone's awareness
21	26011401	Portal Administrator	On file	Completed	2026-07-06 15:21:37.75689	\N	Training	127.0.0.1	2026-07-06 15:21:37.757098+08	2026-01-14	Regional Office	\N	Office Order	Attendance to the ASSIST Project SustainABILITY- NextGen Workforce 2.0 Project Launch on January 16, 2026	\N	For Information	\N	\N	Inbound	\N	\N	Conflict to the schedule of Trainer's Moderation
22	26012101	Portal Administrator	Posted to GC	Completed	2026-07-06 15:21:37.758608	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.758921+08	2026-01-21	Jagna LGU	\N	Communication	Schedule of Offices to Lead the Zumba	\N	For Information	\N	\N	Inbound	\N	\N	Caido to plan & lead the zumba
23	26012102	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.760784	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.761011+08	2026-01-21	Others	PMO	Communication	Notice of Meeting for SIPTVETS-RTIC Beneficiaries	\N	For Information	\N	\N	Inbound	\N	\N	Sir Inar will attend
24	26012201	Portal Administrator	Nomination Form sent to RO for RDs approval	Completed	2026-07-06 15:21:37.762473	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.762675+08	2026-01-22	Others	ROMO	Memorandum	Request for Nomination on the National TVET Educators Development Programs	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Ma'am Caido to send nomination
25	26012301	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.764013	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.764218+08	2026-01-23	Others	San Roque National High School	Communication	Request for Resource Speaker in Career Guidance of Grade 10 and 12 learners on February 3, 2026	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	MLO Caido will attend in behalf of JKT Gunday
129	25090403	Portal Administrator	On file	Completed	2026-07-06 15:21:37.957952	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.958167+08	2025-09-04	Jagna LGU	\N	Memorandum	Memorandum Order Nos. 002-006 2025	\N	For Information	\N	\N	Inbound	\N	\N	\N
26	26012202	Portal Administrator	Attended	Completed	2026-07-06 15:21:37.765579	\N	Training	127.0.0.1	2026-07-06 15:21:37.765796+08	2026-01-22	Provincial Office	\N	Office Order	Authority to Attend Meeting for the Preparation of Supplemental Requirements of the ECCDS NC III	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Gomez and Pechon to attend the meeting
30	26012703	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.775323	\N	Training	127.0.0.1	2026-07-06 15:21:37.775646+08	2026-01-27	Lila LGU	\N	Communication	Request for Resource Speaker for Career Guidance of Grade 10 & 12 learners of Lila National High School on February 12, 2026	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	JKT Gunday will serve as speaker
34	26020201	Portal Administrator	On file	Completed	2026-07-06 15:21:37.782921	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.783163+08	2026-02-02	Others	ROMO	Memorandum	Submission of Documentary Reports on Donations Provided by Private Partners to the TTIs	\N	For File	\N	\N	Inbound	\N	\N	We have no donations provided by Private Partners
38	26020502	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.789775	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.789995+08	2026-02-05	Provincial Office	\N	Advisory	Full Cooperation in the Conduct of an Applied Research on a Web-Based...	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Lozada to provide assistance to Mr. Nazareno
42	26021001	Portal Administrator	Magadan & Abacial wasn't able to attend due to conflict in assessment schedule	Completed	2026-07-06 15:21:37.796861	\N	Training	127.0.0.1	2026-07-06 15:21:37.797067+08	2026-02-10	Others	BOHECO II	Communication	Request for Resource Speaker for Safety & Electrical Procedures & Basic Bookkeeping	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Magadan & Abacial as speakers on the said topics
46	26021302	Portal Administrator	On file	Completed	2026-07-06 15:21:37.803557	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.803773+08	2026-02-13	Others	Policies and Planning Office	Memorandum	Validation and Submission of Inputs to the TESDA FY GAD AR and FY 2026 GAD Plan and Budget	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Caido to take action on this matter
50	26021902	Portal Administrator	Attended	Completed	2026-07-06 15:21:37.810955	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.811169+08	2026-02-19	Provincial Office	\N	Office Order	Attendance to the Pre-Planning Workshop Conference	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Caido and Sir Inar attended
54	26022401	Portal Administrator	Sir Inar didn't able to attend due to virtual meeting	Completed	2026-07-06 15:21:37.817608	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.817852+08	2026-02-24	Jagna LGU	\N	Communication	ESWM Board Meeting	\N	For Information	\N	\N	Inbound	\N	\N	\N
58	26022601	Portal Administrator	On file	Completed	2026-07-06 15:21:37.824388	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.824601+08	2026-02-26	Others	Policies and Planning Office	Memorandum	Conduct of the 1st Survey Round for the 2026 User's Feedback Survey on the Policy Issuances of TESDA	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Sir Inar is already done with the survey
62	26032701	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.833018	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.833223+08	2026-03-27	Provincial Office	\N	Advisory	Attendance to APTIB Inc. General Assembly	\N	For Guidance	\N	\N	Inbound	\N	\N	Sir Inar will attend on this meeting on March 6, 2026 at Reyna's
66	26030302	Portal Administrator	Attended by Caido	Completed	2026-07-06 15:21:37.840132	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.840348+08	2026-03-03	Others	Qualifications and Standards Office	Advisory	Registration to the Deployment of Amended Omnibus Guidelines on TVET Micr-credentials and Developed National and ABDD TVET CS	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Caido will attend
70	26031001	Portal Administrator	Posted to GC for everyone's information	Completed	2026-07-06 15:21:37.848213	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.84843+08	2026-03-10	Provincial Office	\N	Advisory	Participation to the 2026 Provincial Skills Olympics	\N	For Information	\N	\N	Inbound	\N	\N	\N
74	26032502	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.855992	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.856271+08	2026-03-25	Provincial Office	\N	Office Order	Amendment to Office Order No. 016 S. of 2026 re: Working Committees in the Conduct of the 2026 Provincial Skills Olympics	\N	For Guidance	\N	\N	Inbound	\N	\N	\N
78	26032506	Portal Administrator	On file	Completed	2026-07-06 15:21:37.865189	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.865463+08	2026-03-25	Others	ROMO	Memorandum	Request for Nomination of Participants for the Conduct of various Regional Lead Trainers Development Programs	\N	For File	\N	\N	Inbound	\N	\N	Will not send participants
82	26040701	Portal Administrator	Noted.	Completed	2026-07-06 15:21:37.872402	\N	Extension/Research	127.0.0.1	2026-07-06 15:21:37.872568+08	2026-04-07	Others	PMO	Memorandum	Training Notice for G101-A: Lot 1- Supply and Delivery of Multimedia Development Equipment for 17 RTICS and eTESDA PMO	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Gunday to attend to this meeting
86	26042004	Portal Administrator	On file	Completed	2026-07-06 15:21:37.880302	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.880535+08	2026-04-20	Others	ROMO	Memorandum	Request for Nomination of Participants for the Conduct of Various Regional Lead Trainers Development Program	\N	For Nomination	\N	\N	Inbound	\N	\N	Will not send participants
90	26042801	Portal Administrator	\N	Completed	2026-07-06 15:21:37.887848	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.888021+08	2026-04-28	Central Office	\N	Memorandum	Reiteration on the proper use of TESDA Motor Vehicles	\N	For Dissemination	\N	\N	Inbound	\N	\N	\N
94	26043004	Portal Administrator	Noted.	Completed	2026-07-06 15:21:37.89418	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.894411+08	2026-04-30	Provincial Office	\N	Office Order	Authority to Attend an Exposure Training in ECCD NC III	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Attention PMC Salazar and RA Gomez
98	26051302	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.900823	\N	Training	127.0.0.1	2026-07-06 15:21:37.901086+08	2026-05-13	Provincial Office	\N	Office Order	Authority to attend the Trainer's Moderation and Assessor's Calibration Program	\N	For Guidance	\N	\N	Inbound	\N	\N	attention Mr. Pechon
102	26060201	Portal Administrator	We will not send Participants	Completed	2026-07-06 15:21:37.908189	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.908395+08	2026-06-02	Central Office	\N	Memorandum	Call for Nominations to the Technical Training on ''From Creation to Disposal: Pravtical Records Management for LGUs and NGAs''	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	we will not send Nomination
106	26060205	Portal Administrator	Noted.	Completed	2026-07-06 15:21:37.915391	\N	Training	127.0.0.1	2026-07-06 15:21:37.915601+08	2026-06-02	Central Office	\N	Memorandum	Requesting COROPOTI's to provide inputs into and update entries in the TVET Research Monitoring Database	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	attention all trainers
110	26060302	Portal Administrator	We will not send Participants	Completed	2026-07-06 15:21:37.923869	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.92407+08	2026-06-03	Central Office	\N	Memorandum	Nomination to the CPSC Collaborative Regional Program on "Future-Ready Workforce and Skills Development''	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	we will not send Nomination
114	26060801	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.930923	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.931111+08	2026-06-08	Jagna LGU	\N	Communication	Observance of the 128th Anniversary of the proclamation of Philippine Independence Day	\N	For Guidance	\N	\N	Inbound	\N	\N	Post on GC
118	26061502	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.938322	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.938554+08	2026-06-15	Regional Office	\N	Office Order	Athority to attend the 2nd Quarter RTESDC Meeting	\N	For Guidance	\N	\N	Inbound	\N	\N	Sir inar will attend
122	26061506	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.945533	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.945732+08	2026-06-15	Regional Office	\N	Memorandum	Comments on the Submitted Registry of Relevant Risk and Opportunities (RRRO) as of April 15, 2026	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Mr. Lozada Please see to it
27	26012601	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.768749	\N	Training	127.0.0.1	2026-07-06 15:21:37.769004+08	2026-01-26	Provincial Office	\N	Office Order	Working Committees in the Conduct of Closing Ceremony for Korean and Japanese Language and MOA Signing	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Lozada, Pechon & Suarez to prepare and take note of their responsibilies
31	26012704	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.777728	\N	Extension/Research	127.0.0.1	2026-07-06 15:21:37.777963+08	2026-01-27	Lila LGU	\N	Communication	Request for Resource Speaker on Career Guidance for Grades 10 & 12 learners of Holy Rosary Academy on February 5, 2026	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Sir JC will serve as speaker
35	26020301	Portal Administrator	Link posted to GC	Completed	2026-07-06 15:21:37.784975	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.785208+08	2026-02-03	Regional Office	\N	Memorandum	CY 2025 4th Quarter Issue of the Central Visayas Journal	\N	For Information	\N	\N	Inbound	\N	\N	Lozada to post link on GC for everyone's information
39	26020503	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.791536	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.791792+08	2026-02-05	Provincial Office	\N	Memorandum	Orientation on ACDI Multipurpose Cooperative Information Drive	\N	For Dissemination	\N	\N	Inbound	\N	\N	Caido to ensure all regular staff will attend
43	26021101	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.798386	\N	Training	127.0.0.1	2026-07-06 15:21:37.798594+08	2026-02-11	Others	ROMO	Memorandum	Survey on TVET Trainer's Educational Background for Career Pathway Support	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Caido to facilitate all trainers to accomplish the survey
47	26021601	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.805192	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.805415+08	2026-02-16	Provincial Office	\N	Communication	Summary of BSRS/T2MIS Feedback Monitoring as of December 31, 2025	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	\N
51	26021903	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.812496	\N	Training	127.0.0.1	2026-07-06 15:21:37.81269+08	2026-02-19	Others	SIPTVETS PMO	Memorandum	Advisory on the Conduct of Design Thinking Workshop for TTIs	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Suarez,Pechon & Gunday as participants on this workshop
55	26022402	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.819365	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.819569+08	2026-02-24	Central Office	\N	TESDA Order	Attendance to the CBP on Strengthening Quality Assurance Practices through QMS for TESDA STAR ad TESDA SEAL Applicants (Batch 2,3 & 4)	\N	For Guidance	\N	\N	Inbound	\N	\N	Caido & Lozada to be reminded
59	26022701	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.827093	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.827336+08	2026-02-27	Others	PMO	Memorandum	Advisory on the Conduct of the RTIC Visioning Workshop	\N	For Guidance	\N	\N	Inbound	\N	\N	Sir Inar will Attend on March 2-4, 2026
63	26030201	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.835123	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.835336+08	2026-03-02	Others	Certification Office	Advisory	Reminders on the Capability Building Program on Strengthening Quality Assurance Practices Through QMS for TESDA STAR and TESDA SEAL Applicants	\N	For Guidance	\N	\N	Inbound	\N	\N	For guidance of Caido and Lozada
67	26030303	Portal Administrator	Care of Lozada	Completed	2026-07-06 15:21:37.84179	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.842027+08	2026-03-03	Regional Office	\N	Memorandum	Norming Activities for the Development of Career Profiling Instrument (CPI)	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	\N
71	26031201	Portal Administrator	Meeting Attended by members of the committee	Completed	2026-07-06 15:21:37.85002	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.850276+08	2026-03-12	Provincial Office	\N	Others	Notice of Meeting: Preparation on the Conduct of 2026 Provincial Skills Olympics & Office Order: Working Committees in the Conduct of 2026 PSO	\N	For Information	\N	\N	Inbound	N/A	\N	\N
75	26032503	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.857857	\N	Training	127.0.0.1	2026-07-06 15:21:37.858065+08	2026-03-25	Provincial Office	\N	Advisory	Schedule for Site Visit	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Magadan, Gunday & Madera to go to the site inspection
79	26032601	Portal Administrator	Accomplished nomination form from the link provided.	Completed	2026-07-06 15:21:37.867013	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.867294+08	2026-03-26	Others	Administration and Innovation	Memorandum	Nomination of Participants to the Earth Month 2026 Capacity Building Programs Sessions	\N	For Nomination	\N	\N	Inbound	\N	\N	Nominate Gunday for this CBP Sessions
83	26042001	Portal Administrator	No further updates, as advised by PO.	Completed	2026-07-06 15:21:37.873937	\N	Extension/Research	127.0.0.1	2026-07-06 15:21:37.874123+08	2026-04-20	Others	Administration and Innovation	Memorandum	Reiteration on the Updating of the Status of Motor Vehicle and Land Property Inventory of TESDA COROPOTIs	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Gunday to update
87	26042201	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.882081	\N	Training	127.0.0.1	2026-07-06 15:21:37.88231+08	2026-04-22	Central Office	\N	Memorandum	Flexible Learning Arrangements in Times of Energy Crisis	\N	For Guidance	\N	\N	Inbound	\N	\N	For guidance to all trainers
91	26043001	Portal Administrator	On file	Completed	2026-07-06 15:21:37.889303	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.889467+08	2026-04-30	Others	ICTO	Advisory	Attendance of the ROPOTI Officials and Personnel to the Training on the Deployment of Document & Records Management Info. System	\N	For File	\N	\N	Inbound	\N	\N	\N
95	26043005	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.895856	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.896073+08	2026-04-30	Provincial Office	\N	Advisory	Deployment of Learner's Satisfaction Survey to all TESDA Scholars	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	All trainers provide all survey at the end of training
99	26051303	Portal Administrator	attention all concerned	Completed	2026-07-06 15:21:37.902879	\N	Training	127.0.0.1	2026-07-06 15:21:37.903107+08	2026-05-13	Provincial Office	\N	Office Order	Addendum to Office Order No. 030 of 2026 re; Authority to attend the Competency Assessor's Calibration	\N	For Guidance	\N	\N	Inbound	\N	\N	Attention GD Magadan, RL Madera and ER Salazar
103	26060202	Portal Administrator	Just an info for us	Completed	2026-07-06 15:21:37.910575	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.910823+08	2026-06-02	Regional Office	\N	Memorandum	2026 Search for ''Best Brigada Ahensiya''	\N	For File	\N	\N	Inbound	\N	\N	Just an Info for us
107	26060206	Portal Administrator	Chester informed so with NiÃ±o	Completed	2026-07-06 15:21:37.917839	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.918351+08	2026-06-02	Central Office	\N	Memorandum	Utilization of Newly Developed TOP Courses	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Coordinate with trainers for possibility of offering this qualifications
111	26060303	Portal Administrator	Noted.	Completed	2026-07-06 15:21:37.925818	\N	Training	127.0.0.1	2026-07-06 15:21:37.926157+08	2026-06-03	Regional Office	\N	Memorandum	Work Instruction for the Implementation of TRAIN LOKAL	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Just like CBT Program ''Same dog - wearing another collar!
115	26061001	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.932434	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.932639+08	2026-06-10	Central Office	\N	Memorandum	Clarification on the Memorandum on the Reversion to the Five day Workout	\N	For Guidance	\N	\N	Inbound	\N	\N	Noted
119	26061503	Portal Administrator	This is unnecessary	Completed	2026-07-06 15:21:37.939936	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.940139+08	2026-06-15	Regional Office	\N	Memorandum	Call for Applicants/Nominations for the 2026 Blue Hearts Award	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	we have none
123	25081401	Portal Administrator	Already registered.	Completed	2026-07-06 15:21:37.947007	\N	Training	127.0.0.1	2026-07-06 15:21:37.947216+08	2025-08-14	Provincial Office	\N	Advisory	Invitation to ASEAN Toolbox Immersion Workshop	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	This is already due. RL Madera to register.
28	26012701	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.770791	\N	Training	127.0.0.1	2026-07-06 15:21:37.771011+08	2026-01-27	Regional Office	\N	Office Order	Authority to Attend the Technology Research Workshop	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Pechon and Gunday to attend on this workshop on Feb. 3-4, 2026
32	26012901	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.779485	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.779692+08	2026-01-29	Provincial Office	\N	Advisory	Reiteration of Omnibus Guidelines for the Implementation of FY 2025 TESDA Scholarship Programs Section 5.2 Submission of Billing Documents	\N	For Guidance	\N	\N	Inbound	\N	\N	Lozada to be reminded on this matter.
36	26020302	Portal Administrator	Link posted to GC	Completed	2026-07-06 15:21:37.786657	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.786849+08	2026-02-03	Central Office	\N	Memorandum	Highlights during the Joint General Directorate & AdCon held on 19-21 January 2026	\N	For Information	\N	\N	Inbound	\N	\N	Lozada to post the link on GC for everyone's access
40	26020901	Portal Administrator	Printed Office Order	Completed	2026-07-06 15:21:37.79363	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.793836+08	2026-02-09	Central Office	\N	Memorandum	Designation of Sanitation Officer & Energy Conservation Officer	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Caido to make Office Order, Gunday as Sanitation & Conservation Officer
44	26021301	Portal Administrator	Attended	Completed	2026-07-06 15:21:37.799957	\N	Training	127.0.0.1	2026-07-06 15:21:37.800152+08	2026-02-13	Provincial Office	\N	Office Order	Attendance to the 1st Quarter BLECTEC Meeting	\N	For Information	\N	\N	Inbound	\N	\N	Sir Inar, Pechon & Leo Ampo attended
48	26021801	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.806943	\N	Extension/Research	127.0.0.1	2026-07-06 15:21:37.807152+08	2026-02-18	Others	Jagna High School	Communication	Request for Resource Speaker (Career Guidance) on Feb. 25, 2026	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Gunday to serve as Resource Speaker
52	26022001	Portal Administrator	Submitted before deadline.	Completed	2026-07-06 15:21:37.814311	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.814546+08	2026-02-20	Provincial Office	\N	Advisory	Submission of Notarized Affidavit of Undertaking	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Lozada have submitted to PO the notarized AOU on Feb. 24, 2026
56	26022501	Portal Administrator	Attended.	Completed	2026-07-06 15:21:37.821026	\N	Training	127.0.0.1	2026-07-06 15:21:37.821237+08	2026-02-25	Others	Calabacita National High School	Communication	Request for Guest Speakers for Career Guidance Program on February 27, 2026	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Gunday to serve as Guest Speaker for Career Guidance
60	26022702	Portal Administrator	On file	Completed	2026-07-06 15:21:37.829022	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.829376+08	2026-02-27	Others	SEIAC	Memorandum	The Semiconductor Asia Summit 2026 on March 5-6, 20226 at Penang, Malaysia	\N	For Information	\N	\N	Inbound	\N	\N	\N
64	26030301	Portal Administrator	Attended by Leo Ampo (Pechon on travel)	Completed	2026-07-06 15:21:37.836976	\N	Training	127.0.0.1	2026-07-06 15:21:37.837181+08	2026-03-03	Jagna LGU	\N	Communication	Attendance to the Municipal Convergence Committee 1st Quarter Meeting	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Pechon to attend on this meeting
68	26030401	Portal Administrator	Attended.	Completed	2026-07-06 15:21:37.844435	\N	Training	127.0.0.1	2026-07-06 15:21:37.844673+08	2026-03-04	Provincial Office	\N	Office Order	Attendance to the 1st Quarter PTESDC Meeting	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Suarez to attend to the meeting
72	26031701	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.852378	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.852629+08	2026-03-17	Provincial Office	\N	Advisory	Prioritization of 4Ps SHS Graduates/Graduating Students under TESDA Scholarship Programs	\N	For Guidance	\N	\N	Inbound	\N	\N	Lozada and Caido to be reminded
76	26032504	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.860998	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.861238+08	2026-03-25	Others	Certification Office	Memorandum	Clarifications on the Exemption from the Conduct of Compliance Audit	\N	For Information	\N	\N	Inbound	\N	\N	\N
80	26033001	Portal Administrator	Posted to GC	Completed	2026-07-06 15:21:37.869185	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.869383+08	2026-03-30	Provincial Office	\N	Advisory	Participation to the 2026 Provincial Skills Olympics	\N	For Information	\N	\N	Inbound	\N	\N	PMC Salazar to post this Advisory to GC for information of everyone
84	26042002	Portal Administrator	Noted.	Completed	2026-07-06 15:21:37.875494	\N	Extension/Research	127.0.0.1	2026-07-06 15:21:37.875848+08	2026-04-20	Others	Administration and Innovation	TESDA Order	Attendance of TESDA Personnel in the Conduct of Training of Trainers on 2D/3D Mechanical Design using Autodesk Inventor	\N	For Information	\N	\N	Inbound	\N	\N	Gunday to prepare for the training
88	26042202	Portal Administrator	On file	Completed	2026-07-06 15:21:37.884118	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.884463+08	2026-04-22	Others	ROMO	Memorandum	Request for Nomination of Participants for the Conduct of the Organizational Planning/Strategic Planning in TVET	\N	For Information	\N	\N	Inbound	\N	\N	Will not send participants
92	26043002	Portal Administrator	called Leo, and prepared letter Request for replacement from sir Gundat to Pechon	Completed	2026-07-06 15:21:37.890628	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.890786+08	2026-04-30	Provincial Office	\N	Office Order	Designation of Facilitators for the Conduct of Calibration and Assessor's Moderation	\N	For Guidance	\N	\N	Inbound	\N	\N	Pechon as replacement participant
96	26050601	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.897319	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.897523+08	2026-05-06	Regional Office	\N	Memorandum	Status update of GAA TVET Activities with tie-ups with industry	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Please take action MR. Pechon
100	26052001	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.90463	\N	Training	127.0.0.1	2026-07-06 15:21:37.904839+08	2026-05-20	Garcia-Hernandez LGU	\N	Communication	Electrical Installation Management NC II training	\N	For File	\N	\N	Inbound	\N	\N	attention GD Magadan
104	26060203	Portal Administrator	Just an info for us	Completed	2026-07-06 15:21:37.912311	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.912514+08	2026-06-02	Regional Office	\N	Memorandum	TESDC 1st Quarter Status Report CY 2026	\N	For Information	\N	\N	Inbound	\N	\N	Just an Info for us
108	26060207	Portal Administrator	Just an info for us	Completed	2026-07-06 15:21:37.920525	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.920767+08	2026-06-02	Central Office	\N	Memorandum	Compliance with NPC Registration and Privacy Notice/Consent Requirements	\N	For Guidance	\N	\N	Inbound	\N	\N	Just an Info for us
112	26060304	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.927925	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.928145+08	2026-06-03	Provincial Office	\N	Office Order	Working Committees in the Conduct Various Activities on June 25, 2026	\N	For Guidance	\N	\N	Inbound	\N	\N	attention Mr. Lloren
116	26061101	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.934464	\N	Training	127.0.0.1	2026-07-06 15:21:37.934856+08	2026-06-11	Provincial Office	\N	Communication	Bohol Province PESO - CTEC 2026 by STAR	\N	For File	\N	\N	Inbound	\N	\N	Mr. Pechon will facilitate this communication to reach the CTEC's
120	26061504	Portal Administrator	Just an info for us	Completed	2026-07-06 15:21:37.941749	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.941972+08	2026-06-15	Central Office	\N	Memorandum	Approved Joint Memorandum Circular (JMC) for Bagong Pilipinas Merit Scholarship Program (BPMSP)	\N	For Information	\N	\N	Inbound	\N	\N	Just an Info for us
124	25081901	Portal Administrator	Already on file	Completed	2026-07-06 15:21:37.948958	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.949145+08	2025-08-19	Provincial Office	\N	Memorandum	Approved and Signed(MOA) for SIL	\N	For File	\N	\N	Inbound	\N	\N	Keep the MOA on file
29	26012702	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.77272	\N	Training	127.0.0.1	2026-07-06 15:21:37.772945+08	2026-01-27	Mabini LGU	\N	Communication	Request for Conduct of CBT on EIM, Driving and Housekeeping	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Sir Suarez to supervise implementation and Pechon to coordinate w/ Ms. Hiyangan
33	26012902	Portal Administrator	On file	Completed	2026-07-06 15:21:37.781257	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.781454+08	2026-01-29	Central Office	\N	Memorandum	Dissemination of the COA Schedule of Course Offerings for Agency Personnel CY 2026	\N	For File	\N	\N	Inbound	\N	\N	We will not send participants
37	26020501	Portal Administrator	Nomination Form sent to PO	Completed	2026-07-06 15:21:37.788214	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.788434+08	2026-02-05	Central Office	\N	Memorandum	Call for Nomination to the ITAPS and Anti-Corruption Laws Seminar	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Caido to ask interested regular staff and endorse to RO
41	26020902	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.795341	\N	Training	127.0.0.1	2026-07-06 15:21:37.795544+08	2026-02-09	Others	DDG- Policies and Planning	Memorandum	Request for the Dissemination of the SNA Questionnaire for the RTIC Visioning Workshop	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Pechon to ensure all respondents to accomplish the SNA
45	26021201	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.801911	\N	Extension/Research	127.0.0.1	2026-07-06 15:21:37.802133+08	2026-02-12	Others	Cogtong National High School	Communication	Request for Resource Speaker for Career Talk Symposium	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Gunday to serve as Resource Speaker
49	26021901	Portal Administrator	Attended	Completed	2026-07-06 15:21:37.808656	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.809064+08	2026-02-19	Regional Office	\N	Office Order	Authority to Attend the Pre-Planning Workshop	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Caido and Sir Inar attended
53	26022301	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.815935	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.816145+08	2026-02-23	Provincial Office	\N	Advisory	Attendance to the Learning Session/ ROrientation in the Conduct of Compliance Audit for Program Registration & Competency Assessment & Certification	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Caido & Lozada to attend on the Orientation
57	26022502	Portal Administrator	Abacial to report to PO every Monday	Completed	2026-07-06 15:21:37.822832	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.823001+08	2026-02-25	Provincial Office	\N	Memorandum	Request of TTIs Staff Augmentation	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Abacial to represent PTC-Jagna
61	26022703	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.831354	\N	Extension/Research	127.0.0.1	2026-07-06 15:21:37.831601+08	2026-02-27	Others	PESO-Mabini	Communication	Invitation for Career Guidance	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Gunday to serve as Guest Speaker for Career Guidance
65	26030202	Portal Administrator	Attended	Completed	2026-07-06 15:21:37.838586	\N	Extension/Research	127.0.0.1	2026-07-06 15:21:37.838784+08	2026-03-02	Others	N/A	Communication	Invitation for Career Guidance on MArch 18, 2026	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Gunday to serve as Guest Speaker for Career Guidance
69	26030601	Portal Administrator	On file	Completed	2026-07-06 15:21:37.846245	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.846471+08	2026-03-06	Others	Unified TVET of the Philippines	Communication	3rd Visayas TVET Conference	\N	For Information	\N	\N	Inbound	\N	\N	\N
73	26032501	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.854263	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.854478+08	2026-03-25	Regional Office	\N	Memorandum	Appropriate Captions for Photo Images in After Activity Report for Clearer Context and Better Understanding	\N	For Guidance	\N	\N	Inbound	\N	\N	PMC Salazar, Gomez & Pechon to take note of the recommendation
77	26032505	Portal Administrator	Posted to GC	Completed	2026-07-06 15:21:37.863206	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.863426+08	2026-03-25	Others	Administrative Service	Memorandum	Earth Hour 2026	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Salazar to post to GC for everyone's awareness
81	26040601	Portal Administrator	On file.	Completed	2026-07-06 15:21:37.870931	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.871114+08	2026-04-06	Others	Administration and Innovation	Memorandum	Suspension of the Submission of the Fiscal Year 2025 Agency Procurement Compliance and Performance Indicator Results	\N	For File	\N	\N	Inbound	\N	\N	\N
85	26042003	Portal Administrator	Submitted to PO on April 23, 2026	Completed	2026-07-06 15:21:37.878497	\N	Extension/Research	127.0.0.1	2026-07-06 15:21:37.87873+08	2026-04-20	Regional Office	\N	Memorandum	Submission of Green TVET Action Plan	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Gunday to submit Green TVET Action Plan
89	26042901	Portal Administrator	On file	Completed	2026-07-06 15:21:37.886204	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.886446+08	2026-04-29	Others	ROMO	Memorandum	Reiteration of Duties in Preventing and Addressing Sexual Harassment in TTIs	\N	For Information	\N	\N	Inbound	\N	\N	\N
93	26043003	Portal Administrator	called Leo, and prepared letter Request for replacement from sir Gundat to Pechon	Completed	2026-07-06 15:21:37.892109	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.892327+08	2026-04-30	Provincial Office	\N	Office Order	Designation of Facilitators for the Conduct of Calibration and Assessor's Moderation	\N	For Guidance	\N	\N	Inbound	\N	\N	Pechon as replacement participant
97	26051301	Portal Administrator	Mr. Suarez will attend and Mr. Gunday is conflict of Schedule	Completed	2026-07-06 15:21:37.899133	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.899344+08	2026-05-13	Provincial Office	\N	Office Order	Authority to attend the Assessor's Calibration	\N	For Guidance	\N	\N	Inbound	\N	\N	attention to all concerned
101	26060101	Portal Administrator	This is unnecessary	Completed	2026-07-06 15:21:37.90654	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.906833+08	2026-06-01	Central Office	\N	Memorandum	Call for Nominations to the Technical Training on ''From Creation to Disposal: Practical Records Management for LGU's and NGA's	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	\N
105	26060204	Portal Administrator	done already	Completed	2026-07-06 15:21:37.913873	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.914066+08	2026-06-02	Regional Office	\N	Memorandum	Participation in the TESDA Knowledge Management Portal Scoping Questionnaire	\N	For Information	\N	\N	Inbound	\N	\N	Done already
109	26060301	Portal Administrator	Noted already informed Mr. Pechon	Completed	2026-07-06 15:21:37.922261	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.922496+08	2026-06-03	Provincial Office	\N	Memorandum	Submission of Nominees for the 2025 Regional TESDA Model Employee of the Year Awards (TMEOYA)	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Pechon will be nominated from this
113	26060401	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.929441	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.929632+08	2026-06-04	Provincial Office	\N	Office Order	Attendance the 2nd Quarter Provincial Technical Education and Skills Development Committee (PTESDC) MeetingC	\N	For Reference	\N	\N	Inbound	\N	\N	\N
117	26061501	Portal Administrator	We will attend this Virtual	Completed	2026-07-06 15:21:37.93662	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.93681+08	2026-06-15	Regional Office	\N	Memorandum	Authority to attend the virtual Orientation on the CLGE Management Information System (CLGE MIS) and CTEC Information System (CTEC IS)	\N	For Guidance	\N	\N	Inbound	\N	\N	Mr. Pechon and Ms. CadeliÃ±a will attend
121	26061505	Portal Administrator	No files yet in the Intranet	Completed	2026-07-06 15:21:37.943836	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.944065+08	2026-06-15	Central Office	\N	Advisory	Deferment of the Distribution of Competency Assessment Tools (CATs) Volume 46 via Intranet	\N	For Information	\N	\N	Inbound	\N	\N	Try to access the Intranet and download for reference purposes
125	25082201	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.950689	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.950945+08	2025-08-22	Central Office	\N	Advisory	TOP/MRTOP Technical Support Advisory	\N	For Information	\N	\N	Inbound	\N	\N	\N
126	25090101	Portal Administrator	Accomplished	Completed	2026-07-06 15:21:37.952687	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.952929+08	2025-09-01	Central Office	\N	Memorandum	Conduct of the Third Survey Round for the 2025 Users Feedback Survey on the Policy Issuances/Guidelines of TESDA	https://bit.ly/3rdSun/eyRound2025UFS	For File	\N	\N	Inbound	\N	\N	Accomplished
130	25091201	Portal Administrator	Filed.	Completed	2026-07-06 15:21:37.960174	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.960418+08	2025-09-12	Central Office	\N	Advisory	Submission of CY 2025 Applications for Asia Pacific Accreditation and Certification Commission (APACC)	https://tinyurl.com/2025APACC	For File	\N	\N	Inbound	\N	\N	We are not qualified for APACC
134	25091205	Portal Administrator	RL Madera attended the training on Sept. 15-16, 2025	Completed	2026-07-06 15:21:37.966998	\N	Training	127.0.0.1	2026-07-06 15:21:37.967312+08	2025-09-12	Regional Office	\N	Office Order	Attendance at the Conduct of the Regional Multiplier Training on the Development of Training Plans for the CBTP	\N	For Information	\N	\N	Inbound	\N	\N	RL Madera to prepare for the training.
138	25092301	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.974178	\N	Training	127.0.0.1	2026-07-06 15:21:37.974383+08	2025-09-23	Regional Office	\N	Office Order	Physical Count of PPE for PTCs Cebu, Bohol, Dumaguete & Siquijor, LTI...	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Gunday to prepare docs for this activity
142	25092901	Portal Administrator	Posted to GC	Completed	2026-07-06 15:21:37.981442	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.981645+08	2025-09-29	Central Office	\N	Memorandum	Guidelines for the 2025 Loyalty Award	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Abacial to download and post the Memo on the GC for information
146	25100201	Portal Administrator	On file	Completed	2026-07-06 15:21:37.98856	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.988785+08	2025-10-02	Regional Office	\N	Office Order	Amendment & Addendum to Office Order No. 0194, Physical Count of PPE for PTCs, etc.	\N	For Information	\N	\N	Inbound	\N	\N	\N
150	25100205	Portal Administrator	Attended	Completed	2026-07-06 15:21:37.995925	\N	Training	127.0.0.1	2026-07-06 15:21:37.996133+08	2025-10-02	Central Office	\N	TESDA Order	Attendance of TESDA Personnel to the Technology Research Forum back-to-back w/ 2025 International Roadshow	\N	For Dissemination	\N	\N	Inbound	\N	\N	\N
154	25100701	Portal Administrator	Nomination Form sent to RO for RDs approval	Completed	2026-07-06 15:21:38.002686	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.002937+08	2025-10-07	Central Office	\N	Memorandum	Request for Nomination of Participants to the SIPTVETS Project Workshop on Gender Equality, Environment & Social Safeguards	\N	For Nomination	\N	\N	Inbound	\N	\N	MLO Caido and JKT Gunday were nominated
158	25101402	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.009574	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.009855+08	2025-10-14	Central Office	\N	Memorandum	Official Name Style for the Secretary	\N	For Guidance	\N	\N	Inbound	\N	\N	Caido- Pls. ensure all docs. are all in accordance to this memo.
162	25101701	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.016193	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.016391+08	2025-10-17	Provincial Office	\N	Office Order	Attendance to the Re-Echo on the YAKAP Program of PhilHealth	\N	For Information	\N	\N	Inbound	\N	\N	All regular staff to attend
166	25102801	Portal Administrator	Sent communication to trainers	Completed	2026-07-06 15:21:38.023285	\N	Training	127.0.0.1	2026-07-06 15:21:38.02349+08	2025-10-28	Provincial Office	\N	Communication	CPG Local & Overseas Job Fair	\N	For Dissemination	\N	\N	Inbound	\N	\N	Trainers to contact graduates and share the QR Code for registration
170	25110502	Portal Administrator	Forwarded to PO	Completed	2026-07-06 15:21:38.030422	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.030632+08	2025-11-05	Central Office	\N	Others	Request to fill-out the hotel Canvass form	\N	Others	N/A	\N	Inbound	N/A	\N	Already forwarded to PO
174	25110703	Portal Administrator	On file	Completed	2026-07-06 15:21:38.038056	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.038313+08	2025-11-07	Central Office	\N	Memorandum	Guidelines on Trainings, Briefings, and Workshops per COA Circular No. 2025-003	\N	For File	\N	\N	Inbound	\N	\N	Put on file for future reference
178	25111201	Portal Administrator	Attended.	Completed	2026-07-06 15:21:38.044661	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.044827+08	2025-11-12	Regional Office	\N	Office Order	Authority to attend the Presentation of Granularized ABDD Skills priorities by Wadhwan Foundation	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Sir Inar will attend on this meeting via Zoom on Nov, 12, 2025
182	25111302	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.052555	\N	Training	127.0.0.1	2026-07-06 15:21:38.052766+08	2025-11-13	Others	Policies and Training	Memorandum	Requesting COROPOTIs to provide inputs into and update entries in the TVET Research Monitoring Database	bit.ly/ResearchInitiatives	For Appropriate Action	\N	\N	Inbound	\N	\N	All trainers to submit your technology reasearch through the link
186	25111803	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.060368	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.060655+08	2025-11-18	Central Office	\N	TESDA Order	Regional Lead Trainers Development for Web Technologies (Web Design NC III, Web Development (Front-End) NC III, and Web Development (Back-End) NC III	\N	For Information	\N	\N	Inbound	\N	\N	Lozada to Attend the Training
190	25112001	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.068268	\N	Training	127.0.0.1	2026-07-06 15:21:38.068584+08	2025-11-20	Jagna LGU	\N	Communication	KALAHI- CIDSS Exit Conference cum MCC Meeting	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Pechon to attend on this meeting on Nov. 21, 2025
194	25120301	Portal Administrator	Attended by Sir Inar, Chester and two trainees	Completed	2026-07-06 15:21:38.07614	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.076398+08	2025-12-03	Others	ICTO	Memorandum	Request for the Participation of TESDA Learners and Personnel in the Key Informant Interview for the Evaluation of the TESDA Online Program	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	\N
198	25121001	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.083135	\N	Training	127.0.0.1	2026-07-06 15:21:38.083334+08	2025-12-10	Others	NTTA	Advisory	Virtual Orientation and Training on the Khan Academy (KA) Teacher Dashboard	\N	For Information	\N	\N	Inbound	\N	\N	For all trainers
202	25121202	Portal Administrator	Represented and conducted	Completed	2026-07-06 15:21:38.089895	\N	Training	127.0.0.1	2026-07-06 15:21:38.090101+08	2025-12-12	Regional Office	\N	Office Order	Designation of RO Representative in the conduct of Ocular Inspection	\N	For Information	\N	\N	Inbound	\N	\N	For Suarez
206	25121503	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.096476	\N	Training	127.0.0.1	2026-07-06 15:21:38.096718+08	2025-12-15	Provincial Office	\N	Advisory	Recommended Program for the Conduct of Graduation Ceremony	\N	For Guidance	\N	\N	Inbound	\N	\N	For guidance of Trainers
210	25122301	Portal Administrator	Attended	Completed	2026-07-06 15:21:38.103308	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.103537+08	2025-12-23	Jagna LGU	\N	Communication	Rizal Day Celebration	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Sir Inar and Ma'am Leil attended
127	25090401	Portal Administrator	Coordinated with PESO Lila, sent Confirmation Slip to the email provided.	Completed	2026-07-06 15:21:37.954553	\N	Training	127.0.0.1	2026-07-06 15:21:37.954762+08	2025-09-04	Lila LGU	\N	Communication	Local and Overseas Jobs Fair	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Coordinate with PESO Lila.
131	25091202	Portal Administrator	Accomplished AUP submitted to PO	Completed	2026-07-06 15:21:37.96206	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.962269+08	2025-09-12	Central Office	\N	Memorandum	Implementation of the AUP	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Caido to facilitate printing of AUP, distribute to all staff.
135	25091501	Portal Administrator	MNL Pechon will attend	Completed	2026-07-06 15:21:37.969024	\N	Training	127.0.0.1	2026-07-06 15:21:37.969229+08	2025-09-15	Others	BLECTEC President	Others	Attendance to 3rd Quarter BLECTEC, Inc. Meeting	\N	For Appropriate Action	\N	\N	Inbound	N/A	\N	Pechon to attend on this meeting and follow-up our STAR CTECs
139	25092401	Portal Administrator	Facilitated	Completed	2026-07-06 15:21:37.976012	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.976292+08	2025-09-24	Central Office	\N	Memorandum	Agency-Wide Conduct of the Information Process Flow Mapping Survey	\N	For Dissemination	\N	\N	Inbound	\N	\N	MLO Caido to facilitate all staff accomplishing the survey
143	25092902	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.983036	\N	Training	127.0.0.1	2026-07-06 15:21:37.983246+08	2025-09-29	Central Office	\N	TESDA Order	Reconstitution of the TWG for the Conduct of Training-Cum-Workshops on the Procurement of SIPTVETS-RTICs Equipment	\N	For Nomination	\N	\N	Inbound	\N	\N	Gunday and Pechon to take note of the changes of TWG
147	25100202	Portal Administrator	Collected and sent to PO (Sir Leo)	Completed	2026-07-06 15:21:37.990299	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.990527+08	2025-10-02	Regional Office	\N	Advisory	Cebu Earthquake Fund Drive	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Collect money donation to all staff
151	25100301	Portal Administrator	Nomination Form sent to email provided	Completed	2026-07-06 15:21:37.99744	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.997636+08	2025-10-03	Central Office	\N	Memorandum	Request for Nomination of Master's Degree Program for TESDA Trainers & Administrators	\N	For Nomination	\N	\N	Inbound	\N	\N	AP CadeliÃ±a, Pechon & Gunday are nominated
155	25100702	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.004384	\N	Training	127.0.0.1	2026-07-06 15:21:38.004581+08	2025-10-07	Central Office	\N	Memorandum	Mobilization of TTI to Provide Necessary Support for the EBET Program Registration	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Pechon to provide assistance to BOHECO II to register to EBET Program
159	25101403	Portal Administrator	Submitted before deadline.	Completed	2026-07-06 15:21:38.01139	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.011609+08	2025-10-14	Regional Office	\N	Memorandum	Submission of the 3rd Quarter RRRO for CY 2025	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Lozada to submit on time
163	25102001	Portal Administrator	Post on GC	Completed	2026-07-06 15:21:38.018426	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.01864+08	2025-10-20	Central Office	\N	Memorandum	Proclamation No. 1006, Declaring the Regular Holidays & Special Non-Working Days for the Yr 2026	\N	For Information	\N	\N	Inbound	\N	\N	\N
167	25102901	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.024961	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.02518+08	2025-10-29	Provincial Office	\N	Office Order	Authority to Attend the TESDA Bohol Industry Forum 2025	\N	For Information	\N	\N	Inbound	\N	\N	Sir Inar, Lozada and Suarez will attend the forum on Nov. 5, 2025
171	25110503	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.031975	\N	Training	127.0.0.1	2026-07-06 15:21:38.032185+08	2025-11-05	Provincial Office	\N	Office Order	Authority to Attend the Multiplier Training on Community Program Development Services	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Pechon to attend as ordered
175	25110704	Portal Administrator	We will not send Participants	Completed	2026-07-06 15:21:38.039741	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.039937+08	2025-11-07	Central Office	\N	Memorandum	Future Port Youth Conference	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	\N
179	25111202	Portal Administrator	Copies provided	Completed	2026-07-06 15:21:38.047513	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.047853+08	2025-11-12	Central Office	\N	TESDA Circular	Omnibus Guidelines for the Implementation of FY 2025 TESDA Scholarship Programs	\N	For Reference	\N	\N	Inbound	\N	\N	Caido, Lozada & Pechon to secure own copies
183	25111303	Portal Administrator	Noted. Activities prepared and posted to GC and Bulletin Board	Completed	2026-07-06 15:21:38.054164	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.054418+08	2025-11-13	Regional Office	\N	Memorandum	TESDA VIIs Observance of the 18-Day Campaign to End VAWC on Nov. 25 to Dec. 12, 2025	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Caido to plan activities on this campaign
187	25111901	Portal Administrator	Nomination prepared and emailed by Salazar	Completed	2026-07-06 15:21:38.062228	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.062488+08	2025-11-19	Others	ROMO	Memorandum	Request for Nomination of Training of Trainers Workshop on "Artificial Intelligence for Digital Novice MSMEs" under Digital-PINAS	\N	For Nomination	\N	\N	Inbound	\N	\N	Caido to facilitate submission of nomination- Gunday and Pechon
191	25112002	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.070392	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.070605+08	2025-11-20	Others	T-Monte Integrated School	Communication	Invitation to Serve as Resource Speaker for Career Guidance Program	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Caido as resource speaker since Gunday is on official travel at Cebu
195	25120401	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.078122	\N	Training	127.0.0.1	2026-07-06 15:21:38.078343+08	2025-12-04	Provincial Office	\N	Memorandum	Conduct of Community-Based Trainers Methodology Course	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Magadan to prepare Course Design for the Training
199	25121002	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.085197	\N	Training	127.0.0.1	2026-07-06 15:21:38.08543+08	2025-12-10	Provincial Office	\N	Office Order	Conduct of Ocular Inspection to Applicant TVIs for Mobile Training Program under UTPRAS	\N	For Guidance	\N	\N	Inbound	\N	\N	Gunday-for guidance
203	25121203	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.091457	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.091657+08	2025-12-12	Provincial Office	\N	Advisory	2025 Year-End Performance Assessment (YEPA)	\N	For Guidance	\N	\N	Inbound	\N	\N	Gunday to prepare presentation
207	25121601	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.098259	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.098464+08	2025-12-16	Central Office	\N	Memorandum	Submission of 2025 TTIs Reports and Deliverables	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	NiÃ±o to prepare IDP and Chester for Absorptive Capacity and Training Calendar
128	25090402	Portal Administrator	All 6 qualifications are compliant	Completed	2026-07-06 15:21:37.956335	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.956546+08	2025-09-04	Regional Office	\N	Memorandum	National Accomplishments on FY 2025 Compliance Audit for Registered Programs and Qualifications of Accredited Assessment Centers from January to July 2025	\N	Kindly Provide Feedback	\N	\N	Inbound	\N	\N	Are we all compliant?
132	25091203	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.96374	\N	Training	127.0.0.1	2026-07-06 15:21:37.963946+08	2025-09-12	Provincial Office	\N	Office Order	Attendance to 3rd Quarter PTESDC Meeting	\N	For Information	\N	\N	Inbound	\N	\N	Pechon to be reminded
136	25091601	Portal Administrator	Attended	Completed	2026-07-06 15:21:37.970792	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.970984+08	2025-09-16	Provincial Office	\N	Memorandum	Attendance of CP Lozada to the Data Privacy Competency Protection Framework Training	\N	For Information	\N	\N	Inbound	\N	\N	Lozada to attend as ordered
140	25092402	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.977914	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.978123+08	2025-09-24	Central Office	\N	TESDA Order	Amendment of 2025 CB on Data Management & Monitoring & Evaluation for the SIPTVET Project	\N	For Guidance	\N	\N	Inbound	\N	\N	Caido, Lozada & Suarez to take note of the amendment of your CB on DM
144	25092903	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.984994	\N	Training	127.0.0.1	2026-07-06 15:21:37.985265+08	2025-09-29	Regional Office	\N	Memorandum	Job Openings for Skilled Professionals from Cebu Doctor's University	\N	For Dissemination	\N	\N	Inbound	\N	\N	Gunday to disseminate this job opportunity to our graduates
148	25100203	Portal Administrator	Already on file	Completed	2026-07-06 15:21:37.992028	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.992337+08	2025-10-02	Central Office	\N	Memorandum	Request for Comments/Additional Inputs and Recommendations on the Draft IGs for the conduct of Tagsanay Award	\N	For File	\N	\N	Inbound	\N	\N	No Comment
152	25100302	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.998968	\N	Training	127.0.0.1	2026-07-06 15:21:37.999174+08	2025-10-03	Mabini LGU	\N	Communication	List of Trainees in Hilot Wellness Massage Training- CBTP	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Pechon to communicate with RL Madera regarding the training
156	25100703	Portal Administrator	Google sheet filled-up for proposal	Completed	2026-07-06 15:21:38.005941	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.006188+08	2025-10-07	Central Office	\N	Memorandum	Hiring of GIP Intern for FY 2026	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	To submit proposal
160	25101404	Portal Administrator	Filed.	Completed	2026-07-06 15:21:38.012988	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.013206+08	2025-10-14	Central Office	\N	Memorandum	Memo 434- Nomination to the SCP Course on Industry 4.0 & the Future of AI & Big Data Analytics	\N	For Nomination	\N	\N	Inbound	\N	\N	No Qualified
164	25102101	Portal Administrator	\N	Completed	2026-07-06 15:21:38.020143	\N	Training	127.0.0.1	2026-07-06 15:21:38.020399+08	2025-10-21	Provincial Office	\N	Advisory	Conduct of Industry Forum for TVET Partners	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Pechon to make a communication and invite industry partner in EIM and SMAW
168	25102902	Portal Administrator	Informed Yeth & Dan	Completed	2026-07-06 15:21:38.027069	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.027304+08	2025-10-29	Central Office	\N	Memorandum	CSC eService Online Application for 8 March 2026 CSE	\N	For Information	\N	\N	Inbound	\N	\N	Inform JOs
172	25110701	Portal Administrator	Posted to GC by Sir Inar	Completed	2026-07-06 15:21:38.033725	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.033961+08	2025-11-07	Central Office	\N	Memorandum	Request for the List of Participants in the Conduct of CBP on Strengthening Quality Assurance Practices through QMS for TESDA STAR	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	\N
176	25111001	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.041134	\N	Training	127.0.0.1	2026-07-06 15:21:38.041295+08	2025-11-10	Provincial Office	\N	Communication	Request for Resource Speaker	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Suarez to facilitate as resource speaker for DAR personnel as requested
180	25111203	Portal Administrator	Attended.	Completed	2026-07-06 15:21:38.04917	\N	Training	127.0.0.1	2026-07-06 15:21:38.049331+08	2025-11-12	Others	SIPTVETS PMU	Others	Notice of Meeting Agenda: ACMI Presentation of Delivery Plan & Schedule, etc.	\N	For Appropriate Action	\N	\N	Inbound	N/A	\N	Gunday to attend on this meeting
184	25111801	Portal Administrator	On file	Completed	2026-07-06 15:21:38.055997	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.056249+08	2025-11-18	Regional Office	\N	Memorandum	Invitation from Visayas TVET Association on the Conduct of E-Commerce Operations Level III Training Workshop	\N	For File	\N	\N	Inbound	\N	\N	\N
188	25111902	Portal Administrator	Informed trainers and provided link	Completed	2026-07-06 15:21:38.064126	\N	Training	127.0.0.1	2026-07-06 15:21:38.064364+08	2025-11-19	Central Office	\N	Memorandum	Internal Beta Testing for TESDA Best Skills Passport Application	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Caido to facilitate the testing to our trainees and staff
192	25112501	Portal Administrator	Inspected	Completed	2026-07-06 15:21:38.072304	\N	Training	127.0.0.1	2026-07-06 15:21:38.07258+08	2025-11-25	Provincial Office	\N	Office Order	Inspection to 2024 STEP Toolkits	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	RD Suarez
196	25120402	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.079782	\N	Training	127.0.0.1	2026-07-06 15:21:38.079986+08	2025-12-04	Others	PMO	Advisory	Advisory on the Coduct of Key Informant Interview for the TESDA Online Program Evaluation	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Glenn and Roldan to orient their trainees for possible questions
200	25121003	Portal Administrator	Attended	Completed	2026-07-06 15:21:38.086858	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.087061+08	2025-12-10	Others	BLECTEC President	Communication	Attendance to 4th Quarter BLECTEC, Inc. Meeting	\N	For Guidance	\N	\N	Inbound	\N	\N	Pechon and Sir Inar will attend.
204	25121501	Portal Administrator	Facilitated.	Completed	2026-07-06 15:21:38.093264	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.093496+08	2025-12-15	Provincial Office	\N	Memorandum	Schedule of Ocular Inspection	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Caido to facilitate inspection process
208	25121801	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.099797	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.100013+08	2025-12-18	Regional Office	\N	Memorandum	Medical/Health Card Allocation from the Collective Negotiation Agreement (CNA) Incentive	\N	For Information	\N	\N	Inbound	\N	\N	For Information to All Regulars
133	25091204	Portal Administrator	Already accomplished.	Completed	2026-07-06 15:21:37.965352	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.965548+08	2025-09-12	Central Office	\N	Memorandum	Call for Nomination and Registration to the TVET Excellence: Mastering Technology Research Training Program	https://bit.ly/TVETExcellence2025	For File	\N	\N	Inbound	\N	\N	Accomplished
137	25091901	Portal Administrator	Noted	Completed	2026-07-06 15:21:37.97249	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.972704+08	2025-09-19	Jagna LGU	\N	Communication	International Coastal Clean-up 2025	\N	For Information	\N	\N	Inbound	\N	\N	All staff to join the clean-up on Sept. 20, 2025 at 6:00 am
141	25092501	Portal Administrator	Nomination Form sent to email provided	Completed	2026-07-06 15:21:37.979503	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.979816+08	2025-09-25	Central Office	\N	Memorandum	Nomination to the Technology Transfer Training on Adobe....	\N	For Nomination	\N	\N	Inbound	\N	\N	Lozada and Pechon were nominated
145	25093001	Portal Administrator	Already on file	Completed	2026-07-06 15:21:37.986981	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.987207+08	2025-09-30	Provincial Office	\N	Advisory	Attendance to Virtual Training's Provider's Meeting	https://meet.ggogle.com/qky-jvib-ftj	For Information	\N	\N	Inbound	\N	\N	Sir Inar will attend on this meeting
149	25100204	Portal Administrator	Already on file	Completed	2026-07-06 15:21:37.994152	\N	Administrative	127.0.0.1	2026-07-06 15:21:37.994394+08	2025-10-02	Central Office	\N	Memorandum	Request for Nomination on the Conduct of the Regional Lead Trainers Devt. Program on Web Technologies	\N	For Nomination	\N	\N	Inbound	\N	\N	No Qualified
153	25092904	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.000661	\N	Training	127.0.0.1	2026-07-06 15:21:38.000953+08	2025-09-29	Provincial Office	\N	Office Order	Authority to Attend the 3rd Quarter BLECTEC Meeting	\N	For Information	\N	\N	Inbound	\N	\N	Pechon will attend the meeting
157	25101401	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.007673	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.007888+08	2025-10-14	Central Office	\N	Memorandum	Official Name Style for the Secretary	\N	For Guidance	\N	\N	Inbound	\N	\N	Caido- Pls. ensure all docs. are all in accordance to this memo.
161	25101601	Portal Administrator	Posted to GC.	Completed	2026-07-06 15:21:38.014595	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.014859+08	2025-10-16	Central Office	\N	TESDA Order	TESDA Order 695: Designation of TESDA Officials & Personnel on the Compliance w/ the Data Privacy Act	\N	For Information	\N	\N	Inbound	\N	\N	Caido- Pls. post on GC
165	25102701	Portal Administrator	Sir Inar will attend	Completed	2026-07-06 15:21:38.02181	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.022006+08	2025-10-27	Central Office	\N	Memorandum	JDS Phils. Promotional Seminar	bit.ly/JDS2025Seminar	For Information	\N	\N	Inbound	\N	\N	Seminar on Nov. 12 9:30 to 11:00am via zoom
169	25110501	Portal Administrator	Certification done and sent to PMO	Completed	2026-07-06 15:21:38.028801	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.029011+08	2025-11-05	Central Office	\N	Others	Request for Venue or Certification of Non-Availability of Venue	\N	For Appropriate Action	\N	\N	Inbound	N/A	\N	Salazar to create a certification
173	25110702	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.035939	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.03628+08	2025-11-07	Central Office	\N	Memorandum	Conduct of Comprehensive Inventory of Computer Systems and Network Assessment	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Lozada to assist ICTO personnel on Nov. 17, 2025
177	25111101	Portal Administrator	On file	Completed	2026-07-06 15:21:38.043087	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.043303+08	2025-11-11	Regional Office	\N	Office Order	Authority to attend the 2nd Semester 2025 Regional Quality Management Committee (RQMC) cum Management Committee (ManCom)Meeting	\N	For Dissemination	\N	\N	Inbound	\N	\N	\N
181	25111301	Portal Administrator	Submitted	Completed	2026-07-06 15:21:38.050781	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.051008+08	2025-11-13	Others	ICTO	Memorandum	Request to Participate in the Evaluation of the TESDA Online Program and Nomination of Participants to the Key Informant Interview (KII)	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Caido and Lozada to facilitate survey for learners
185	25111802	Portal Administrator	Activity to be conducted on Nov. 25, Film Showing & Talk about Mental Health	Completed	2026-07-06 15:21:38.057918	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.058179+08	2025-11-18	Central Office	\N	Memorandum	Memo Circular No. 105, Directing All Government Agencies to Support the Observance of the 2025 Drug Abuse Prevention and Control Week	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Caido to organize activity regarding the subjuct
189	25111903	Portal Administrator	Nominees: Suarez, Gunday, Pechon, Madera and Magadan. Nomination Form sent	Completed	2026-07-06 15:21:38.065877	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.066129+08	2025-11-19	Others	ROMO	Memorandum	Request for Nomination of TESDFA Technology Trainers to the Khan Academy (KA) Orientation and Training on KA Teacher Dashboard	\N	For Nomination	\N	\N	Inbound	\N	\N	Caido to facilitate nomination
193	25112801	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.074121	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.074414+08	2025-11-28	Others	PMO	Memorandum	Request of Physical and Financial Performance Report	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Gunday and Abacial to Prepare the document requested
197	25120901	Portal Administrator	Sir NiÃ±o will attend on behalf of Sir Inar who is currently on sick leave	Completed	2026-07-06 15:21:38.081482	\N	Training	127.0.0.1	2026-07-06 15:21:38.081693+08	2025-12-09	Others	PTESDC Bohol	Communication	Notice of Meeting: Provincial TESD Committee Meeting	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Sir NiÃ±o will attend
201	25121201	Portal Administrator	Will attend	Completed	2026-07-06 15:21:38.088325	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.088517+08	2025-12-12	Provincial Office	\N	Office Order	Authority to Attend 2025 Year-End Performance Assessment (YEPA)	\N	For Information	\N	\N	Inbound	\N	\N	All regular staff to attend on this activity
205	25121502	Portal Administrator	Noted	Completed	2026-07-06 15:21:38.094958	\N	Administrative	127.0.0.1	2026-07-06 15:21:38.095167+08	2025-12-15	Jagna LGU	\N	Communication	YEar End Assessment of LGU-Jagna	\N	For Guidance	\N	\N	Inbound	\N	\N	Caido and JOs to attend on this activity
209	25121901	Portal Administrator	Attended	Completed	2026-07-06 15:21:38.101682	\N	Extension/Research	127.0.0.1	2026-07-06 15:21:38.101906+08	2025-12-19	Others	Lonoy Heroes Memorial High School	Communication	Invitation to Serve as Resource Speaker at the Career Guidance Symposium and Culmination	\N	For Appropriate Action	\N	\N	Inbound	\N	\N	Gunday served as the Resource Speaker
\.


--
-- Data for Name: rmt_records; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.rmt_records (id, record_number, title, record_type, record_type_part, record_date, pdf_link, local_file_path, drive_file_id, cabinet_number, shelf_number, keywords, remarks, encoded_by, date_encoded, date_updated) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.roles (role_id, role_name, description) FROM stdin;
1	Admin	Full system access including user and department management.
2	Staff	Can add and update documents.
3	Employee	View-only access to documents.
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (user_id, username, password_hash, full_name, office, email, role, status) FROM stdin;
1	Leils	scrypt:32768:8:1$AAe1jQoQ7fJ2SrAL$84df43d6f95941fe03684d59896da467f2d319319455a584756c319d30caf204b60c54f97f4be78fe63e693c219c8f4dd4d08fd7cc912227396d110763c03aaa	Maria Leilani O. Caido	Administrative	\N	Admin	Active
2	JM	scrypt:32768:8:1$E3SqbFlXukvMbACc$3766efba38f1feaecdc944080c7f964a2e2c8d91a877127f3b24f0f07dfae838f75b70e5e10408ff59852dc747991eb81efd7485aec7b7bd6f1dc4b9a78e7bb2	JMM Abacial	Administrative		Staff	Active
\.


--
-- Name: dept_ref_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dept_ref_id_seq', 8, true);


--
-- Name: dts_docs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dts_docs_id_seq', 210, true);


--
-- Name: dts_history_unique_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dts_history_unique_id_seq', 210, true);


--
-- Name: rmt_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.rmt_records_id_seq', 1, false);


--
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.roles_role_id_seq', 3, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_user_id_seq', 2, true);


--
-- Name: dept_ref dept_ref_dept_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dept_ref
    ADD CONSTRAINT dept_ref_dept_code_key UNIQUE (dept_code);


--
-- Name: dept_ref dept_ref_dept_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dept_ref
    ADD CONSTRAINT dept_ref_dept_name_key UNIQUE (dept_name);


--
-- Name: dept_ref dept_ref_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dept_ref
    ADD CONSTRAINT dept_ref_pkey PRIMARY KEY (id);


--
-- Name: dts_docs dts_docs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dts_docs
    ADD CONSTRAINT dts_docs_pkey PRIMARY KEY (id);


--
-- Name: dts_docs dts_docs_route_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dts_docs
    ADD CONSTRAINT dts_docs_route_number_key UNIQUE (route_number);


--
-- Name: dts_history dts_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dts_history
    ADD CONSTRAINT dts_history_pkey PRIMARY KEY (unique_id);


--
-- Name: rmt_records rmt_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rmt_records
    ADD CONSTRAINT rmt_records_pkey PRIMARY KEY (id);


--
-- Name: rmt_records rmt_records_record_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rmt_records
    ADD CONSTRAINT rmt_records_record_number_key UNIQUE (record_number);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- PostgreSQL database dump complete
--

\unrestrict SjBJecWKCV4FVMhqNcF1Tkhub2Z6hwFXScwXZlRa0XXvcxXgaQR8CUzumzSaniV

