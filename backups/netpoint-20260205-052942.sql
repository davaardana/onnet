--
-- PostgreSQL database dump
--

\restrict QUfiruxAXZ53GJaGa7MxZgiOXkYlYX0B1caGTyAZ6QbYenUGZJDbaKXSTfGBvkX

-- Dumped from database version 15.15
-- Dumped by pg_dump version 15.15

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

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: netpoint_user
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO netpoint_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: netpoint_user
--

CREATE TABLE public.audit_logs (
    id integer NOT NULL,
    user_id integer,
    action character varying(100) NOT NULL,
    resource character varying(100) NOT NULL,
    ip_address text,
    user_agent text,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.audit_logs OWNER TO netpoint_user;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: netpoint_user
--

CREATE SEQUENCE public.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.audit_logs_id_seq OWNER TO netpoint_user;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: netpoint_user
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: buildings; Type: TABLE; Schema: public; Owner: netpoint_user
--

CREATE TABLE public.buildings (
    id integer NOT NULL,
    building_name character varying(255) NOT NULL,
    address text NOT NULL,
    zone_code character varying(10),
    zone_name character varying(100),
    zone_number integer,
    zone_details text,
    status character varying(50) DEFAULT 'active'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    city character varying(100),
    zone character varying(50),
    country character varying(100) DEFAULT 'Indonesia'::character varying
);


ALTER TABLE public.buildings OWNER TO netpoint_user;

--
-- Name: TABLE buildings; Type: COMMENT; Schema: public; Owner: netpoint_user
--

COMMENT ON TABLE public.buildings IS 'List of buildings/locations for network services';


--
-- Name: buildings_id_seq; Type: SEQUENCE; Schema: public; Owner: netpoint_user
--

CREATE SEQUENCE public.buildings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.buildings_id_seq OWNER TO netpoint_user;

--
-- Name: buildings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: netpoint_user
--

ALTER SEQUENCE public.buildings_id_seq OWNED BY public.buildings.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: netpoint_user
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    address text NOT NULL,
    city character varying(100) NOT NULL,
    province character varying(100) NOT NULL,
    is_onnet boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.locations OWNER TO netpoint_user;

--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: netpoint_user
--

CREATE SEQUENCE public.locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.locations_id_seq OWNER TO netpoint_user;

--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: netpoint_user
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: netpoint_user
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer,
    location_id integer,
    tier_id integer,
    location_name character varying(255) NOT NULL,
    status character varying(50) DEFAULT 'pending'::character varying,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.orders OWNER TO netpoint_user;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: netpoint_user
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO netpoint_user;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: netpoint_user
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: price_list; Type: TABLE; Schema: public; Owner: netpoint_user
--

CREATE TABLE public.price_list (
    id integer NOT NULL,
    bandwidth_mbps integer NOT NULL,
    domestic_otc numeric(12,2),
    domestic_mrc_zone1 numeric(12,2),
    domestic_mrc_zone2 numeric(12,2),
    domestic_mrc_zone3 numeric(12,2),
    domestic_mrc_zone4 numeric(12,2),
    intl_otc numeric(12,2),
    intl_mrc_zone1 numeric(12,2),
    intl_mrc_zone2 numeric(12,2),
    intl_mrc_zone3 numeric(12,2),
    intl_mrc_zone4 numeric(12,2),
    dia_otc numeric(12,2),
    dia_mrc numeric(12,2),
    idia_bw integer,
    idia_otc numeric(12,2),
    idia_mrc numeric(12,2),
    year integer DEFAULT 2026,
    status character varying(50) DEFAULT 'active'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.price_list OWNER TO netpoint_user;

--
-- Name: TABLE price_list; Type: COMMENT; Schema: public; Owner: netpoint_user
--

COMMENT ON TABLE public.price_list IS 'Price book for bandwidth services (2026)';


--
-- Name: price_list_id_seq; Type: SEQUENCE; Schema: public; Owner: netpoint_user
--

CREATE SEQUENCE public.price_list_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.price_list_id_seq OWNER TO netpoint_user;

--
-- Name: price_list_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: netpoint_user
--

ALTER SEQUENCE public.price_list_id_seq OWNED BY public.price_list.id;


--
-- Name: pricing_tiers; Type: TABLE; Schema: public; Owner: netpoint_user
--

CREATE TABLE public.pricing_tiers (
    id integer NOT NULL,
    tier_name character varying(100) NOT NULL,
    capacity character varying(50) NOT NULL,
    sla character varying(20) NOT NULL,
    setup_time character varying(50) NOT NULL,
    monthly_price integer,
    features text[],
    is_popular boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.pricing_tiers OWNER TO netpoint_user;

--
-- Name: pricing_tiers_id_seq; Type: SEQUENCE; Schema: public; Owner: netpoint_user
--

CREATE SEQUENCE public.pricing_tiers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pricing_tiers_id_seq OWNER TO netpoint_user;

--
-- Name: pricing_tiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: netpoint_user
--

ALTER SEQUENCE public.pricing_tiers_id_seq OWNED BY public.pricing_tiers.id;


--
-- Name: quotes; Type: TABLE; Schema: public; Owner: netpoint_user
--

CREATE TABLE public.quotes (
    id integer NOT NULL,
    quote_number character varying(50) NOT NULL,
    building_id integer,
    building_name character varying(255),
    bandwidth_mbps integer,
    service_type character varying(50),
    zone integer,
    otc numeric(12,2),
    mrc numeric(12,2),
    total_price numeric(12,2),
    customer_name character varying(255),
    customer_email character varying(255),
    customer_phone character varying(50),
    notes text,
    status character varying(50) DEFAULT 'draft'::character varying,
    created_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.quotes OWNER TO netpoint_user;

--
-- Name: TABLE quotes; Type: COMMENT; Schema: public; Owner: netpoint_user
--

COMMENT ON TABLE public.quotes IS 'Customer quotations with pricing details';


--
-- Name: quotes_id_seq; Type: SEQUENCE; Schema: public; Owner: netpoint_user
--

CREATE SEQUENCE public.quotes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotes_id_seq OWNER TO netpoint_user;

--
-- Name: quotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: netpoint_user
--

ALTER SEQUENCE public.quotes_id_seq OWNED BY public.quotes.id;


--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: netpoint_user
--

CREATE TABLE public.refresh_tokens (
    id integer NOT NULL,
    user_id integer,
    token_hash character varying(128) NOT NULL,
    user_agent text,
    ip_address text,
    expires_at timestamp without time zone NOT NULL,
    revoked_at timestamp without time zone,
    replaced_by_token_hash character varying(128),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.refresh_tokens OWNER TO netpoint_user;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: netpoint_user
--

CREATE SEQUENCE public.refresh_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.refresh_tokens_id_seq OWNER TO netpoint_user;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: netpoint_user
--

ALTER SEQUENCE public.refresh_tokens_id_seq OWNED BY public.refresh_tokens.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: netpoint_user
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(50),
    password character varying(255),
    google_id character varying(255),
    role character varying(20) DEFAULT 'user'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO netpoint_user;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: netpoint_user
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO netpoint_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: netpoint_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: buildings id; Type: DEFAULT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.buildings ALTER COLUMN id SET DEFAULT nextval('public.buildings_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: price_list id; Type: DEFAULT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.price_list ALTER COLUMN id SET DEFAULT nextval('public.price_list_id_seq'::regclass);


--
-- Name: pricing_tiers id; Type: DEFAULT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.pricing_tiers ALTER COLUMN id SET DEFAULT nextval('public.pricing_tiers_id_seq'::regclass);


--
-- Name: quotes id; Type: DEFAULT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.quotes ALTER COLUMN id SET DEFAULT nextval('public.quotes_id_seq'::regclass);


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('public.refresh_tokens_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: netpoint_user
--

COPY public.audit_logs (id, user_id, action, resource, ip_address, user_agent, metadata, created_at) FROM stdin;
1	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-05 05:25:49.66514
2	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-05 05:26:21.784773
3	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-05 05:26:49.436252
4	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-05 05:27:45.761101
5	1	refresh_token	auth	::ffff:172.18.0.1	curl/7.81.0	{"replaced_token_id": 4}	2026-02-05 05:28:58.944142
\.


--
-- Data for Name: buildings; Type: TABLE DATA; Schema: public; Owner: netpoint_user
--

COPY public.buildings (id, building_name, address, zone_code, zone_name, zone_number, zone_details, status, created_at, updated_at, city, zone, country) FROM stdin;
1	AD PREMIER	Jl. TB Simatupang No. I Jakarta Selatan 12550	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
2	AGRO PLAZA	Chase Plaza - 20th Floor, Jl. Jend Sudirman Kav. 21 Jakarta 12920	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
3	AIA CENTRAL	AIA CENTRAL	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
4	ALAMANDA BALI	Jl. Bypass Ngurah Rai Telaga Ayu Kubunesa 2 No. 7 Kedonganan - Bali	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
5	ALAMANDA TOWER	alamanda tower	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
6	ALFAMART MEDAN	Jl. Enggang IV No. 97 Perumnas Mandala Medan - 20226	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
7	ANEKA PAVILLION PONTIANAK	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
8	ANZ TOWER	ANZ Tower	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
9	APARTEMEN MITRA SUNTER	Apartemen mitra s	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
10	APARTEMEN ST MORITZ	Kawasan Residensial dan Komersial The St. Moritz di Kembangan Selatan, Kec. Kembangan, Kota Jakarta Barat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
11	APARTEMEN TELUK INTAN	Tower Topaz Lt. PH No. BB Jl.Teluk Intan Raya Kel. Pejagalan Kec. Penjaringan Jakarta Utara	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
12	APARTEMEN THE LAVANDE RESIDENCE	Jl. Prof. Dr. Soepomo 231, Jakarta Selatan 12830	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
13	APJII BALIKPAPAN	Cyber Building Jl. Kuningan Barat No. 8 Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
14	ASOSIASI PENYELENGGARA JASA INTERNET INDONESIA (APJII)	Cyber Building Jl. Kuningan Barat No. 8 Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
15	ATRIUM MULIA	Jl. HR Rasuna Said Kav. B10-11 Setiabudi Kuningan Jakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
16	ATRIUM SETIABUDI	Jl. HR Rasuna Said Kav. 62 Jakarta 12920	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
17	AYANI MEGAMALL PONTIANAK	Jl. Ahmad Yani Pontianak 78121	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
18	BANDARA SOEKARNO HATTA (GEDUNG POS)	Bandara Soekarno Hatta - Terminal 2F Kedatangan Room F9P67	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
19	BANDARA SOEKARNO HATTA (TERMINAL 1)	Bandara Soekarno Hatta - Terminal 2F Kedatangan Room F9P67	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
20	BANDARA SOEKARNO HATTA (TERMINAL 123)	Bandara Soekarno Hatta - Terminal 2F Kedatangan Room F9P67	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
21	BANDARA SOEKARNO HATTA (TERMINAL 2)	Bandara Soekarno Hatta - Terminal 2F Kedatangan Room F9P67	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
22	BANDARA SOEKARNOHATTA (TERMINAL 3)	Bandara Soekarno Hatta - Terminal 2F Kedatangan Room F9P67	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
23	BANGKA TRADE CENTER	Bangka Trade	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
24	BANK ARTHA GRAHA	Jl. Melawai Raya Blok B III No. 194 Kebayoran Baru - Jakarta Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
25	BANK SUMSEL BABEL	Bank Sumsel Babel	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
26	BDx DC Lintasarta TB Simatupang	Gedung Aplikasinusa Lintasarta Jl. T.B. Simatupang (Kav 10) Jakarta Capital Region, 12430	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
27	BDx DC TB Simatupang	Jl. Lurah Kawi no 1 JAtiluhur Purwakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
28	BDx DRC 2 JAH	Jatiluhur, Kec. Purwakarta, Kabupaten Purwakarta, Jawa Barat 41152	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
29	BDx DRC Jatiluhur	Jln. Lurah Kawi, Purwakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
30	BDx DRC3 Jatiluhur	DRC3 Jatiluhur	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
31	BDx IDC2 KPPTI	KPPTI	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
32	BDx KPPTI	KPPTI	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
33	BDx UIN Walisongo	Jl. Lurah Kawi No 1 jatiluhur Purwakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
34	BELLANOVA COUNTRY MALL	Jl. MH Thamrin No. 8, Bukit Sentul Selatan, Kabupaten Bogor 16810	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
35	BELTWAY OFFICE PARK	Jl. TB Simatupang No. 41 Jakarta 12550	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
36	BERITA SATU PLAZA	Lippo Cyber Park Jl. Boulevard Gajahmada No. B 2058 Kec.Cibodas Kel. Panunggangan Barat Karawaci � Tangerang 15811	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
37	BINTARO JAYA XCHANGE MALL	Bintaro Jaya Xchange Mall CBD Bintaro Jaya Blok O-2Bintaro Jaya Sektor VII Tangerang 15227	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
38	BP BATAM	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
39	BTS JAMES_SITORUS_I SITE ID : 05SDK016	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
40	BTS PLAZA MULIA	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
41	BUARAN PLAZA	Jl. Radin Inten No. I Klender Jakarta Timur	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
42	CBN NUSANTARA	Cyber2 Tower Lt.2 Jl. HR Rasuna Said Blok X-5 No. 13 Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
43	CENTRAL PASAR MEDAN	Jl. Letjen Haryono MT Central Pasar Medan Lt.1 Blok I No. 1 � 2 � 17 � 18 Medan 20212	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
44	CENTRE POINT MEDAN	Mall Centre Point Medan Level 3A Jl. Jawa No. 8 Medan 20213	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
45	CIBINONG CITY MALL	Jl. Tegar Beriman 1 Cibinong Bogor	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
46	CIBIS EIGHT d.h CILANDAK COMMERCIAL ESTATE (CCE)	Jl. Raya Cilandak KKO Jakarta Selatan 12560	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
47	CIBIS NINE	Cibis Nine	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
48	CIBIS PARK	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
49	CITRALAND SURABAYA	Office Park # 1 Citraland Utama Rd Citraland Surabaya 60219	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
50	CITY CENTER PALEMBANG	Jl. Sudirman No. 57 Palembang 30125	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
51	CNDC NEUCENTRIX TELKOM KARET TENGSIN	DC Neucentrix Karet Tengsin	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
52	CNDC TELKOM, NeuCentrix Medan	Jl. Japati 1 Bandung 40133	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
53	COWELL TOWER D.H GRAHA ATRIUM	Cowell Tower, Jl. Senen Raya, RW.2, Senen, Central Jakarta City, Jakarta, Indonesia	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
54	CSM CIKARANG	Jl. Tebet Timur Raya No. 53 Jakarta 12820	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
55	CYBER	Jl. Kuningan Barat No. 8 - Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
56	CYBER 2	Jalan HR. Rasuna Said Blok X-5 no. 13, Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
57	CYBER CSF / CYBER 3	Jl. Kuningan Barat No. 8 - Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
58	CYBER DATA CENTRE INDONESIA	Jl. Kuningan Barat No. 8 - Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
59	DARMAWANGSA SQUARE	Jl. Dharmawangsa 6-9 Ground Level Dharmawangsa Square Jakarta Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
60	DATA CENTER COLLEGA	Talavera Office Park lantai 6-7 Jl.Tb Simatupang Kav. 22-26 Cilandak Jakarta 12430	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
61	DATA CENTER DCI INDONESIA (EQUITY TOWER)	Kawasan Industri MM2100 Jl. Irian Cibitung Cikarang 17530	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
62	DATA CENTER DTP DI GEDUNG TIFA	Gedung Cyber Lt. 9 Jl. Kuningan Barat No. 8Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
63	DATA CENTER ELITERY	Jl. Raya Padjajaran No. 17 Bogor 16142	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
64	DATA CENTER FAASRI	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
65	DATA CENTER INFOCOM MANDIRI MEDAN	UNILAND TOWER West Lt 4 JL. MT HARYONO NO. 1A MEDAN	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
66	DATA CENTER LINTAS ARTA	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
67	DATA CENTER TEKNOVATUS	Jl. Pahlawan Seribu Lot 12A BSD CBD Tangerang	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
68	DATA CENTER XL - RUNGKUT SURABAYA	Jl. DR Ide Anak Agung Gde Agung Lot E4 � 7 No. 1 Kawasan Mega Kuningan Jakarta 12950 - Indonesia	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
69	DC ELITERY	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
70	DC INTERLINK	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
71	DC XL Rungkut Surabaya	Jl. Raya Rungkut No.15A, Kali Rungkut, Kec. Rungkut, Kota SBY, Jawa Timur 60293	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
72	DEA TOWER D.H MENARA DEA	Dea Tower	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
73	DEUTSCHE BANK	Deutsche Bank Building, Jalan Imam Bonjol, RT.1/RW.5, Menteng, Central Jakarta City, Jakarta, Indonesia	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
74	DIPO TOWER	Jl. Jend Gatot Subroto Kav. 51-52 Jakarta 10260	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
75	EDGE	Jalan Kuningan Barat Raya No. 59, Mampang Prapatan, Jakarta Selatan, Indonesia 12910	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
76	EJIP (EAST JAKARTA INDUSTRIAL PARK)	Plot 3A Cikarang Selatan - Bekasi 17550	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
77	EMA - Obelisk	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
78	EPID - OBELISK	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
79	GEDUNG 46 ABDUL MUIS	Jl. Abdul Muis No. 46 Jakarta Pusat 10160	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
80	GEDUNG ARIOBIMO	Jl. HR Rasuna Said Blok X-2 No. 5 Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
81	GEDUNG B&G TOWER	Jl. Putri Hijau No. 10 Medan 20111	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
82	GEDUNG BBC	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
83	GEDUNG BRI 2	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
84	GEDUNG BUMI MANDIRI TOWER II SURABAYA D.H GEDUNG BUMI MANDIRI SURABAYA	Bumi Mandiri	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
85	GEDUNG CIMB NIAGA CIKARANG	Jl. MH Thamrin Kav. 107 Lippo Cikarang 17550	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
86	GEDUNG EIGHTY EIGHT	Jl. Casablanca Kav. 88 Jakarta Selatan 12870	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
87	GEDUNG INDOSURYA LIFE CENTER	Jalan M.H. Thamrin Kav.10, Building:Indosurya Life Center, 10th Floor, Server Room, Jakarta pusat - 10310, Indonesia	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
88	GEDUNG KHARISMA	Gedung kharisma	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
89	GEDUNG KRAKATAU STEEL D.H WISMA BAJA	Jl. Gatot Subroto Kav. 54 Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
90	GEDUNG MEDAN PEMUDA SURABAYA	Gedung Medan Pemuda Lt. 4 Jl. Pemuda No. 27 - 31 Surabaya - 60271	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
91	GEDUNG MENARA SUARA MERDEKA	Jl. MT Haryono 579A Semarang	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
92	GEDUNG PEMUDA	Gedung Pemuda Lt.2 Jl. Pemuda No. 66, Jakarta Timur 13220	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
93	GEDUNG PLAZA UOB	UOB Plaza Jl. MH Thamrin No. 10 Jakarta 10230	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
94	GEDUNG TITAN CENTRE	Titan Center	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
95	GRAHA AKTIVA	Graha Aktiva	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
96	GRAHA BUMI SURABAYA & HOTEL BUMI SURABAYA	Jl. Jend Basuki Rakhmat 106-128 Surabaya 60271	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
97	GRAHA CEMPAKA MAS	Graha Cempaka Mas	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
98	GRAHA CIMB NIAGA	Graha CIMB	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
99	GRAHA FAMILY VIEW (SPAZIO)	Jl. Golf Famili Timur II Blok E - Vertikal Surabaya 60226	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
100	GRAHA INTI FAUZI	Jl. Buncit Raya no.22, Jakarta 12510	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
101	GRAHA IRAMA	Graha Irama	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
102	GRAHA KENCANA	Jl. Raya Perjuangan No. 88 Blok GK RT 4 RW 010 Kebon Jeruk Jakarta Barat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
103	GRAHA KIRANA	Jl. Kirana Avenue No. 2 Kelapa Gading Timur Kelapa Gading Jakarta 14240	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
104	GRAHA MANDIRI/PLAZA BBD	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
105	GRAHA MOBISEL	Graha Mobisel Jl. Mampang Prapatan Raya No. 139 Jakarta 12790	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
106	GRAHA MULTIKA	Gedung Multika Jl. Mampang Prapatan Raya No. 71-73 Jakarta 12790	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
107	GRAHA PACIFIC	Graha Pacific	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
108	GRAHA PENA BATAM	Graha Pena Batam	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
109	GRAHA PENA JAKARTA	Gedung Graha Pena lantai 11 Jl. Raya Kebayoran Lama No. 12 Jakarta Selatan12210	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
110	GRAHA PENA JAWA POS	Graha Pena Jawa Pos	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
111	GRAHA PENA MAKASSAR	Graha Pena Makassar	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
112	GRAHA POS INDONESIA	Graha Pos Indonesia Lt.6 Jl. Banda No.30 Bandung 40115	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
113	GRAHA PRATAMA	Jl. MT Haryono Kav. 15 Jakarta 12810	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
114	GRAHA REKSO OFFICE TOWER	Jl. Boulevard Artha Gading Kav. A1 Kelapa Gading Jakarta Utara	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
115	GRHA BINTANG	grha bintang	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
116	GRHA PERTAMINA	Grha Pertamina, Jl. Medan Merdeka Timur No 10 RT 02, RW 01 , Kec. Gambir, Jakarta Pusat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
117	HARCO MANGGA2	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
118	HOTEL GOLDEN SKY CONDOMMINIUM	Jl. Taman Pluit Kencana Selatan No.48, RT.4/RW.6, Pluit, Kec. Penjaringan, Kota Jkt Utara, Daerah Khusus Ibukota Jakarta 14450	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
119	HOTEL KARTIKA	Jl. Jendral Gatot Subroto Kav. 18-20 Setiabudi Jakarta 12930	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
120	HYPERMART BINJAI SUPERMALL	Jl. Soekarno Hatta No. 14 Binjai 20731	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
121	HYPERMART CENTRAL PLAZA LAMPUNG	Jl. Raden Ajeng Kartini No. 21 Bandar Lampung - Lampung	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
122	HYPERMART CIMANGGIS SQUARE	Jl. Raya Bogor KM 29 (Hypermart Cimanggis) Depok - Jawa Barat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
123	HYPERMART CITYMALL BATURAJA	Jl. Ahmad Yani Kelurahan Tanjung Baru Kecamatan Baturaja Timur Kabupaten Ogan Komering Ulu Sumatera Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
124	HYPERMART DEPOK TOWN SQUARE	Jl. Margonda Raya No. 1 Pondok Cina Beji - Depok 16424	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
125	HYPERMART GRAND MALL BEKASI	Jl. Jendral Gatot Subroto Kav. 35-36 Jakarta - 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
126	HYPERMART MALL CIPUTRA CIBUBUR	Jl. Raya Alternatif Cibubur - Cileungsi Km4 Bekasi 17435	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
127	HYPERMART MAYOFIELD CILEGON	Developer (Supermall Karawang - Cilegon) APL Tower Central Park Lt. 7, T6 Jl. Let Jend S. Parman Kav.28 Jakarta Barat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
128	HYPERMART SERANG	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
129	HYPERMART SOLO SQUARE	Jl. Slamet Riyadi No. 451-455 Surakarta 57145	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
130	IDC BATAM	Sumatera Cytec Building Lt.4 Engku Putri Street Kav. 1 Batam Center - Batam 29461	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
131	IDC BOSOA MAKASAR	Menara Bosowa 6th Floor Jl. Jend. Sudirman No. 5, Pisang Utara, Ujung Pandang, Kota Makassar, Sulawesi Selatan 90113	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
132	IDC CYBER SATU	Cyber Building Lt.7 Jl. Kuningan Barat No. 8 Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
133	IDC DUREN TIGA	Gedung IDC 3D Jl. Duren Tiga Raya No. 7H Jakarta 12760	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
134	INDOFOOD TOWER	Jl. Jend. Sudirman No.Kav. 76-78, RT.3/RW.3, Kuningan, Setia Budi, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12910	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
135	INTILAND TOWER	Jl. Panglima Sudirman 101-103 Surabaya 60271	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
136	INTILAND TOWER D.H WISMA DHARMALA SAKTI	Jl. Panglima Sudirman 101-103 Surabaya 60271	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
137	ITC BSD	Gedung ITC BSD P2 floor , Jl. Pahlawan seribu Ta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
138	ITC DEPOK	Jl. Margonda Raya No. 56 Depok 16431	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
139	ITC MANGGA DUA	ITC Mangga Dua 6th Floor Jl.Mangga Dua Raya Jakarta 14430	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
140	ITC ROXY MAS	ITC Roxy Mas Lt.5 Jl. Hasyim Ashari 125 - Jakarta 10150	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
141	JAKARTA INDUSTRIAL ESTATE PULOGADUNG (JIEP)	Kawasan Industri	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
142	JOHAR PLAZA	Jl. Diponegoro No. 66 Blok B-7 Jember - Jawa Timur	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
143	KALIBATA CITY APARTMENT	Mediterania Garden Residences I Tower A Lt.2 Jl. Tanjung Duren Raya Kav.5-9 Grogol Petamburan Jakarta Barat 11470	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
144	KARAWANG INTERNATIONAL INDUSTRIAL CITY (KIIC)	Karawang Intern	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
145	KARTINI RESIDENCES	Perkantoran Permata Senayan Blok C1-2 Jl.Tentara Pelajar Grogol Jakarta Selatan 12210	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
146	KAWASAN BERIKAT NUSANTARA	Jl. Raya Cakung CilincingTanjung Priok Jakarta 14140	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
147	KAWASAN CAMMO INDUSTRIAL PARK	Jl. Letjen Soeprapto Kawasan Industrial Cammo Batam Centre	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
148	KAWASAN INDUSTRI INDOTAISEI	Kawasan Industri Indotaisei, Sektor IA, Blok B, Kota Bukit Indah, Desa Kalihurip, Cikampek, Karawang, Jawa Barat 41373	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
149	KAWASAN INDUSTRI MAKASSAR (KIMA)	Jl. Perintis Kemerdekaan KM 15 Daya Makassar Sulawesi Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
150	KAWASAN INDUSTRI MASPION	Jl. Kembang Jepun 38-40 Surabaya	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
151	KAWASAN INDUSTRI MITRAKARAWANG (KIM)	Jakarta Representative Office: IMORA BUILDING 4th Fl JL. P. Jayakarta No.50 Jakarta 10730 |Site Office Kawasan Industri Mitrakarawang Desa Parungmulya, Kecamatan Ciampel Kabupaten Karawang Pr	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
152	KAWASAN INDUSTRI MM2100	Jl. Sumatera Kawasan Industri MM2100 Cikarang Barat Bekasi	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
153	KAWASAN INDUSTRI NGORO (NGORO INDUSTRIAL PERSADA)	Gedung Spazio Lt.8 Komplek Graha Festival Kav. 3 Jl. Mayjend Yono Soewoyo Surabaya	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
154	KAWASAN INDUSTRI RUNGKUT SURABAYA (SIER)	Jalan Rungkut Industri Raya 10 Surabaya	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
155	KAWASAN INDUSTRI SURYACIPTA	Jl. Surya Lestari Kav. C-3 Karawang 41361	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
156	KAWASAN KOTA BUKIT INDAH INDUSTRIAL CITY (KAWASAN KBI)	Wisma Indocement Lt.12 Jl. Jend. Sudirman Kav. 70-71 - Jakarta 12910	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
157	KEMANG VILLAGE	Komplek Residensial dan Komersial The Kemang Village Jl. Pangeran Antasari No.36, RT.14/RW.5, Bangka, Kec. Mampang Prpt., Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12150	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
158	KERETA API INDONESIA AREA DAOP 8 SURABAYA	Jl. Gubeng Masjid No. 1 Surabaya 60131	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
159	KIRANA BOUTIQUE OFFICE	Kirana boutique	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
160	KIRANA THREE OFFICE	Jl. Kirana Avenue No. 2 Kelapa Gading Timur Jakarta 14240	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
161	KIRANA TWO OFFICE TOWER	Jl. Boulevard Timur No. 88 Kelapa Gading - Jakarta Utara	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
162	KOPKARWIPI	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
163	LAMONGAN SHOREBASE	Jl. Raya Daendels KM 64-65 Paciran Lamongan Jawa Timur	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
164	LANDMARK	Jl. Jend. Sudirman No. 1 - Jakarta Selatan 12910	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
165	LIPPO KUNINGAN	Gedung Berita Satu Plaza Lt.7 Jl. Jendral Gatot Subroto Kav. 35-36Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
166	LIPPO MALL PURI	Gedung Berita Satu Plaza Lt.7 Jl. Jendral Gatot Subroto Kav. 35-36Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
167	LIPPO PLAZA JAMBI	Gedung Berita Satu Plaza Lt.7 Jl. Jendral Gatot Subroto Kav. 35-36Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
168	LIPPO PLAZA JEMBER	Gedung Berita Satu Plaza Lt.7 Jl. Jendral Gatot Subroto Kav. 35-36Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
169	LIPPO PLAZA JOGJA	Gedung Berita Satu Plaza Lt.7 Jl. Jendral Gatot Subroto Kav. 35-36Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
170	LIPPO PLAZA KENDARI	Gedung Berita Satu Plaza Lt.7 Jl. Jendral Gatot Subroto Kav. 35-36Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
171	LIPPO PLAZA KUPANG	Gedung Berita Satu Plaza Lt.7 Jl. Jendral Gatot Subroto Kav. 35-36Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
172	MAC SARANA DJAYA	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
173	MAL CIPUTRA CIBUBUR	Jl. Raya Alternatif Cibubur - Cileungsi Km4 Bekasi 17435	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
174	MAL KELAPA GADING	Mal kelapa	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
175	MALL ARTHA GADING	Jl. Artha Gading Selatan No. 1 Jakarta Utara 14240	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
176	MALL MANGGA DUA	Gedung Mal Mangga Dua Lt.5 Jl. Arteri Mangga Dua Raya Jakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
177	MALL PURI INDAH	Jl. Puri AgungPuri Indah Jakarta Barat 11610	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
178	MALL TAMAN ANGGREK	Mall Taman Anggrek Management Office Lt.5 Jl. Let Jend SParman Kav. 21 Jakarta 11460	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
179	MALL WTC MATAHARI SERPONG	Jl. Raya Serpong No. 39 Tangerang Banten 15326	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
180	MANDIRI BUILDING (MEDAN)	Jl. Raya Serpong No. 39 Tangerang Banten 15326	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
181	MANGGA DUA SQUARE	Ruko Bintaro 8 Office Jl. Jombang Raya No. 8 Blok L-M RT 007/002 Pondok Pucung, Pondok Aren - Tangerang Selatan 15229	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
182	MARUNDA CENTER	Graha Kencana Blok CO Jl. Raya Perjuangan Kav. 88 Kebon Jeruk Jakarta Barat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
183	MAYAPADA TOWER I	Mayapada Tower 5th Floor Jl. Jend. Sudirman Kav. 28 - Jakarta 12920	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
184	MAYAPADA TOWER II	Jl. Jend Sudirman Kav. 27 Jakarta 12920	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
185	MEDAN FAIR PLAZA	Lippo Cyber Park Jl. Boulevard Gajahmada No. B 2058 Kec. Cibodas Kel. Panunggangan Barat Karawaci � Tangerang 15811	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
186	MEDAN MALL	Gedung Medan Mall Medan � Sumatera Utara	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
187	MEGA GLODOK KEMAYORAN	Jl. Angkasa Kav. B6 Kota Baru Bandar Kemayoran Jakarta Pusat 10610 (MGK Kemayoran)	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
188	MEGA MALL MANADO	Jl. Pierre Tendean Boulevard Manado 95111 Sulawesi Utara	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
189	MEGA PLAZA BUILDING	Lantai 12, Jl. Hr Rasuna Said Kav C-3, Setiabudi, Jakarta Selatan, Indonesia 12920	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
190	MEGASARI MAKMUR	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
191	MENARA ANTAM SEJAHTERA	Jl. Letjen TB Simatupang No. 1 RT/ RW 10/04 Tanjung Barat Jagakarsa Jakarta Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
192	MENARA BATAVIA	Jl. KH Mas Mansyur Kav. 126 Jakarta 10220	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
193	MENARA BIDAKARA 2	Jl. Jend Gatot Subroto Kav. 71-73 Pancoran Jakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
194	MENARA BRI BANDUNG	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
195	MENARA BTPN	Jl. DR Ide Anak Agung Gde Agung Kav. 5.5 - 5.6 Kawasan Mega Kuningan Jakarta Selatan 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
196	MENARA CAKRAWALA	Jl. MH Thamrin No. 9 Jakarta Pusat 10340	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
197	MENARA CITIBANK	Jl. Metro Pondok Indah Kav. II BA No. 2 Jakarta 12310	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
198	MENARA CITICON	JL Letjen S Parman, Kavling 72, Slipi, Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota, Jakarta, 11480, IDN	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
199	MENARA GLOBAL	Jl. Jend Gatot Subroto Kav. 27 Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
200	MENARA IMPERIUM	Jl. HR Rasuna Said Kav. 1 RW.6 Guntur Setiabudi Kota Jakarta Selatan Daerah Khusus Ibukota Jakarta 12980	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
201	MENARA JAMSOSTEK	Menara Jamsostek Selatan Lt. 24 Jl. Jend. Gatot Subroto No. 38 RT 6 / RW 1 Kuningan Barat 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
202	MENARA KUNINGAN	Jl. HR Rasuna Said Blok X-7 Kav. 5 Jakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
203	MENARA MANDIRI 2	JL. JEND SOEDIRMAN KAV. 54-55 JAKARTA 12190	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
204	MENARA MERDEKA	Jalan Budi Kemuliaan I no 2 Gambir - Jakarta Pusat 10110	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
205	MENARA MULIA	Jl. Jend. Gatot Subroto Kav. 9-11 Jakarta 12930	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
206	MENARA PRIMA	Menara Prima	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
207	MENARA RAJAWALI	Menara Rajawali	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
208	MENARA STANDARD CHARTERED D.H MENARA SATRIO	Jl. Prof. Dr Satrio No. 164 Jakarta 12930	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
209	MENARA THAMRIN	Jl. MH Thamrin Kav. 3 Jakarta 10250	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
210	METRO CIPULIR	Wisma Slipi Lt.11 Jl.Let.S.Parman Kav 12 Jakarta Barat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
211	METRO PASAR BARU	Metro Pasar Baru	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
212	METROPOLITAN MALL CILEUNGSI (METLAND)	Gedung Metropolitan Mall Cileungsi Jl. Taman Metro Raya Cileungsi Bogor 16820	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
213	Miratel (Titan)	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
214	MITRATEL	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
215	MITRATEL - NON TITAN	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
216	MITRATEL - TITAN	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
217	Mitratel (Titan)	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
218	MNC TOWER (BIMANTARA)	Komp. Rukan Permata Senayan Blok A32 Jl. Tentara Pelajar Jakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
219	MORATEL GRHA 9	Grha 9, Jalan Panataran No.9 Proklamasi Jakarta 10320	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
220	MULIA BUSINESS PARK D.H SIEMENS BUSINESS PARK	Jl. Let. Jend. MT HaryoNo Kav. 58-60 Pancoran Jakarta 12780	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
221	NAP INFO	Suite 101 AB Anex Building Plaza kuningan Jl. HR Rasuna Said Kav. C11-14 Jakarta 12940	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
222	NDC JATINEGARA	Jl. Jatinegara Barat No.44 Jakarta Timur	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
223	NIX DATA CENTER BALI	NIX Data Center Bali Jl. Gatot Subroto Barat No. 333 Denpasar Barat Bali 80117	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
224	NOBLE HOUSE	Jl. Dr Ide Anak Agung Gde Agung Kav. E 4.2 No. 2 Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
225	OFFICE 8	Office 8 Building 29th Floor (SCBD) Lot 28, JL Jenderal Sudirman, Senayan, Kebayoran Baru, Jakarta Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
226	OFFICE TOWER	Office Tower Lt 7 Unit 11 Grand Sudirman Balikpapan 76113	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
227	Intiland Tower Surabaya	Intiland Tower 3rd Floor Jl. Panglima Sudirman 101-103 - Surabaya 60271	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
228	PACIFIC BUILDING	Jl. Laksda Adisucio No. 157 Yogyakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
229	PALMA TOWER	Jl. RA Kartini II-S Kav. 6 Sektor II Kec. Kebayoran Lama Kel. Pondok Pinang Jakarta Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
230	PARIS VAN JAVA	l. Sukajadi no.131-139, Bandung-Jawa Barat 40162	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
231	PASAR ATUM SURABAYA	Jl. Bunguran 45 Surabaya 60161	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
232	PERKANTORAN HIJAU ARKADIA (TOWER B)	Perkantoran Hijau Arkadia Estate Management Office 2nd Floor Jl. Let Jend TB Simatupang Kav. 88 Jakarta 12520	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
233	PERKANTORAN HIJAU ARKADIA (TOWER C)	Perkantoran Hijau Arkadia Estate Management Office 2nd Floor Jl. Let Jend TB Simatupang Kav. 88 Jakarta 12520	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
234	PERKANTORAN HIJAU ARKADIA (TOWER E)	Perkantoran Hijau Arkadia Estate Management Office 2nd Floor Jl. Let Jend TB Simatupang Kav. 88 Jakarta 12520	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
235	PERKANTORAN HIJAU ARKADIA (TOWER F)	Perkantoran Hijau Arkadia Estate Management Office 2nd Floor Jl. Let Jend TB Simatupang Kav. 88 Jakarta 12520	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
236	PERKANTORAN HIJAU ARKADIA (TOWER G)	Perkantoran Hijau Arkadia Estate Management Office 2nd Floor Jl. Let Jend TB Simatupang Kav. 88 Jakarta 12520	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
237	PLAZA 89	Jl. HR Rasuna Said Kav. X-7 No. 6 Jakarta 12940	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
238	PLAZA AMINTA	Jl. Let. Jend TB Simatupang Kav. 10 Jakarta Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
239	PLAZA BANK INDEX D.H PLAZA PERMATA	Jl. MH Thamrin No. 57 - Jakarta Pusat 10350	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
240	PLAZA BRI II	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
241	PLAZA BRI SURABAYA	Jl. Basuki Rahmat No. 122 - 138, Surabaya - Jawa Timur	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
242	PLAZA GAJAH MADA	Lippo Cyber Park Jl. Boulevard Gajahmada No. B 2058 Kec. Cibodas Kel. Panunggangan Barat Karawaci � Tangerang 15811	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
243	PLAZA KALIBATA	Plaza Kalibata Lt. UG Jl. Raya Kalibata RT 3/ RW 2 Rawajati Pancoran Jakarta Selatan 12750	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
244	PLAZA KUNINGAN	Plant Building Jl. HR Rasuna Said Kav. C 11-14 Karet Setiabudi Jakarta Selatan 12940	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
245	PLAZA MADIUN	Lippo Cyber Park Jl. Boulevard Gajahmada No. B 2058 Kec. Cibodas Kel. Panunggangan Barat Karawaci � Tangerang 15811	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
246	PLAZA MASPION	Jl. Gunung Sahari Raya Kav. 18 Jakarta Utara 14420	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
247	PONDOK INDAH OFFICE TOWER D.H WISMA PONDOK INDAH 1	Jl. Sultan Iskandar Muda Pondok Indah Kav. V-TA - Jakarta Selatan 12310	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
248	PONDOK INDAH OFFICE TOWER D.H WISMA PONDOK INDAH 3	Jl. Sultan Iskandar Muda Pondok Indah Kav. V-TA - Jakarta Selatan 12310	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
249	PROTELINDO	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
250	PROTELINDO - NON TITAN	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
251	PROTELINDO - TITAN	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
252	PROTELINDO (TITAN)	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
253	PUSAT GROSIR CILILITAN (PGC)	Jl. Meyjen Sutoyo No. 76 Cililitan Kramat Jati - Jakarta Timur	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
254	PUSAT GROSIR METRO TANAH ABANG	Pusat Grosir Metro Tanah Abang Kp. Bali, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10250	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
255	PUSAT GROSIR PASAR PAGI MANGGA DUA	Gedung Pusat Grosir Pasar Pagi Mangga Dua Lt. 7 Blok D Jl. Mangga 2 Raya Jakarta Utara - 14430	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
256	PUSAT GROSIR SENEN	Jl. St Senen RW 3 Senen Jakarta 10410	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
257	PUSAT GROSIR TANAH ABANG	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
258	RAFFLES RESIDENCE JAKARTA	Residential Apartment - Unit 37 D (37th floor) Raffles Residences, JL. Prof. Dr. Satrio Kav. 3-5, Jakarta 12940.	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
259	RATU PLAZA	RATU PLAZA	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
260	RATU PRABU 2	Gedung Ratu Prabu 2 Jl. TB Simatupang Kav. 1B Jakarta - 12560	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
261	RUKO KANTOR TAMAN A9	Kantor Taman A9 unit C5 C6 dan C7 Jl. DR Ide Anak Agung Gde Agung Kawasan Mega Kuningan Lot 8.9/9 Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
262	RUKO RICH PALACE	Jl. Mayjend Sungkono, Dukuh Pakis, Surabaya, Indonesia 60225	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
263	RUMAH INDONET D.H. INDONET	Jl. Rempoa Raya No. 11 Ciputat Tangerang Selatan Banten 15412	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
264	RUMAH SAKIT JAKARTA	Jl. Garnisun No. 1 Jenderal Sudirman Jakarta Selatan 12930	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
265	SAMPOERNA STRATEGIC SQUARE D.H. SUDIRMAN SQUARE	Jl. Jend Sudirman Kav. 45-46 Jakarta 12930	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
266	SAMUDERA DATA INDONESIA	Jl. Kuningan Barat No. 8 Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
267	SASTRA GRAHA	Jl. Raya Perjuangan No. 21 Jakarta 11530	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
268	Sentra Grosir Cikarang	Jl. R.E. Martadinata Kel. Cikarang Kota, Kec. Cikarang Utara, Bekasi	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
269	SENTRAL SENAYAN I & II	Jl. Asia Afrika No. 8 Gelora Bung Karno - Senayan Jakarta Pusat 10270	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
270	SENTRAL SENAYAN III	Jl. Asia Afrika No. 8 Gelora Bung Karno - Senayan Jakarta Pusat 10270	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
271	SGC CIKARANG	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
272	SIGMA SENTUL	Jl. Kapt Soebijanto DJ, Bumi Serpong Damai, Tangerang Selatan, 15321	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
273	SIGMA SERPONG D/H GERMAN CENTER INDONESIA	Jl. Kapt Soebijanto DJ, Bumi Serpong Damai, Tangerang Selatan, 15321	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
274	SIGMA SURABAYA	Jl. Kapt Soebijanto DJ, Bumi Serpong Damai, Tangerang Selatan, 15321	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
275	SINARMAS LAND PLAZA D.H. PLAZA BII	Jl. MH Thamrin No. 51 Jakarta 10350	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
276	SINARMAS LAND PLAZA MEDAN	Jl. Diponegoro No. 18 Medan 20152	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
277	SME TOWER BUILDING	Jl. Jend. Gatot Subroto Kav. 94 Jakarta Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
278	SONA TOPAS TOWER	Jl. Jend. Sudirman Kav. 26 Jakarta 12920	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
279	ST MORITZ MALL	Kawasan Residensial dan Komersial The St. Moritz di Kembangan Selatan, Kec. Kembangan, Kota Jakarta Barat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
280	ST MORITZ OFFICE	Kawasan Residensial dan Komersial The St. Moritz di Kembangan Selatan, Kec. Kembangan, Kota Jakarta Barat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
281	STP	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
282	SUMATERA EXPO	Jl. Engku Putri Kav. 1 Batam Center Kec.Batam Kota - Kota Batam	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
283	SUMMITMAS 2	Jl. Jend. Sudirman Kav. 61-62 Jakarta 12190	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
284	TALAVERA SUITE	Jl. TB Simatupang Kav. 22-26 Jakarta 12430	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
285	TANGERANG CITY MALL	Jl. Jend. Sudirman No. 1 Cikokol - Tangerang 15117	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
286	TELKOMSAT PARUNG	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
287	TEMPO PAVILION 1 & 2	Tampo pavilion	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
288	TEMPO SCAN TOWER	Jl. HR Rasuna Said Kav. 10-11 Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
289	THE BELLEZA SHOPPING ARCADE	The Belleza Shopping Arcade 1st Floor No. 61 Jl.Letjend Soepona No. 34 Arteri Permata Hijau Jakarta 12210	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
290	THE CITY CENTER BATAVIA TOWER ONE	Jl. KH Mas Mansyur Kav. 126 Jakarta Pusat 10220	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
291	THE EAST TOWER	Jl. Dr Ide Anak Agung Gde Agung Kav. E.3.2 No. 1 Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
292	THE ENERGY	SCBD lot 11 A Jl. Jend. Sudirman Kav. 52-53 - Jakarta 12190	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
293	THE VIDA BUILDING	Jl. Raya Perjuangan No. 8 Jakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
294	THEEMATIC MAJALAYA	Jl. Anyar, Majasetra, Kec. Majalaya, Bandung, Jawa Barat 40382	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
295	TLP MITRATEL	Telkom Landmark Tower (TLT) Lt. 27, Jl. Jend. Gatot Subroto Kav. 52	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
296	TLP Obelisk CMI	TCC Batavia Tower One 16th & 19th Floor Jl. KH. Mas Mansyur Kav. 126 Jakarta Pusat DKI Jakarta 10220 Indonesia	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
297	TLP OBELISK EMA	EPID MENARA ASSETCO, PT TCC Batavia Tower One Lantai 16 DKI Jakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
298	TLP PROTELINDO	Jl. Tanjung Karang No. 11 Desa Jati Kulon Jawa Tengah	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
299	TOL JASA MARGA	Jasamarga Cabang Tol Jagorawi Plaza Tol Taman Mini Indonesia Indah Jakarta 13550	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
300	TOTAL BUILDING	Total Building, Ground Floor. Jl. Letjen S. Parman Kav. 106 A, Tomang, Jakarta Barat 11440	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
301	TOWER BERSAMA GROUP (TBG)	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
302	TOWER MANAGEMENT GROUP (TMG)	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
303	TRIHAMAS BUILDING	Jl. TB Simatupang Kav. 11 Jakarta Selatan 12530	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
304	TRILLIUM OFFICE & RESIDENCE	Jl. Pemuda No. 108-116 Surabaya 60217	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
305	UNIPLAZA BUILDING (UNILAND)	Jl. Letjend MT Haryono No. A-1 Medan 20231	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
306	USAHA GEDUNG MANDIRI D.H USAHA GEDUNG BANK DAGANG NEGARA	Jl. Imam Bonjol No. 7 Medan 20112	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
307	VENTURA BUILDING	Ventura Building Jl. RA Kartini 26 Jakarta 12430	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
308	VINILON BUILDING	Jl. Raden Saleh No. 13-17 Jakarta Pusat 10430	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
309	WISMA 46 KOTA BNI	Jl. Jend. Sudirman Kav. 1 Jakarta 10220	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
310	WISMA 77	Jl. S Parman Kav. 77 Slipi Jakarta Barat 11410	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
311	WISMA ANTARA	Jl. Medan Merdeka Selatan No. 17 Jakarta Pusat 10110	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
312	WISMA BAKRIE 2	Wisma Bakrie 2, Kav.B-2 Jalan HR. Rasuna Said 12920	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
313	WISMA BARITO PACIFIC	Jl. Let Jend sParman Kav. 62 -63 Slipi Jakarta 11410	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
314	WISMA BCA	Jl. Grand Boulevard BSD Green Office Park BSD City Tangerang 15345	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
315	WISMA BSG	Jl. Abdul Muis No. 40 Jakarta 10160	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
316	WISMA BUMIPUTERA D.H. GRAHA BUMIPUTERA	Jl. Asia Afrika No. 141-149 Bandung 40112	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
317	WISMA EKA JIWA	Kantor Pengelola Wisma Eka Jiwa Lt.2 201 Arteri Mangga 2 Jakarta 10730	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
318	WISMA GADING PERMAI	Jl. Raya Boulevard Blok CN 1 Kelapa Gading Jakarta 14240	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
319	WISMA GKBI	Jl. Jend. Sudirman No. 28 Bendungan Hilir Tanah Abang - Jakarta 10210	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
320	WISMA HAYAM WURUK	Wisma Hayam Wuruk Suite 520 5th Floor Jl. Hayam Wuruk No. 8 - Jakarta 10120	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
321	WISMA HSBC BANDUNG	Jl. Asia Afrika No. 116 Bandung 40261	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
322	WISMA HSBC SEMARANG	Wisma HSBC	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
323	WISMA INDOMOBIL	Gedung Wisma Indomobil 1 Jl. MT Haryono Kav. 8 Jakarta 13330	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
324	WISMA INDOVISION	Jl. Raya Panjang Blok Z/III Kebon Jeruk Jakarta Barat 11520	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
325	WISMA KAWASAN INDUSTRI MEDAN	Jl. Pulau Batam No. 1 Kompleks KIM Tahap II Medan Sumatera Utara	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
326	WISMA KEIAI D.H WISMA KYOEI PRINCE	Jl. Jend. Sudirman Kav. 3 Jakarta 10220	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
327	WISMA KODEL	Wisma Kodel Lt. 9 Jl. HR Rasuna Said Kav. B-4 Jakarta 12910	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
328	WISMA MULIA	Jl. JendGatot Subroto No. 42 Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
329	WISMA MULIA 2	0	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
330	WISMA NUSANTARA	Gedung annex Lt dasar jl. M.H Thamrin No. 59	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
331	WISMA STACO	Wisma Staco	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
332	WISMA TAMARA	Jl. Jend. Sudirman Kav. 24, Sudirman, Jakarta Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
333	WORLD TRADE CENTRE /WTC 3	Jl. Jend Sudirman Kav. 29-31 Jakarta 12926	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
334	WORLD TRADE CENTRE/ WTC 5 D.H WISMA METROPOLITAN I	Jl. Jend Sudirman Kav. 29-31 Jakarta 12926	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
335	WORLD TRADE CENTRE/ WTC 6 D.H WISMA METROPOLITAN II	Jl. Jend Sudirman Kav. 29-31 Jakarta 12926	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
336	WTC MANGGA DUA	Jl. Mangga Dua Raya Kav. 8 Jakarta 14433	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
337	Acasia Junior2	jalan merdek	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
338	Menara Mulia (Dapen BRI)	Menara Mulia	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
339	Kemang Village	Kemang	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
340	ITC MANGGA DUA	ITC MANGGA	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
341	KAWASAN INDUSTRI SURYACIPTA	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
342	NEUCENTRIX BALIKPAPAN	DC NeuCentrIX Batu Ampar Jl. MT Haryono No. 169 Balikpapan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
343	KAWASAN INDUSTRI CANDI	Jl. Gatot Subroto Kawasan Industri Candi Tahap V No.	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
344	WISMA SIER	JL. Rungkut Industri 1V No. 5-11, Kutisari, Kec. Tenggilis Mejoyo	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
345	WISMA KALLA	Jl.Dr.Sam Ratulangi No.8 Makasar	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
346	BDX DC LA TECHNOPARK	DC Taman Tekno Komplek Pergudangan Taman Tekno Blok D No.8, BSD, Setu, Kec. Setu, Kota Tangerang Selatan, Banten 15314	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
347	PLAZA BRI SURABAYA	plaza bri surabaya	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
348	Menara 165	Jl. TB. Simatupang Kav. 1 Cilandak Timur\nJakarta Selatan 12560	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
349	GRAND KEBON SIRIH	Jl. Kebon Sirih Raya No. 35	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
350	GRAHA PARAMITA II BINTARO	Jl. Denpasar Raya Blok D2 Kav.8, Kuningan Jakarta 12940	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
351	Cyber 1 MVNet	Cyber 1	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
352	CNI Cyber	Gedung Cyber Lt. 9, Jl. Kuningan Barat I No. 8, RT.001/003, Mampang Prapatan Jakarta Selatan 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
353	KAWASAN INDUSTRI JATAKE	Jalan Industri IV Blok AG No. 4 Kawasan Industri Jatake, Tangerang	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
354	HDC TELKOM DELTA MAS	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
355	PAM TOWER	bsb ba	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
356	MENARA DANAREKSA	Gedung Menara Danareksa, Lt. GF Zona A Jl. Medan Merdeka Selatan No.13 RT.11/RW 2. Kel. Gambir, Kec. Gambir, Kota Jakarta Pusat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
357	PT. Dunia Virtual Online	Jl. Raya Tapos No. 31, Kota Depok, \nJawa Barat 16459	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
358	DC VISIONET	Jl. Boulevard Gajah Mada No.2120, RT.001/RW.009, Panunggangan Bar., Kec. Cibodas, Kota Tangerang, Banten 15811	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
359	GRAHA PARAMITA II BINTARO	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
360	KAWASAN INDOTAISEI	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
361	APJII UNILAND	UNI PLAZA	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
362	NIX BALI	Jl. Kuningan Barat No. 8, Jakarta Selatan 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
363	Intiland Surabaya	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
364	BBU Bandung (Wisma Bumiputera)	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
365	MENARA BIDAKARA 1	Jl. Gatot Subroto Kav. 71-73\nJakarta Selatan - 12870	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
366	Apartemen Puri Casablanca	Jl. Puri Casablanca No. 1, Jakarta 12870	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
367	WISMA MANDIRI 1	Wisma Mandiri 1 Jl. M.H. Thamrin Kav. 5, Menteng, Jakarta Pusat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
368	WANRIAU INDOXP	Pekanbaru, Kota Pekanbaru, Riau, Indonesia	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
369	DP MALL SEMARANG	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
370	AREA 31	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
371	AREA 31	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
372	PLAZA DWIMA	Jl. Jend Ahmad Yani Kav. 67 Jakarta Pusa	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
373	DC Permata Hayam Wuruk	Jl. Hayam Wuruk No.84 9, RT.9/RW.5, Maphar, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11160	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
374	MENARA SUN LIFE	MENARA SUNL	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
375	WTC SUDIRMAN	WTC SUDIRMAN	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
376	GEDUNG GRAHA SUCONFINDO	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
377	APJII SURABAYA	INTILAND	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
378	APJII UII YOGYAKARTA	GLOBAL PRIMA UTAMA	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
379	APJII UII YOGYAKARTA	GLOBAL PRIMA UTAMA	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
380	APJII Jakarta	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
381	UNILAND MEDAN	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
382	VOZA TOWER	Jln HR Muhammad No 31	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
383	TAMARA CENTER	TAMARA CENTER	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 04:51:02.664394	\N	\N	Indonesia
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: netpoint_user
--

COPY public.locations (id, name, address, city, province, is_onnet, created_at, updated_at) FROM stdin;
1	Menara Sudirman	Jl. Jend. Sudirman Kav. 60	Jakarta Selatan	DKI Jakarta	t	2026-02-03 15:01:35.703132	2026-02-03 15:01:35.703132
2	Wisma BNI	Jl. Jend. Sudirman Kav. 1	Jakarta Pusat	DKI Jakarta	t	2026-02-03 15:01:35.703132	2026-02-03 15:01:35.703132
3	Gedung Mayapada Tower	Jl. Jend. Sudirman Kav. 28	Jakarta Selatan	DKI Jakarta	t	2026-02-03 15:01:35.703132	2026-02-03 15:01:35.703132
4	Cyber Building	Jl. Kuningan Barat No. 8	Jakarta Selatan	DKI Jakarta	t	2026-02-03 15:01:35.703132	2026-02-03 15:01:35.703132
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: netpoint_user
--

COPY public.orders (id, user_id, location_id, tier_id, location_name, status, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: price_list; Type: TABLE DATA; Schema: public; Owner: netpoint_user
--

COPY public.price_list (id, bandwidth_mbps, domestic_otc, domestic_mrc_zone1, domestic_mrc_zone2, domestic_mrc_zone3, domestic_mrc_zone4, intl_otc, intl_mrc_zone1, intl_mrc_zone2, intl_mrc_zone3, intl_mrc_zone4, dia_otc, dia_mrc, idia_bw, idia_otc, idia_mrc, year, status, created_at, updated_at) FROM stdin;
1	2	8500000.00	3238798.36	3409261.43	3665872.51	4073191.68	8500000.00	4048497.95	4261576.79	4582340.64	5091489.60	8500000.00	3350408.42	10	8500000.00	2931271.71	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
2	4	8500000.00	3820903.03	4022003.19	4324734.61	4805260.68	8500000.00	4776128.78	5027503.98	5405918.26	6006575.85	8500000.00	3438016.77	25	8500000.00	3720318.39	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
3	6	8500000.00	4043141.21	4255938.11	4576277.54	5084752.82	8500000.00	5053926.51	5319922.64	5720346.93	6355941.03	8500000.00	3967002.95	50	8500000.00	4705918.64	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
4	8	8500000.00	4265379.39	4489873.04	4827820.47	5364244.97	8500000.00	5331724.23	5612341.30	6034775.59	6705306.21	8500000.00	4490699.27	100	8500000.00	6145646.81	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
5	10	8500000.00	4487617.57	4723807.97	5079363.40	5643737.12	8500000.00	5609521.96	5904759.96	6349204.26	7054671.40	8500000.00	5009158.62	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
6	20	8500000.00	5398851.02	5683001.08	6110753.85	6789726.50	8500000.00	6748563.78	7103751.35	7638442.31	8487158.12	8500000.00	6288468.11	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
7	30	8500000.00	6709999.37	7063157.23	7594792.72	8438658.58	8500000.00	8387499.21	8828946.54	9493490.90	10548323.23	8500000.00	7554984.51	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
8	40	8500000.00	7821190.27	8232831.87	8852507.38	9836119.31	8500000.00	9776487.84	10291039.83	11065634.23	12295149.14	8500000.00	8808835.74	\N	\N	1.00	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
9	50	8500000.00	8932381.17	9402506.50	10110222.04	11233580.05	8500000.00	11165476.47	11753133.12	12637777.55	14041975.06	8500000.00	10050148.45	\N	\N	2.00	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
10	60	8500000.00	10043572.07	10572181.13	11367936.70	12631040.78	8500000.00	12554465.09	13215226.41	14209920.88	15788800.97	8500000.00	11279048.05	\N	\N	3.00	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
11	70	8500000.00	11154762.98	11741855.76	12625651.36	14028501.51	8500000.00	13943453.72	14677319.71	15782064.20	17535626.89	8500000.00	12495658.64	\N	\N	1.00	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
12	80	8500000.00	12265953.88	12911530.40	13883366.02	15425962.24	8500000.00	15332442.35	16139413.00	17354207.52	19282452.80	8500000.00	13700103.13	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
13	90	8500000.00	13377144.78	14081205.03	15141080.68	16823422.98	8500000.00	16721430.97	17601506.29	18926350.85	21029278.72	8500000.00	14892503.17	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
14	100	8500000.00	13970895.12	14706205.39	15813124.07	17570137.86	8500000.00	17463618.90	18382756.74	19766405.09	21962672.33	8500000.00	15916654.93	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
15	200	8500000.00	16789041.99	17672675.78	19002877.19	21114307.99	8500000.00	18935009.77	19931589.23	21431816.38	23813129.31	8500000.00	21683791.86	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
16	300	8500000.00	20538581.88	21619559.87	23246838.57	25829820.63	8500000.00	23163814.15	24382962.26	26218238.99	29131376.65	8500000.00	29746372.63	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
17	400	8500000.00	24288121.76	25566443.96	27490799.95	30545333.28	8500000.00	27392618.53	28834335.29	31004661.60	34449624.00	8500000.00	38766128.95	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
18	500	8500000.00	28037661.64	29513328.04	31734761.34	35260845.93	8500000.00	31621422.90	33285708.32	35791084.22	39767871.35	8500000.00	44630147.00	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
19	600	8500000.00	31787201.52	33460212.13	35978722.72	39976358.58	8500000.00	35850227.28	37737081.35	40577506.83	45086118.70	8500000.00	51510102.80	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
20	700	8500000.00	35536741.41	37407096.22	40222684.11	44691871.23	8500000.00	40079031.66	42188454.38	45363929.44	50404366.05	8500000.00	59281578.16	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
21	800	8500000.00	39286281.29	41353980.31	44466645.49	49407383.88	8500000.00	44307836.04	46639827.41	50150352.06	55722613.40	8500000.00	66897624.02	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
22	900	8500000.00	43035821.17	45300864.39	48710606.87	54122896.53	8500000.00	48536640.42	51091200.44	54936774.67	61040860.74	8500000.00	74361348.96	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
23	1000	8500000.00	46785361.05	49247748.48	52954568.26	58838409.17	8500000.00	52765444.80	55542573.47	59723197.28	66359108.09	8500000.00	81675799.40	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-05 04:51:02.766412
\.


--
-- Data for Name: pricing_tiers; Type: TABLE DATA; Schema: public; Owner: netpoint_user
--

COPY public.pricing_tiers (id, tier_name, capacity, sla, setup_time, monthly_price, features, is_popular, created_at, updated_at) FROM stdin;
1	Netpoint Basic	50 Mbps	99.0%	7 Hari	1500000	{"Bandwidth up to 50 Mbps","SLA 99.0%","Email Support","Setup dalam 7 hari kerja"}	f	2026-02-03 15:01:35.699553	2026-02-03 15:01:35.699553
2	Netpoint Business	100 Mbps	99.7%	5 Hari	3000000	{"Bandwidth up to 100 Mbps","SLA 99.7%","24/7 Phone Support","Setup dalam 5 hari kerja","Dedicated Account Manager"}	t	2026-02-03 15:01:35.699553	2026-02-03 15:01:35.699553
3	Netpoint Enterprise	1 Gbps	99.9%	Custom	\N	{"Bandwidth up to 1 Gbps","SLA 99.9%","24/7 Priority Support","Custom Setup Timeline","Dedicated Technical Team","Custom Configuration"}	f	2026-02-03 15:01:35.699553	2026-02-03 15:01:35.699553
\.


--
-- Data for Name: quotes; Type: TABLE DATA; Schema: public; Owner: netpoint_user
--

COPY public.quotes (id, quote_number, building_id, building_name, bandwidth_mbps, service_type, zone, otc, mrc, total_price, customer_name, customer_email, customer_phone, notes, status, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: netpoint_user
--

COPY public.refresh_tokens (id, user_id, token_hash, user_agent, ip_address, expires_at, revoked_at, replaced_by_token_hash, created_at) FROM stdin;
1	1	2258cfeb7ebbbe5749aaf715714c40de40325ed37e17fad0aebb3a43f5f37a44	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 05:25:49.659	\N	\N	2026-02-05 05:25:49.660207
2	1	c2d691985df4ff8a85e3f9cb6ead21240d2d60fbfe62ad2bd52f2115ed51a4f7	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 05:26:21.777	\N	\N	2026-02-05 05:26:21.778853
3	1	8247f2d06fbb5f5513b976a32bef19a11f73d74bab3b4556893105988b47e801	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 05:26:49.425	\N	\N	2026-02-05 05:26:49.426362
4	1	87983867e826fa90673427250dfda91a2bcffa3208652f8faeb224f29e8200bf	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 05:27:45.755	2026-02-05 05:28:58.938677	7524ff106adb5566739ba1983ab1f70fe66ffb5ef19de73bb5b25d1f376eb3a3	2026-02-05 05:27:45.756475
5	1	7524ff106adb5566739ba1983ab1f70fe66ffb5ef19de73bb5b25d1f376eb3a3	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 05:28:58.938	\N	\N	2026-02-05 05:28:58.941096
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: netpoint_user
--

COPY public.users (id, name, email, phone, password, google_id, role, created_at, updated_at) FROM stdin;
1	admin	admin@netpoint.com	\N	$2a$10$Ff/RqDv30/7Qf/pk.3XwTuUsdLQsd./FcBjVGhCe2TCRHsn852oXm	\N	admin	2026-02-03 15:01:35.838151	2026-02-05 05:25:39.552132
\.


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: netpoint_user
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 5, true);


--
-- Name: buildings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: netpoint_user
--

SELECT pg_catalog.setval('public.buildings_id_seq', 383, true);


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: netpoint_user
--

SELECT pg_catalog.setval('public.locations_id_seq', 4, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: netpoint_user
--

SELECT pg_catalog.setval('public.orders_id_seq', 1, false);


--
-- Name: price_list_id_seq; Type: SEQUENCE SET; Schema: public; Owner: netpoint_user
--

SELECT pg_catalog.setval('public.price_list_id_seq', 23, true);


--
-- Name: pricing_tiers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: netpoint_user
--

SELECT pg_catalog.setval('public.pricing_tiers_id_seq', 3, true);


--
-- Name: quotes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: netpoint_user
--

SELECT pg_catalog.setval('public.quotes_id_seq', 1, false);


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: netpoint_user
--

SELECT pg_catalog.setval('public.refresh_tokens_id_seq', 5, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: netpoint_user
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: buildings buildings_pkey; Type: CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.buildings
    ADD CONSTRAINT buildings_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: price_list price_list_bandwidth_mbps_year_key; Type: CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.price_list
    ADD CONSTRAINT price_list_bandwidth_mbps_year_key UNIQUE (bandwidth_mbps, year);


--
-- Name: price_list price_list_pkey; Type: CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.price_list
    ADD CONSTRAINT price_list_pkey PRIMARY KEY (id);


--
-- Name: pricing_tiers pricing_tiers_pkey; Type: CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.pricing_tiers
    ADD CONSTRAINT pricing_tiers_pkey PRIMARY KEY (id);


--
-- Name: quotes quotes_pkey; Type: CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT quotes_pkey PRIMARY KEY (id);


--
-- Name: quotes quotes_quote_number_key; Type: CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT quotes_quote_number_key UNIQUE (quote_number);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_hash_key; Type: CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_hash_key UNIQUE (token_hash);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_audit_logs_user; Type: INDEX; Schema: public; Owner: netpoint_user
--

CREATE INDEX idx_audit_logs_user ON public.audit_logs USING btree (user_id);


--
-- Name: idx_buildings_name; Type: INDEX; Schema: public; Owner: netpoint_user
--

CREATE INDEX idx_buildings_name ON public.buildings USING btree (building_name);


--
-- Name: idx_buildings_status; Type: INDEX; Schema: public; Owner: netpoint_user
--

CREATE INDEX idx_buildings_status ON public.buildings USING btree (status);


--
-- Name: idx_buildings_zone; Type: INDEX; Schema: public; Owner: netpoint_user
--

CREATE INDEX idx_buildings_zone ON public.buildings USING btree (zone_code);


--
-- Name: idx_price_bandwidth; Type: INDEX; Schema: public; Owner: netpoint_user
--

CREATE INDEX idx_price_bandwidth ON public.price_list USING btree (bandwidth_mbps);


--
-- Name: idx_price_year; Type: INDEX; Schema: public; Owner: netpoint_user
--

CREATE INDEX idx_price_year ON public.price_list USING btree (year);


--
-- Name: idx_quotes_building; Type: INDEX; Schema: public; Owner: netpoint_user
--

CREATE INDEX idx_quotes_building ON public.quotes USING btree (building_id);


--
-- Name: idx_quotes_created_by; Type: INDEX; Schema: public; Owner: netpoint_user
--

CREATE INDEX idx_quotes_created_by ON public.quotes USING btree (created_by);


--
-- Name: idx_quotes_status; Type: INDEX; Schema: public; Owner: netpoint_user
--

CREATE INDEX idx_quotes_status ON public.quotes USING btree (status);


--
-- Name: idx_refresh_tokens_user; Type: INDEX; Schema: public; Owner: netpoint_user
--

CREATE INDEX idx_refresh_tokens_user ON public.refresh_tokens USING btree (user_id);


--
-- Name: buildings update_buildings_updated_at; Type: TRIGGER; Schema: public; Owner: netpoint_user
--

CREATE TRIGGER update_buildings_updated_at BEFORE UPDATE ON public.buildings FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: price_list update_price_list_updated_at; Type: TRIGGER; Schema: public; Owner: netpoint_user
--

CREATE TRIGGER update_price_list_updated_at BEFORE UPDATE ON public.price_list FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: quotes update_quotes_updated_at; Type: TRIGGER; Schema: public; Owner: netpoint_user
--

CREATE TRIGGER update_quotes_updated_at BEFORE UPDATE ON public.quotes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: orders orders_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE SET NULL;


--
-- Name: orders orders_tier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_tier_id_fkey FOREIGN KEY (tier_id) REFERENCES public.pricing_tiers(id) ON DELETE SET NULL;


--
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: quotes quotes_building_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT quotes_building_id_fkey FOREIGN KEY (building_id) REFERENCES public.buildings(id);


--
-- Name: quotes quotes_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT quotes_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: refresh_tokens refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict QUfiruxAXZ53GJaGa7MxZgiOXkYlYX0B1caGTyAZ6QbYenUGZJDbaKXSTfGBvkX

