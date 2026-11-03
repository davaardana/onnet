--
-- PostgreSQL database dump
--

\restrict Sbuth7ot0jjFBLx2UzwI9hfD8xY3ow9nbbbBhvp0DGcSqeP3qe34OzFKgP0qlwA

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
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    bandwidth_mbps integer,
    service_type character varying(50),
    zone character varying(50),
    source character varying(50),
    whatsapp_number character varying(32),
    service_category character varying(50),
    a_end text,
    b_end text
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
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    metronet_otc numeric(12,2),
    metronet_mrc_zone1 numeric(12,2),
    metronet_mrc_zone2 numeric(12,2),
    metronet_mrc_zone3 numeric(12,2),
    metronet_mrc_zone4 numeric(12,2),
    dc2dc_otc numeric(12,2),
    dc2dc_mrc numeric(12,2),
    darkfiber_otc numeric(12,2),
    darkfiber_mrc_per_core numeric(12,2)
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
-- Name: quote_logs; Type: TABLE; Schema: public; Owner: netpoint_user
--

CREATE TABLE public.quote_logs (
    id integer NOT NULL,
    user_id integer,
    source character varying(50) NOT NULL,
    bandwidth_mbps integer NOT NULL,
    service_type character varying(50) NOT NULL,
    zone character varying(50),
    price_list_id integer,
    building_id integer,
    building_name character varying(255),
    location_query text,
    otc numeric(15,2),
    mrc numeric(15,2),
    whatsapp_number character varying(32),
    status character varying(20) DEFAULT 'pending'::character varying,
    notes text,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    service_category character varying(50),
    a_end text,
    b_end text
);


ALTER TABLE public.quote_logs OWNER TO netpoint_user;

--
-- Name: quote_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: netpoint_user
--

CREATE SEQUENCE public.quote_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quote_logs_id_seq OWNER TO netpoint_user;

--
-- Name: quote_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: netpoint_user
--

ALTER SEQUENCE public.quote_logs_id_seq OWNED BY public.quote_logs.id;


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
-- Name: quote_logs id; Type: DEFAULT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.quote_logs ALTER COLUMN id SET DEFAULT nextval('public.quote_logs_id_seq'::regclass);


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
6	1	login	auth	119.2.41.234	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0	{"method": "password"}	2026-02-05 06:34:11.307075
7	3	register	auth	119.2.41.234	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0	{"method": "password"}	2026-02-05 06:44:51.249209
8	1	login	auth	119.2.41.234	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0	{"method": "password"}	2026-02-05 06:45:38.844036
9	3	login	auth	119.2.41.234	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0	{"method": "password"}	2026-02-05 06:46:24.578013
10	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-05 07:42:48.397151
11	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-05 10:48:12.849846
12	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-05 10:48:41.356432
13	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-05 10:49:07.758576
14	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-05 10:51:38.350156
15	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-05 10:51:55.39164
16	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-05 10:52:30.73326
17	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-05 10:56:19.404482
18	3	login	auth	103.120.170.13	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0	{"method": "password"}	2026-02-05 10:56:33.023833
19	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-05 10:57:20.371164
20	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-05 10:58:08.116581
21	1	login	auth	103.120.170.13	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0	{"method": "password"}	2026-02-05 11:02:46.786448
22	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-05 11:06:21.327614
23	4	register	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-05 11:08:59.644615
24	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-05 11:09:23.171849
25	3	login	auth	103.120.170.13	Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/405.0.859829126 Mobile/15E148 Safari/604.1	{"method": "password"}	2026-02-05 12:07:54.903903
26	3	login	auth	103.120.170.13	Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/405.0.859829126 Mobile/15E148 Safari/604.1	{"method": "password"}	2026-02-05 12:09:08.926431
27	3	login	auth	114.4.78.0	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36	{"method": "password"}	2026-02-05 12:10:44.073384
28	3	login	auth	103.120.170.13	Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/405.0.859829126 Mobile/15E148 Safari/604.1	{"method": "password"}	2026-02-05 12:11:18.194969
29	3	login	auth	103.120.170.13	Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/405.0.859829126 Mobile/15E148 Safari/604.1	{"method": "password"}	2026-02-05 12:12:10.942041
30	5	register	auth	103.120.170.13	Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/405.0.859829126 Mobile/15E148 Safari/604.1	{"method": "password"}	2026-02-05 12:13:43.696637
31	3	login	auth	114.199.107.66	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Mobile/15E148 Safari/604.1	{"method": "password"}	2026-02-05 12:13:46.56106
32	5	login	auth	103.120.170.13	Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/405.0.859829126 Mobile/15E148 Safari/604.1	{"method": "password"}	2026-02-05 12:14:24.256672
33	5	login	auth	114.4.78.0	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36	{"method": "password"}	2026-02-05 12:14:41.247464
34	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-23 16:22:26.106393
35	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-24 15:59:43.221364
36	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-24 16:15:04.340288
37	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-24 16:15:15.871304
38	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-24 16:15:16.021233
39	1	logout	auth	::ffff:172.18.0.1	curl/7.81.0	{}	2026-02-24 16:15:16.115496
40	\N	register	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-25 16:54:05.311495
41	\N	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-25 16:54:29.279587
42	\N	register	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-25 16:59:23.754182
43	\N	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-25 16:59:23.897588
44	3	login	auth	103.130.18.183	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0	{"method": "password"}	2026-02-25 17:04:05.722497
45	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-25 17:04:50.147388
46	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-25 17:12:03.176552
47	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-25 17:15:30.602854
48	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-25 17:21:48.892616
49	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-25 17:22:31.196573
50	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-25 17:24:11.719858
51	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-25 17:24:20.359001
52	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-25 17:24:35.518191
53	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-26 17:20:39.862823
54	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-26 17:21:20.318984
55	1	refresh_token	auth	::ffff:172.18.0.1	curl/7.81.0	{"replaced_token_id": 53}	2026-02-26 17:21:20.574106
56	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-26 17:22:14.334914
57	1	refresh_token	auth	::ffff:172.18.0.1	curl/7.81.0	{"replaced_token_id": 55}	2026-02-26 17:22:14.553437
58	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-26 17:24:29.039719
59	1	refresh_token	auth	::ffff:172.18.0.1	curl/7.81.0	{"replaced_token_id": 57}	2026-02-26 17:24:29.250402
60	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-26 17:24:42.801359
61	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-26 17:25:04.274516
62	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-26 17:27:25.806967
63	1	refresh_token	auth	::ffff:172.18.0.1	curl/7.81.0	{"replaced_token_id": 61}	2026-02-26 17:27:26.038168
64	1	logout	auth	::ffff:172.18.0.1	curl/7.81.0	{}	2026-02-26 17:27:26.266173
65	1	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-26 17:31:10.64974
66	1	refresh_token	auth	::ffff:172.18.0.1	curl/7.81.0	{"replaced_token_id": 63}	2026-02-26 17:31:10.880024
67	1	logout	auth	::ffff:172.18.0.1	curl/7.81.0	{}	2026-02-26 17:31:11.124584
68	8	register	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-27 20:11:18.349872
69	8	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-27 20:11:33.741412
70	8	login	auth	::ffff:172.18.0.1	curl/7.81.0	{"method": "password"}	2026-02-27 20:12:43.392769
72	4	login	auth	38.47.180.164	curl/7.81.0	{"method": "password"}	2026-11-03 06:41:45.916303
71	\N	register	auth	38.47.180.164	curl/7.81.0	{"method": "password"}	2026-11-03 06:41:39.076229
\.


--
-- Data for Name: buildings; Type: TABLE DATA; Schema: public; Owner: netpoint_user
--

COPY public.buildings (id, building_name, address, zone_code, zone_name, zone_number, zone_details, status, created_at, updated_at, city, zone, country) FROM stdin;
38	BP BATAM	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
64	DATA CENTER FAASRI	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
162	KOPKARWIPI	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
213	Miratel (Titan)	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
1	AD PREMIER	Jl. TB Simatupang No. I Jakarta Selatan 12550	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
2	AGRO PLAZA	Chase Plaza - 20th Floor, Jl. Jend Sudirman Kav. 21 Jakarta 12920	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
3	AIA CENTRAL	AIA CENTRAL	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
4	ALAMANDA BALI	Jl. Bypass Ngurah Rai Telaga Ayu Kubunesa 2 No. 7 Kedonganan - Bali	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
5	ALAMANDA TOWER	alamanda tower	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
6	ALFAMART MEDAN	Jl. Enggang IV No. 97 Perumnas Mandala Medan - 20226	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
7	ANEKA PAVILLION PONTIANAK	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
8	ANZ TOWER	ANZ Tower	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
9	APARTEMEN MITRA SUNTER	Apartemen mitra s	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
10	APARTEMEN ST MORITZ	Kawasan Residensial dan Komersial The St. Moritz di Kembangan Selatan, Kec. Kembangan, Kota Jakarta Barat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
11	APARTEMEN TELUK INTAN	Tower Topaz Lt. PH No. BB Jl.Teluk Intan Raya Kel. Pejagalan Kec. Penjaringan Jakarta Utara	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
12	APARTEMEN THE LAVANDE RESIDENCE	Jl. Prof. Dr. Soepomo 231, Jakarta Selatan 12830	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
13	APJII BALIKPAPAN	Cyber Building Jl. Kuningan Barat No. 8 Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
14	ASOSIASI PENYELENGGARA JASA INTERNET INDONESIA (APJII)	Cyber Building Jl. Kuningan Barat No. 8 Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
15	ATRIUM MULIA	Jl. HR Rasuna Said Kav. B10-11 Setiabudi Kuningan Jakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
16	ATRIUM SETIABUDI	Jl. HR Rasuna Said Kav. 62 Jakarta 12920	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
17	AYANI MEGAMALL PONTIANAK	Jl. Ahmad Yani Pontianak 78121	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
18	BANDARA SOEKARNO HATTA (GEDUNG POS)	Bandara Soekarno Hatta - Terminal 2F Kedatangan Room F9P67	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
19	BANDARA SOEKARNO HATTA (TERMINAL 1)	Bandara Soekarno Hatta - Terminal 2F Kedatangan Room F9P67	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
20	BANDARA SOEKARNO HATTA (TERMINAL 123)	Bandara Soekarno Hatta - Terminal 2F Kedatangan Room F9P67	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
21	BANDARA SOEKARNO HATTA (TERMINAL 2)	Bandara Soekarno Hatta - Terminal 2F Kedatangan Room F9P67	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
22	BANDARA SOEKARNOHATTA (TERMINAL 3)	Bandara Soekarno Hatta - Terminal 2F Kedatangan Room F9P67	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
23	BANGKA TRADE CENTER	Bangka Trade	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
24	BANK ARTHA GRAHA	Jl. Melawai Raya Blok B III No. 194 Kebayoran Baru - Jakarta Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
25	BANK SUMSEL BABEL	Bank Sumsel Babel	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
26	BDx DC Lintasarta TB Simatupang	Gedung Aplikasinusa Lintasarta Jl. T.B. Simatupang (Kav 10) Jakarta Capital Region, 12430	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
27	BDx DC TB Simatupang	Jl. Lurah Kawi no 1 JAtiluhur Purwakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
28	BDx DRC 2 JAH	Jatiluhur, Kec. Purwakarta, Kabupaten Purwakarta, Jawa Barat 41152	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
29	BDx DRC Jatiluhur	Jln. Lurah Kawi, Purwakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
30	BDx DRC3 Jatiluhur	DRC3 Jatiluhur	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
31	BDx IDC2 KPPTI	KPPTI	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
32	BDx KPPTI	KPPTI	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
33	BDx UIN Walisongo	Jl. Lurah Kawi No 1 jatiluhur Purwakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
34	BELLANOVA COUNTRY MALL	Jl. MH Thamrin No. 8, Bukit Sentul Selatan, Kabupaten Bogor 16810	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
35	BELTWAY OFFICE PARK	Jl. TB Simatupang No. 41 Jakarta 12550	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
36	BERITA SATU PLAZA	Lippo Cyber Park Jl. Boulevard Gajahmada No. B 2058 Kec.Cibodas Kel. Panunggangan Barat Karawaci � Tangerang 15811	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
37	BINTARO JAYA XCHANGE MALL	Bintaro Jaya Xchange Mall CBD Bintaro Jaya Blok O-2Bintaro Jaya Sektor VII Tangerang 15227	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
39	BTS JAMES_SITORUS_I SITE ID : 05SDK016	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
40	BTS PLAZA MULIA	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
41	BUARAN PLAZA	Jl. Radin Inten No. I Klender Jakarta Timur	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
42	CBN NUSANTARA	Cyber2 Tower Lt.2 Jl. HR Rasuna Said Blok X-5 No. 13 Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
43	CENTRAL PASAR MEDAN	Jl. Letjen Haryono MT Central Pasar Medan Lt.1 Blok I No. 1 � 2 � 17 � 18 Medan 20212	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
44	CENTRE POINT MEDAN	Mall Centre Point Medan Level 3A Jl. Jawa No. 8 Medan 20213	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
45	CIBINONG CITY MALL	Jl. Tegar Beriman 1 Cibinong Bogor	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
46	CIBIS EIGHT d.h CILANDAK COMMERCIAL ESTATE (CCE)	Jl. Raya Cilandak KKO Jakarta Selatan 12560	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
47	CIBIS NINE	Cibis Nine	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
48	CIBIS PARK	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
49	CITRALAND SURABAYA	Office Park # 1 Citraland Utama Rd Citraland Surabaya 60219	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
50	CITY CENTER PALEMBANG	Jl. Sudirman No. 57 Palembang 30125	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
51	CNDC NEUCENTRIX TELKOM KARET TENGSIN	DC Neucentrix Karet Tengsin	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
52	CNDC TELKOM, NeuCentrix Medan	Jl. Japati 1 Bandung 40133	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
53	COWELL TOWER D.H GRAHA ATRIUM	Cowell Tower, Jl. Senen Raya, RW.2, Senen, Central Jakarta City, Jakarta, Indonesia	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
54	CSM CIKARANG	Jl. Tebet Timur Raya No. 53 Jakarta 12820	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
55	CYBER	Jl. Kuningan Barat No. 8 - Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
56	CYBER 2	Jalan HR. Rasuna Said Blok X-5 no. 13, Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
57	CYBER CSF / CYBER 3	Jl. Kuningan Barat No. 8 - Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
58	CYBER DATA CENTRE INDONESIA	Jl. Kuningan Barat No. 8 - Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
59	DARMAWANGSA SQUARE	Jl. Dharmawangsa 6-9 Ground Level Dharmawangsa Square Jakarta Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
60	DATA CENTER COLLEGA	Talavera Office Park lantai 6-7 Jl.Tb Simatupang Kav. 22-26 Cilandak Jakarta 12430	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
61	DATA CENTER DCI INDONESIA (EQUITY TOWER)	Kawasan Industri MM2100 Jl. Irian Cibitung Cikarang 17530	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
62	DATA CENTER DTP DI GEDUNG TIFA	Gedung Cyber Lt. 9 Jl. Kuningan Barat No. 8Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
63	DATA CENTER ELITERY	Jl. Raya Padjajaran No. 17 Bogor 16142	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
65	DATA CENTER INFOCOM MANDIRI MEDAN	UNILAND TOWER West Lt 4 JL. MT HARYONO NO. 1A MEDAN	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
66	DATA CENTER LINTAS ARTA	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
67	DATA CENTER TEKNOVATUS	Jl. Pahlawan Seribu Lot 12A BSD CBD Tangerang	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
68	DATA CENTER XL - RUNGKUT SURABAYA	Jl. DR Ide Anak Agung Gde Agung Lot E4 � 7 No. 1 Kawasan Mega Kuningan Jakarta 12950 - Indonesia	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
69	DC ELITERY	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
70	DC INTERLINK	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
71	DC XL Rungkut Surabaya	Jl. Raya Rungkut No.15A, Kali Rungkut, Kec. Rungkut, Kota SBY, Jawa Timur 60293	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
72	DEA TOWER D.H MENARA DEA	Dea Tower	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
73	DEUTSCHE BANK	Deutsche Bank Building, Jalan Imam Bonjol, RT.1/RW.5, Menteng, Central Jakarta City, Jakarta, Indonesia	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
74	DIPO TOWER	Jl. Jend Gatot Subroto Kav. 51-52 Jakarta 10260	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
75	EDGE	Jalan Kuningan Barat Raya No. 59, Mampang Prapatan, Jakarta Selatan, Indonesia 12910	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
76	EJIP (EAST JAKARTA INDUSTRIAL PARK)	Plot 3A Cikarang Selatan - Bekasi 17550	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
77	EMA - Obelisk	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
78	EPID - OBELISK	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
79	GEDUNG 46 ABDUL MUIS	Jl. Abdul Muis No. 46 Jakarta Pusat 10160	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
80	GEDUNG ARIOBIMO	Jl. HR Rasuna Said Blok X-2 No. 5 Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
81	GEDUNG B&G TOWER	Jl. Putri Hijau No. 10 Medan 20111	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
82	GEDUNG BBC	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
83	GEDUNG BRI 2	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
84	GEDUNG BUMI MANDIRI TOWER II SURABAYA D.H GEDUNG BUMI MANDIRI SURABAYA	Bumi Mandiri	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
85	GEDUNG CIMB NIAGA CIKARANG	Jl. MH Thamrin Kav. 107 Lippo Cikarang 17550	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
86	GEDUNG EIGHTY EIGHT	Jl. Casablanca Kav. 88 Jakarta Selatan 12870	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
87	GEDUNG INDOSURYA LIFE CENTER	Jalan M.H. Thamrin Kav.10, Building:Indosurya Life Center, 10th Floor, Server Room, Jakarta pusat - 10310, Indonesia	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
88	GEDUNG KHARISMA	Gedung kharisma	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
89	GEDUNG KRAKATAU STEEL D.H WISMA BAJA	Jl. Gatot Subroto Kav. 54 Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
90	GEDUNG MEDAN PEMUDA SURABAYA	Gedung Medan Pemuda Lt. 4 Jl. Pemuda No. 27 - 31 Surabaya - 60271	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
91	GEDUNG MENARA SUARA MERDEKA	Jl. MT Haryono 579A Semarang	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
92	GEDUNG PEMUDA	Gedung Pemuda Lt.2 Jl. Pemuda No. 66, Jakarta Timur 13220	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
93	GEDUNG PLAZA UOB	UOB Plaza Jl. MH Thamrin No. 10 Jakarta 10230	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
94	GEDUNG TITAN CENTRE	Titan Center	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
95	GRAHA AKTIVA	Graha Aktiva	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
96	GRAHA BUMI SURABAYA & HOTEL BUMI SURABAYA	Jl. Jend Basuki Rakhmat 106-128 Surabaya 60271	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
97	GRAHA CEMPAKA MAS	Graha Cempaka Mas	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
98	GRAHA CIMB NIAGA	Graha CIMB	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
99	GRAHA FAMILY VIEW (SPAZIO)	Jl. Golf Famili Timur II Blok E - Vertikal Surabaya 60226	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
100	GRAHA INTI FAUZI	Jl. Buncit Raya no.22, Jakarta 12510	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
101	GRAHA IRAMA	Graha Irama	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
102	GRAHA KENCANA	Jl. Raya Perjuangan No. 88 Blok GK RT 4 RW 010 Kebon Jeruk Jakarta Barat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
103	GRAHA KIRANA	Jl. Kirana Avenue No. 2 Kelapa Gading Timur Kelapa Gading Jakarta 14240	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
104	GRAHA MANDIRI/PLAZA BBD	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
105	GRAHA MOBISEL	Graha Mobisel Jl. Mampang Prapatan Raya No. 139 Jakarta 12790	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
106	GRAHA MULTIKA	Gedung Multika Jl. Mampang Prapatan Raya No. 71-73 Jakarta 12790	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
107	GRAHA PACIFIC	Graha Pacific	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
108	GRAHA PENA BATAM	Graha Pena Batam	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
109	GRAHA PENA JAKARTA	Gedung Graha Pena lantai 11 Jl. Raya Kebayoran Lama No. 12 Jakarta Selatan12210	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
110	GRAHA PENA JAWA POS	Graha Pena Jawa Pos	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
111	GRAHA PENA MAKASSAR	Graha Pena Makassar	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
112	GRAHA POS INDONESIA	Graha Pos Indonesia Lt.6 Jl. Banda No.30 Bandung 40115	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
113	GRAHA PRATAMA	Jl. MT Haryono Kav. 15 Jakarta 12810	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
114	GRAHA REKSO OFFICE TOWER	Jl. Boulevard Artha Gading Kav. A1 Kelapa Gading Jakarta Utara	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
115	GRHA BINTANG	grha bintang	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
116	GRHA PERTAMINA	Grha Pertamina, Jl. Medan Merdeka Timur No 10 RT 02, RW 01 , Kec. Gambir, Jakarta Pusat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
117	HARCO MANGGA2	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
118	HOTEL GOLDEN SKY CONDOMMINIUM	Jl. Taman Pluit Kencana Selatan No.48, RT.4/RW.6, Pluit, Kec. Penjaringan, Kota Jkt Utara, Daerah Khusus Ibukota Jakarta 14450	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
119	HOTEL KARTIKA	Jl. Jendral Gatot Subroto Kav. 18-20 Setiabudi Jakarta 12930	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
120	HYPERMART BINJAI SUPERMALL	Jl. Soekarno Hatta No. 14 Binjai 20731	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
121	HYPERMART CENTRAL PLAZA LAMPUNG	Jl. Raden Ajeng Kartini No. 21 Bandar Lampung - Lampung	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
122	HYPERMART CIMANGGIS SQUARE	Jl. Raya Bogor KM 29 (Hypermart Cimanggis) Depok - Jawa Barat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
123	HYPERMART CITYMALL BATURAJA	Jl. Ahmad Yani Kelurahan Tanjung Baru Kecamatan Baturaja Timur Kabupaten Ogan Komering Ulu Sumatera Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
124	HYPERMART DEPOK TOWN SQUARE	Jl. Margonda Raya No. 1 Pondok Cina Beji - Depok 16424	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
125	HYPERMART GRAND MALL BEKASI	Jl. Jendral Gatot Subroto Kav. 35-36 Jakarta - 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
126	HYPERMART MALL CIPUTRA CIBUBUR	Jl. Raya Alternatif Cibubur - Cileungsi Km4 Bekasi 17435	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
127	HYPERMART MAYOFIELD CILEGON	Developer (Supermall Karawang - Cilegon) APL Tower Central Park Lt. 7, T6 Jl. Let Jend S. Parman Kav.28 Jakarta Barat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
128	HYPERMART SERANG	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
129	HYPERMART SOLO SQUARE	Jl. Slamet Riyadi No. 451-455 Surakarta 57145	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
130	IDC BATAM	Sumatera Cytec Building Lt.4 Engku Putri Street Kav. 1 Batam Center - Batam 29461	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
131	IDC BOSOA MAKASAR	Menara Bosowa 6th Floor Jl. Jend. Sudirman No. 5, Pisang Utara, Ujung Pandang, Kota Makassar, Sulawesi Selatan 90113	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
132	IDC CYBER SATU	Cyber Building Lt.7 Jl. Kuningan Barat No. 8 Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
133	IDC DUREN TIGA	Gedung IDC 3D Jl. Duren Tiga Raya No. 7H Jakarta 12760	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
134	INDOFOOD TOWER	Jl. Jend. Sudirman No.Kav. 76-78, RT.3/RW.3, Kuningan, Setia Budi, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12910	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
135	INTILAND TOWER	Jl. Panglima Sudirman 101-103 Surabaya 60271	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
136	INTILAND TOWER D.H WISMA DHARMALA SAKTI	Jl. Panglima Sudirman 101-103 Surabaya 60271	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
137	ITC BSD	Gedung ITC BSD P2 floor , Jl. Pahlawan seribu Ta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
138	ITC DEPOK	Jl. Margonda Raya No. 56 Depok 16431	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
340	ITC MANGGA DUA	ITC Mangga Dua 6th Floor Jl.Mangga Dua Raya Jakarta 14430	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
139	ITC MANGGA DUA	ITC Mangga Dua 6th Floor Jl.Mangga Dua Raya Jakarta 14430	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
140	ITC ROXY MAS	ITC Roxy Mas Lt.5 Jl. Hasyim Ashari 125 - Jakarta 10150	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
141	JAKARTA INDUSTRIAL ESTATE PULOGADUNG (JIEP)	Kawasan Industri	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
142	JOHAR PLAZA	Jl. Diponegoro No. 66 Blok B-7 Jember - Jawa Timur	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
143	KALIBATA CITY APARTMENT	Mediterania Garden Residences I Tower A Lt.2 Jl. Tanjung Duren Raya Kav.5-9 Grogol Petamburan Jakarta Barat 11470	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
144	KARAWANG INTERNATIONAL INDUSTRIAL CITY (KIIC)	Karawang Intern	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
145	KARTINI RESIDENCES	Perkantoran Permata Senayan Blok C1-2 Jl.Tentara Pelajar Grogol Jakarta Selatan 12210	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
146	KAWASAN BERIKAT NUSANTARA	Jl. Raya Cakung CilincingTanjung Priok Jakarta 14140	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
147	KAWASAN CAMMO INDUSTRIAL PARK	Jl. Letjen Soeprapto Kawasan Industrial Cammo Batam Centre	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
148	KAWASAN INDUSTRI INDOTAISEI	Kawasan Industri Indotaisei, Sektor IA, Blok B, Kota Bukit Indah, Desa Kalihurip, Cikampek, Karawang, Jawa Barat 41373	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
149	KAWASAN INDUSTRI MAKASSAR (KIMA)	Jl. Perintis Kemerdekaan KM 15 Daya Makassar Sulawesi Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
150	KAWASAN INDUSTRI MASPION	Jl. Kembang Jepun 38-40 Surabaya	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
151	KAWASAN INDUSTRI MITRAKARAWANG (KIM)	Jakarta Representative Office: IMORA BUILDING 4th Fl JL. P. Jayakarta No.50 Jakarta 10730 |Site Office Kawasan Industri Mitrakarawang Desa Parungmulya, Kecamatan Ciampel Kabupaten Karawang Pr	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
152	KAWASAN INDUSTRI MM2100	Jl. Sumatera Kawasan Industri MM2100 Cikarang Barat Bekasi	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
153	KAWASAN INDUSTRI NGORO (NGORO INDUSTRIAL PERSADA)	Gedung Spazio Lt.8 Komplek Graha Festival Kav. 3 Jl. Mayjend Yono Soewoyo Surabaya	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
154	KAWASAN INDUSTRI RUNGKUT SURABAYA (SIER)	Jalan Rungkut Industri Raya 10 Surabaya	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
341	KAWASAN INDUSTRI SURYACIPTA	Jl. Surya Lestari Kav. C-3 Karawang 41361	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
155	KAWASAN INDUSTRI SURYACIPTA	Jl. Surya Lestari Kav. C-3 Karawang 41361	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
156	KAWASAN KOTA BUKIT INDAH INDUSTRIAL CITY (KAWASAN KBI)	Wisma Indocement Lt.12 Jl. Jend. Sudirman Kav. 70-71 - Jakarta 12910	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
157	KEMANG VILLAGE	Komplek Residensial dan Komersial The Kemang Village Jl. Pangeran Antasari No.36, RT.14/RW.5, Bangka, Kec. Mampang Prpt., Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12150	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
158	KERETA API INDONESIA AREA DAOP 8 SURABAYA	Jl. Gubeng Masjid No. 1 Surabaya 60131	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
159	KIRANA BOUTIQUE OFFICE	Kirana boutique	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
160	KIRANA THREE OFFICE	Jl. Kirana Avenue No. 2 Kelapa Gading Timur Jakarta 14240	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
161	KIRANA TWO OFFICE TOWER	Jl. Boulevard Timur No. 88 Kelapa Gading - Jakarta Utara	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
163	LAMONGAN SHOREBASE	Jl. Raya Daendels KM 64-65 Paciran Lamongan Jawa Timur	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
164	LANDMARK	Jl. Jend. Sudirman No. 1 - Jakarta Selatan 12910	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
165	LIPPO KUNINGAN	Gedung Berita Satu Plaza Lt.7 Jl. Jendral Gatot Subroto Kav. 35-36Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
166	LIPPO MALL PURI	Gedung Berita Satu Plaza Lt.7 Jl. Jendral Gatot Subroto Kav. 35-36Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
167	LIPPO PLAZA JAMBI	Gedung Berita Satu Plaza Lt.7 Jl. Jendral Gatot Subroto Kav. 35-36Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
168	LIPPO PLAZA JEMBER	Gedung Berita Satu Plaza Lt.7 Jl. Jendral Gatot Subroto Kav. 35-36Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
169	LIPPO PLAZA JOGJA	Gedung Berita Satu Plaza Lt.7 Jl. Jendral Gatot Subroto Kav. 35-36Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
170	LIPPO PLAZA KENDARI	Gedung Berita Satu Plaza Lt.7 Jl. Jendral Gatot Subroto Kav. 35-36Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
171	LIPPO PLAZA KUPANG	Gedung Berita Satu Plaza Lt.7 Jl. Jendral Gatot Subroto Kav. 35-36Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
172	MAC SARANA DJAYA	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
173	MAL CIPUTRA CIBUBUR	Jl. Raya Alternatif Cibubur - Cileungsi Km4 Bekasi 17435	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
174	MAL KELAPA GADING	Mal kelapa	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
175	MALL ARTHA GADING	Jl. Artha Gading Selatan No. 1 Jakarta Utara 14240	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
176	MALL MANGGA DUA	Gedung Mal Mangga Dua Lt.5 Jl. Arteri Mangga Dua Raya Jakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
177	MALL PURI INDAH	Jl. Puri AgungPuri Indah Jakarta Barat 11610	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
178	MALL TAMAN ANGGREK	Mall Taman Anggrek Management Office Lt.5 Jl. Let Jend SParman Kav. 21 Jakarta 11460	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
179	MALL WTC MATAHARI SERPONG	Jl. Raya Serpong No. 39 Tangerang Banten 15326	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
180	MANDIRI BUILDING (MEDAN)	Jl. Raya Serpong No. 39 Tangerang Banten 15326	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
181	MANGGA DUA SQUARE	Ruko Bintaro 8 Office Jl. Jombang Raya No. 8 Blok L-M RT 007/002 Pondok Pucung, Pondok Aren - Tangerang Selatan 15229	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
182	MARUNDA CENTER	Graha Kencana Blok CO Jl. Raya Perjuangan Kav. 88 Kebon Jeruk Jakarta Barat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
183	MAYAPADA TOWER I	Mayapada Tower 5th Floor Jl. Jend. Sudirman Kav. 28 - Jakarta 12920	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
184	MAYAPADA TOWER II	Jl. Jend Sudirman Kav. 27 Jakarta 12920	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
185	MEDAN FAIR PLAZA	Lippo Cyber Park Jl. Boulevard Gajahmada No. B 2058 Kec. Cibodas Kel. Panunggangan Barat Karawaci � Tangerang 15811	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
186	MEDAN MALL	Gedung Medan Mall Medan � Sumatera Utara	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
187	MEGA GLODOK KEMAYORAN	Jl. Angkasa Kav. B6 Kota Baru Bandar Kemayoran Jakarta Pusat 10610 (MGK Kemayoran)	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
188	MEGA MALL MANADO	Jl. Pierre Tendean Boulevard Manado 95111 Sulawesi Utara	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
189	MEGA PLAZA BUILDING	Lantai 12, Jl. Hr Rasuna Said Kav C-3, Setiabudi, Jakarta Selatan, Indonesia 12920	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
190	MEGASARI MAKMUR	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
191	MENARA ANTAM SEJAHTERA	Jl. Letjen TB Simatupang No. 1 RT/ RW 10/04 Tanjung Barat Jagakarsa Jakarta Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
192	MENARA BATAVIA	Jl. KH Mas Mansyur Kav. 126 Jakarta 10220	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
193	MENARA BIDAKARA 2	Jl. Jend Gatot Subroto Kav. 71-73 Pancoran Jakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
194	MENARA BRI BANDUNG	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
195	MENARA BTPN	Jl. DR Ide Anak Agung Gde Agung Kav. 5.5 - 5.6 Kawasan Mega Kuningan Jakarta Selatan 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
196	MENARA CAKRAWALA	Jl. MH Thamrin No. 9 Jakarta Pusat 10340	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
197	MENARA CITIBANK	Jl. Metro Pondok Indah Kav. II BA No. 2 Jakarta 12310	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
198	MENARA CITICON	JL Letjen S Parman, Kavling 72, Slipi, Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota, Jakarta, 11480, IDN	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
199	MENARA GLOBAL	Jl. Jend Gatot Subroto Kav. 27 Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
200	MENARA IMPERIUM	Jl. HR Rasuna Said Kav. 1 RW.6 Guntur Setiabudi Kota Jakarta Selatan Daerah Khusus Ibukota Jakarta 12980	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
201	MENARA JAMSOSTEK	Menara Jamsostek Selatan Lt. 24 Jl. Jend. Gatot Subroto No. 38 RT 6 / RW 1 Kuningan Barat 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
202	MENARA KUNINGAN	Jl. HR Rasuna Said Blok X-7 Kav. 5 Jakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
203	MENARA MANDIRI 2	JL. JEND SOEDIRMAN KAV. 54-55 JAKARTA 12190	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
204	MENARA MERDEKA	Jalan Budi Kemuliaan I no 2 Gambir - Jakarta Pusat 10110	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
205	MENARA MULIA	Jl. Jend. Gatot Subroto Kav. 9-11 Jakarta 12930	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
206	MENARA PRIMA	Menara Prima	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
207	MENARA RAJAWALI	Menara Rajawali	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
208	MENARA STANDARD CHARTERED D.H MENARA SATRIO	Jl. Prof. Dr Satrio No. 164 Jakarta 12930	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
209	MENARA THAMRIN	Jl. MH Thamrin Kav. 3 Jakarta 10250	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
210	METRO CIPULIR	Wisma Slipi Lt.11 Jl.Let.S.Parman Kav 12 Jakarta Barat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
211	METRO PASAR BARU	Metro Pasar Baru	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
212	METROPOLITAN MALL CILEUNGSI (METLAND)	Gedung Metropolitan Mall Cileungsi Jl. Taman Metro Raya Cileungsi Bogor 16820	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
214	MITRATEL	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
215	MITRATEL - NON TITAN	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
216	MITRATEL - TITAN	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
217	Mitratel (Titan)	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
218	MNC TOWER (BIMANTARA)	Komp. Rukan Permata Senayan Blok A32 Jl. Tentara Pelajar Jakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
219	MORATEL GRHA 9	Grha 9, Jalan Panataran No.9 Proklamasi Jakarta 10320	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
220	MULIA BUSINESS PARK D.H SIEMENS BUSINESS PARK	Jl. Let. Jend. MT HaryoNo Kav. 58-60 Pancoran Jakarta 12780	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
221	NAP INFO	Suite 101 AB Anex Building Plaza kuningan Jl. HR Rasuna Said Kav. C11-14 Jakarta 12940	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
222	NDC JATINEGARA	Jl. Jatinegara Barat No.44 Jakarta Timur	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
223	NIX DATA CENTER BALI	NIX Data Center Bali Jl. Gatot Subroto Barat No. 333 Denpasar Barat Bali 80117	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
224	NOBLE HOUSE	Jl. Dr Ide Anak Agung Gde Agung Kav. E 4.2 No. 2 Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
225	OFFICE 8	Office 8 Building 29th Floor (SCBD) Lot 28, JL Jenderal Sudirman, Senayan, Kebayoran Baru, Jakarta Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
226	OFFICE TOWER	Office Tower Lt 7 Unit 11 Grand Sudirman Balikpapan 76113	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
227	Intiland Tower Surabaya	Intiland Tower 3rd Floor Jl. Panglima Sudirman 101-103 - Surabaya 60271	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
228	PACIFIC BUILDING	Jl. Laksda Adisucio No. 157 Yogyakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
229	PALMA TOWER	Jl. RA Kartini II-S Kav. 6 Sektor II Kec. Kebayoran Lama Kel. Pondok Pinang Jakarta Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
230	PARIS VAN JAVA	l. Sukajadi no.131-139, Bandung-Jawa Barat 40162	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
231	PASAR ATUM SURABAYA	Jl. Bunguran 45 Surabaya 60161	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
232	PERKANTORAN HIJAU ARKADIA (TOWER B)	Perkantoran Hijau Arkadia Estate Management Office 2nd Floor Jl. Let Jend TB Simatupang Kav. 88 Jakarta 12520	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
233	PERKANTORAN HIJAU ARKADIA (TOWER C)	Perkantoran Hijau Arkadia Estate Management Office 2nd Floor Jl. Let Jend TB Simatupang Kav. 88 Jakarta 12520	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
308	VINILON BUILDING	Jl. Raden Saleh No. 13-17 Jakarta Pusat 10430	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
234	PERKANTORAN HIJAU ARKADIA (TOWER E)	Perkantoran Hijau Arkadia Estate Management Office 2nd Floor Jl. Let Jend TB Simatupang Kav. 88 Jakarta 12520	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
235	PERKANTORAN HIJAU ARKADIA (TOWER F)	Perkantoran Hijau Arkadia Estate Management Office 2nd Floor Jl. Let Jend TB Simatupang Kav. 88 Jakarta 12520	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
236	PERKANTORAN HIJAU ARKADIA (TOWER G)	Perkantoran Hijau Arkadia Estate Management Office 2nd Floor Jl. Let Jend TB Simatupang Kav. 88 Jakarta 12520	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
237	PLAZA 89	Jl. HR Rasuna Said Kav. X-7 No. 6 Jakarta 12940	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
238	PLAZA AMINTA	Jl. Let. Jend TB Simatupang Kav. 10 Jakarta Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
239	PLAZA BANK INDEX D.H PLAZA PERMATA	Jl. MH Thamrin No. 57 - Jakarta Pusat 10350	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
240	PLAZA BRI II	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
347	PLAZA BRI SURABAYA	Jl. Basuki Rahmat No. 122 - 138, Surabaya - Jawa Timur	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
241	PLAZA BRI SURABAYA	Jl. Basuki Rahmat No. 122 - 138, Surabaya - Jawa Timur	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
242	PLAZA GAJAH MADA	Lippo Cyber Park Jl. Boulevard Gajahmada No. B 2058 Kec. Cibodas Kel. Panunggangan Barat Karawaci � Tangerang 15811	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
243	PLAZA KALIBATA	Plaza Kalibata Lt. UG Jl. Raya Kalibata RT 3/ RW 2 Rawajati Pancoran Jakarta Selatan 12750	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
244	PLAZA KUNINGAN	Plant Building Jl. HR Rasuna Said Kav. C 11-14 Karet Setiabudi Jakarta Selatan 12940	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
245	PLAZA MADIUN	Lippo Cyber Park Jl. Boulevard Gajahmada No. B 2058 Kec. Cibodas Kel. Panunggangan Barat Karawaci � Tangerang 15811	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
246	PLAZA MASPION	Jl. Gunung Sahari Raya Kav. 18 Jakarta Utara 14420	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
247	PONDOK INDAH OFFICE TOWER D.H WISMA PONDOK INDAH 1	Jl. Sultan Iskandar Muda Pondok Indah Kav. V-TA - Jakarta Selatan 12310	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
248	PONDOK INDAH OFFICE TOWER D.H WISMA PONDOK INDAH 3	Jl. Sultan Iskandar Muda Pondok Indah Kav. V-TA - Jakarta Selatan 12310	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
249	PROTELINDO	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
250	PROTELINDO - NON TITAN	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
251	PROTELINDO - TITAN	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
252	PROTELINDO (TITAN)	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
253	PUSAT GROSIR CILILITAN (PGC)	Jl. Meyjen Sutoyo No. 76 Cililitan Kramat Jati - Jakarta Timur	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
254	PUSAT GROSIR METRO TANAH ABANG	Pusat Grosir Metro Tanah Abang Kp. Bali, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10250	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
255	PUSAT GROSIR PASAR PAGI MANGGA DUA	Gedung Pusat Grosir Pasar Pagi Mangga Dua Lt. 7 Blok D Jl. Mangga 2 Raya Jakarta Utara - 14430	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
256	PUSAT GROSIR SENEN	Jl. St Senen RW 3 Senen Jakarta 10410	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
257	PUSAT GROSIR TANAH ABANG	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
258	RAFFLES RESIDENCE JAKARTA	Residential Apartment - Unit 37 D (37th floor) Raffles Residences, JL. Prof. Dr. Satrio Kav. 3-5, Jakarta 12940.	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
259	RATU PLAZA	RATU PLAZA	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
260	RATU PRABU 2	Gedung Ratu Prabu 2 Jl. TB Simatupang Kav. 1B Jakarta - 12560	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
261	RUKO KANTOR TAMAN A9	Kantor Taman A9 unit C5 C6 dan C7 Jl. DR Ide Anak Agung Gde Agung Kawasan Mega Kuningan Lot 8.9/9 Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
262	RUKO RICH PALACE	Jl. Mayjend Sungkono, Dukuh Pakis, Surabaya, Indonesia 60225	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
263	RUMAH INDONET D.H. INDONET	Jl. Rempoa Raya No. 11 Ciputat Tangerang Selatan Banten 15412	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
264	RUMAH SAKIT JAKARTA	Jl. Garnisun No. 1 Jenderal Sudirman Jakarta Selatan 12930	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
265	SAMPOERNA STRATEGIC SQUARE D.H. SUDIRMAN SQUARE	Jl. Jend Sudirman Kav. 45-46 Jakarta 12930	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
266	SAMUDERA DATA INDONESIA	Jl. Kuningan Barat No. 8 Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
267	SASTRA GRAHA	Jl. Raya Perjuangan No. 21 Jakarta 11530	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
268	Sentra Grosir Cikarang	Jl. R.E. Martadinata Kel. Cikarang Kota, Kec. Cikarang Utara, Bekasi	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
269	SENTRAL SENAYAN I & II	Jl. Asia Afrika No. 8 Gelora Bung Karno - Senayan Jakarta Pusat 10270	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
270	SENTRAL SENAYAN III	Jl. Asia Afrika No. 8 Gelora Bung Karno - Senayan Jakarta Pusat 10270	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
271	SGC CIKARANG	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
272	SIGMA SENTUL	Jl. Kapt Soebijanto DJ, Bumi Serpong Damai, Tangerang Selatan, 15321	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
273	SIGMA SERPONG D/H GERMAN CENTER INDONESIA	Jl. Kapt Soebijanto DJ, Bumi Serpong Damai, Tangerang Selatan, 15321	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
274	SIGMA SURABAYA	Jl. Kapt Soebijanto DJ, Bumi Serpong Damai, Tangerang Selatan, 15321	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
275	SINARMAS LAND PLAZA D.H. PLAZA BII	Jl. MH Thamrin No. 51 Jakarta 10350	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
276	SINARMAS LAND PLAZA MEDAN	Jl. Diponegoro No. 18 Medan 20152	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
277	SME TOWER BUILDING	Jl. Jend. Gatot Subroto Kav. 94 Jakarta Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
278	SONA TOPAS TOWER	Jl. Jend. Sudirman Kav. 26 Jakarta 12920	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
279	ST MORITZ MALL	Kawasan Residensial dan Komersial The St. Moritz di Kembangan Selatan, Kec. Kembangan, Kota Jakarta Barat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
280	ST MORITZ OFFICE	Kawasan Residensial dan Komersial The St. Moritz di Kembangan Selatan, Kec. Kembangan, Kota Jakarta Barat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
281	STP	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
282	SUMATERA EXPO	Jl. Engku Putri Kav. 1 Batam Center Kec.Batam Kota - Kota Batam	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
283	SUMMITMAS 2	Jl. Jend. Sudirman Kav. 61-62 Jakarta 12190	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
284	TALAVERA SUITE	Jl. TB Simatupang Kav. 22-26 Jakarta 12430	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
285	TANGERANG CITY MALL	Jl. Jend. Sudirman No. 1 Cikokol - Tangerang 15117	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
286	TELKOMSAT PARUNG	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
287	TEMPO PAVILION 1 & 2	Tampo pavilion	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
288	TEMPO SCAN TOWER	Jl. HR Rasuna Said Kav. 10-11 Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
289	THE BELLEZA SHOPPING ARCADE	The Belleza Shopping Arcade 1st Floor No. 61 Jl.Letjend Soepona No. 34 Arteri Permata Hijau Jakarta 12210	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
290	THE CITY CENTER BATAVIA TOWER ONE	Jl. KH Mas Mansyur Kav. 126 Jakarta Pusat 10220	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
291	THE EAST TOWER	Jl. Dr Ide Anak Agung Gde Agung Kav. E.3.2 No. 1 Jakarta 12950	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
292	THE ENERGY	SCBD lot 11 A Jl. Jend. Sudirman Kav. 52-53 - Jakarta 12190	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
293	THE VIDA BUILDING	Jl. Raya Perjuangan No. 8 Jakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
294	THEEMATIC MAJALAYA	Jl. Anyar, Majasetra, Kec. Majalaya, Bandung, Jawa Barat 40382	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
295	TLP MITRATEL	Telkom Landmark Tower (TLT) Lt. 27, Jl. Jend. Gatot Subroto Kav. 52	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
296	TLP Obelisk CMI	TCC Batavia Tower One 16th & 19th Floor Jl. KH. Mas Mansyur Kav. 126 Jakarta Pusat DKI Jakarta 10220 Indonesia	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
297	TLP OBELISK EMA	EPID MENARA ASSETCO, PT TCC Batavia Tower One Lantai 16 DKI Jakarta	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
298	TLP PROTELINDO	Jl. Tanjung Karang No. 11 Desa Jati Kulon Jawa Tengah	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
299	TOL JASA MARGA	Jasamarga Cabang Tol Jagorawi Plaza Tol Taman Mini Indonesia Indah Jakarta 13550	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
300	TOTAL BUILDING	Total Building, Ground Floor. Jl. Letjen S. Parman Kav. 106 A, Tomang, Jakarta Barat 11440	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
301	TOWER BERSAMA GROUP (TBG)	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
302	TOWER MANAGEMENT GROUP (TMG)	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
303	TRIHAMAS BUILDING	Jl. TB Simatupang Kav. 11 Jakarta Selatan 12530	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
304	TRILLIUM OFFICE & RESIDENCE	Jl. Pemuda No. 108-116 Surabaya 60217	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
305	UNIPLAZA BUILDING (UNILAND)	Jl. Letjend MT Haryono No. A-1 Medan 20231	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
306	USAHA GEDUNG MANDIRI D.H USAHA GEDUNG BANK DAGANG NEGARA	Jl. Imam Bonjol No. 7 Medan 20112	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
307	VENTURA BUILDING	Ventura Building Jl. RA Kartini 26 Jakarta 12430	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
309	WISMA 46 KOTA BNI	Jl. Jend. Sudirman Kav. 1 Jakarta 10220	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
310	WISMA 77	Jl. S Parman Kav. 77 Slipi Jakarta Barat 11410	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
311	WISMA ANTARA	Jl. Medan Merdeka Selatan No. 17 Jakarta Pusat 10110	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
312	WISMA BAKRIE 2	Wisma Bakrie 2, Kav.B-2 Jalan HR. Rasuna Said 12920	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
313	WISMA BARITO PACIFIC	Jl. Let Jend sParman Kav. 62 -63 Slipi Jakarta 11410	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
314	WISMA BCA	Jl. Grand Boulevard BSD Green Office Park BSD City Tangerang 15345	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
315	WISMA BSG	Jl. Abdul Muis No. 40 Jakarta 10160	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
316	WISMA BUMIPUTERA D.H. GRAHA BUMIPUTERA	Jl. Asia Afrika No. 141-149 Bandung 40112	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
317	WISMA EKA JIWA	Kantor Pengelola Wisma Eka Jiwa Lt.2 201 Arteri Mangga 2 Jakarta 10730	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
318	WISMA GADING PERMAI	Jl. Raya Boulevard Blok CN 1 Kelapa Gading Jakarta 14240	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
319	WISMA GKBI	Jl. Jend. Sudirman No. 28 Bendungan Hilir Tanah Abang - Jakarta 10210	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
320	WISMA HAYAM WURUK	Wisma Hayam Wuruk Suite 520 5th Floor Jl. Hayam Wuruk No. 8 - Jakarta 10120	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
321	WISMA HSBC BANDUNG	Jl. Asia Afrika No. 116 Bandung 40261	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
322	WISMA HSBC SEMARANG	Wisma HSBC	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
323	WISMA INDOMOBIL	Gedung Wisma Indomobil 1 Jl. MT Haryono Kav. 8 Jakarta 13330	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
324	WISMA INDOVISION	Jl. Raya Panjang Blok Z/III Kebon Jeruk Jakarta Barat 11520	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
325	WISMA KAWASAN INDUSTRI MEDAN	Jl. Pulau Batam No. 1 Kompleks KIM Tahap II Medan Sumatera Utara	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
326	WISMA KEIAI D.H WISMA KYOEI PRINCE	Jl. Jend. Sudirman Kav. 3 Jakarta 10220	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
327	WISMA KODEL	Wisma Kodel Lt. 9 Jl. HR Rasuna Said Kav. B-4 Jakarta 12910	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
328	WISMA MULIA	Jl. JendGatot Subroto No. 42 Jakarta 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
329	WISMA MULIA 2	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
330	WISMA NUSANTARA	Gedung annex Lt dasar jl. M.H Thamrin No. 59	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
331	WISMA STACO	Wisma Staco	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
332	WISMA TAMARA	Jl. Jend. Sudirman Kav. 24, Sudirman, Jakarta Selatan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
333	WORLD TRADE CENTRE /WTC 3	Jl. Jend Sudirman Kav. 29-31 Jakarta 12926	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
334	WORLD TRADE CENTRE/ WTC 5 D.H WISMA METROPOLITAN I	Jl. Jend Sudirman Kav. 29-31 Jakarta 12926	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
335	WORLD TRADE CENTRE/ WTC 6 D.H WISMA METROPOLITAN II	Jl. Jend Sudirman Kav. 29-31 Jakarta 12926	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
336	WTC MANGGA DUA	Jl. Mangga Dua Raya Kav. 8 Jakarta 14433	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
337	Acasia Junior2	jalan merdek	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
338	Menara Mulia (Dapen BRI)	Menara Mulia	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
339	Kemang Village	Kemang	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
342	NEUCENTRIX BALIKPAPAN	DC NeuCentrIX Batu Ampar Jl. MT Haryono No. 169 Balikpapan	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
343	KAWASAN INDUSTRI CANDI	Jl. Gatot Subroto Kawasan Industri Candi Tahap V No.	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
344	WISMA SIER	JL. Rungkut Industri 1V No. 5-11, Kutisari, Kec. Tenggilis Mejoyo	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
345	WISMA KALLA	Jl.Dr.Sam Ratulangi No.8 Makasar	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
346	BDX DC LA TECHNOPARK	DC Taman Tekno Komplek Pergudangan Taman Tekno Blok D No.8, BSD, Setu, Kec. Setu, Kota Tangerang Selatan, Banten 15314	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
348	Menara 165	Jl. TB. Simatupang Kav. 1 Cilandak Timur\nJakarta Selatan 12560	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
349	GRAND KEBON SIRIH	Jl. Kebon Sirih Raya No. 35	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
359	GRAHA PARAMITA II BINTARO	Jl. Denpasar Raya Blok D2 Kav.8, Kuningan Jakarta 12940	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
350	GRAHA PARAMITA II BINTARO	Jl. Denpasar Raya Blok D2 Kav.8, Kuningan Jakarta 12940	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
351	Cyber 1 MVNet	Cyber 1	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
352	CNI Cyber	Gedung Cyber Lt. 9, Jl. Kuningan Barat I No. 8, RT.001/003, Mampang Prapatan Jakarta Selatan 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
353	KAWASAN INDUSTRI JATAKE	Jalan Industri IV Blok AG No. 4 Kawasan Industri Jatake, Tangerang	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
354	HDC TELKOM DELTA MAS	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
355	PAM TOWER	bsb ba	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
356	MENARA DANAREKSA	Gedung Menara Danareksa, Lt. GF Zona A Jl. Medan Merdeka Selatan No.13 RT.11/RW 2. Kel. Gambir, Kec. Gambir, Kota Jakarta Pusat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
357	PT. Dunia Virtual Online	Jl. Raya Tapos No. 31, Kota Depok, \nJawa Barat 16459	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
358	DC VISIONET	Jl. Boulevard Gajah Mada No.2120, RT.001/RW.009, Panunggangan Bar., Kec. Cibodas, Kota Tangerang, Banten 15811	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
360	KAWASAN INDOTAISEI	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
361	APJII UNILAND	UNI PLAZA	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
362	NIX BALI	Jl. Kuningan Barat No. 8, Jakarta Selatan 12710	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
363	Intiland Surabaya	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
364	BBU Bandung (Wisma Bumiputera)	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
365	MENARA BIDAKARA 1	Jl. Gatot Subroto Kav. 71-73\nJakarta Selatan - 12870	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
366	Apartemen Puri Casablanca	Jl. Puri Casablanca No. 1, Jakarta 12870	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
367	WISMA MANDIRI 1	Wisma Mandiri 1 Jl. M.H. Thamrin Kav. 5, Menteng, Jakarta Pusat	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
368	WANRIAU INDOXP	Pekanbaru, Kota Pekanbaru, Riau, Indonesia	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
369	DP MALL SEMARANG	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
371	AREA 31	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
370	AREA 31	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
372	PLAZA DWIMA	Jl. Jend Ahmad Yani Kav. 67 Jakarta Pusa	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
373	DC Permata Hayam Wuruk	Jl. Hayam Wuruk No.84 9, RT.9/RW.5, Maphar, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11160	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
374	MENARA SUN LIFE	MENARA SUNL	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
375	WTC SUDIRMAN	WTC SUDIRMAN	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
376	GEDUNG GRAHA SUCONFINDO	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
377	APJII SURABAYA	INTILAND	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
379	APJII UII YOGYAKARTA	GLOBAL PRIMA UTAMA	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
378	APJII UII YOGYAKARTA	GLOBAL PRIMA UTAMA	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
380	APJII Jakarta	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
381	UNILAND MEDAN	N/A	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
382	VOZA TOWER	Jln HR Muhammad No 31	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
383	TAMARA CENTER	TAMARA CENTER	\N	\N	\N	\N	active	2026-02-05 04:51:02.664394	2026-02-05 19:24:31.739445	\N	\N	Indonesia
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

COPY public.orders (id, user_id, location_id, tier_id, location_name, status, notes, created_at, updated_at, bandwidth_mbps, service_type, zone, source, whatsapp_number, service_category, a_end, b_end) FROM stdin;
1	4	\N	1	Test Location	pending	uji	2026-02-05 11:08:59.671483	2026-02-05 11:08:59.671483	\N	\N	\N	frontend	\N	\N	\N	\N
2	3	\N	\N	Graha Bip	pending	User memilih paket 2 Mbps dari halaman hasil (Graha Bip)	2026-02-05 12:15:52.474824	2026-02-05 12:15:52.474824	2	domestic	Zone 2	results_page	+6288293673283	\N	\N	\N
3	3	\N	\N	Graha Bip	pending	User memilih paket 2 Mbps dari halaman hasil (Graha Bip)	2026-02-05 12:15:55.774386	2026-02-05 12:15:55.774386	2	domestic	Zone 2	results_page	+6288293673283	\N	\N	\N
4	3	\N	\N	Graha Bip	pending	User memilih paket 2 Mbps dari halaman hasil (Graha Bip)	2026-02-05 12:15:56.522681	2026-02-05 12:15:56.522681	2	domestic	Zone 2	results_page	+6288293673283	\N	\N	\N
5	3	\N	\N	Graha Bip	pending	User memilih paket 2 Mbps dari halaman hasil (Graha Bip)	2026-02-05 12:15:57.053141	2026-02-05 12:15:57.053141	2	domestic	Zone 2	results_page	+6288293673283	\N	\N	\N
\.


--
-- Data for Name: price_list; Type: TABLE DATA; Schema: public; Owner: netpoint_user
--

COPY public.price_list (id, bandwidth_mbps, domestic_otc, domestic_mrc_zone1, domestic_mrc_zone2, domestic_mrc_zone3, domestic_mrc_zone4, intl_otc, intl_mrc_zone1, intl_mrc_zone2, intl_mrc_zone3, intl_mrc_zone4, dia_otc, dia_mrc, idia_bw, idia_otc, idia_mrc, year, status, created_at, updated_at, metronet_otc, metronet_mrc_zone1, metronet_mrc_zone2, metronet_mrc_zone3, metronet_mrc_zone4, dc2dc_otc, dc2dc_mrc, darkfiber_otc, darkfiber_mrc_per_core) FROM stdin;
1	2	548.00	209.00	220.00	237.00	263.00	548.00	261.00	275.00	296.00	328.00	548.00	216.00	10	548.00	189.00	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
2	4	548.00	247.00	259.00	279.00	310.00	548.00	308.00	324.00	349.00	388.00	548.00	222.00	25	548.00	240.00	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
3	6	548.00	261.00	275.00	295.00	328.00	548.00	326.00	343.00	369.00	410.00	548.00	256.00	50	548.00	304.00	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
4	8	548.00	275.00	290.00	311.00	346.00	548.00	344.00	362.00	389.00	433.00	548.00	290.00	100	548.00	396.00	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
5	10	548.00	290.00	305.00	328.00	364.00	548.00	362.00	381.00	410.00	455.00	548.00	323.00	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
6	20	548.00	348.00	367.00	394.00	438.00	548.00	435.00	458.00	493.00	548.00	548.00	406.00	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
7	30	548.00	433.00	456.00	490.00	544.00	548.00	541.00	570.00	612.00	681.00	548.00	487.00	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
8	40	548.00	505.00	531.00	571.00	635.00	548.00	631.00	664.00	714.00	793.00	548.00	568.00	\N	\N	0.00	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
9	50	548.00	576.00	607.00	652.00	725.00	548.00	720.00	758.00	815.00	906.00	548.00	648.00	\N	\N	0.00	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
10	60	548.00	648.00	682.00	733.00	815.00	548.00	810.00	853.00	917.00	1019.00	548.00	728.00	\N	\N	0.00	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
11	70	548.00	720.00	758.00	815.00	905.00	548.00	900.00	947.00	1018.00	1131.00	548.00	806.00	\N	\N	0.00	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
12	80	548.00	791.00	833.00	896.00	995.00	548.00	989.00	1041.00	1120.00	1244.00	548.00	884.00	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
13	90	548.00	863.00	908.00	977.00	1085.00	548.00	1079.00	1136.00	1221.00	1357.00	548.00	961.00	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
14	100	548.00	901.00	949.00	1020.00	1134.00	548.00	1127.00	1186.00	1275.00	1417.00	548.00	1027.00	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
15	200	548.00	1083.00	1140.00	1226.00	1362.00	548.00	1222.00	1286.00	1383.00	1536.00	548.00	1399.00	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
16	300	548.00	1325.00	1395.00	1500.00	1666.00	548.00	1494.00	1573.00	1691.00	1879.00	548.00	1919.00	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
17	400	548.00	1567.00	1649.00	1774.00	1971.00	548.00	1767.00	1860.00	2000.00	2223.00	548.00	2501.00	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
18	500	548.00	1809.00	1904.00	2047.00	2275.00	548.00	2040.00	2147.00	2309.00	2566.00	548.00	2879.00	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
19	600	548.00	2051.00	2159.00	2321.00	2579.00	548.00	2313.00	2435.00	2618.00	2909.00	548.00	3323.00	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
20	700	548.00	2293.00	2413.00	2595.00	2883.00	548.00	2586.00	2722.00	2927.00	3252.00	548.00	3825.00	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
21	800	548.00	2535.00	2668.00	2869.00	3188.00	548.00	2859.00	3009.00	3236.00	3595.00	548.00	4316.00	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
22	900	548.00	2777.00	2923.00	3143.00	3492.00	548.00	3131.00	3296.00	3544.00	3938.00	548.00	4798.00	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
23	1000	548.00	3018.00	3177.00	3416.00	3796.00	548.00	3404.00	3583.00	3853.00	4281.00	548.00	5269.00	\N	\N	\N	2026	active	2026-02-05 04:51:02.766412	2026-02-27 20:28:11.00416	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
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
-- Data for Name: quote_logs; Type: TABLE DATA; Schema: public; Owner: netpoint_user
--

COPY public.quote_logs (id, user_id, source, bandwidth_mbps, service_type, zone, price_list_id, building_id, building_name, location_query, otc, mrc, whatsapp_number, status, notes, metadata, created_at, updated_at, service_category, a_end, b_end) FROM stdin;
1	1	admin_quote	2	international	Zone 2	1	\N	\N	\N	8500000.00	4261576.79	\N	pending	\N	\N	2026-02-05 10:56:19.431032	2026-02-05 10:56:19.431032	\N	\N	\N
2	\N	public_quote	100	domestic	Zone 1	14	\N	\N	\N	8500000.00	13970895.12	\N	pending	\N	\N	2026-02-24 16:15:16.183324	2026-02-24 16:15:16.183324	\N	\N	\N
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
6	1	8fb2b6b7f554949262847ed68052bb5c5613abc88b1eb46a5a3e6bce563b13b9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0	119.2.41.234	2026-03-07 06:34:11.3	\N	\N	2026-02-05 06:34:11.301207
7	3	3eecb141ad59f778a185f445c3f788041a535e9b54a6258d665dccdd0792cfd7	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0	119.2.41.234	2026-03-07 06:44:51.244	\N	\N	2026-02-05 06:44:51.244921
8	1	1442b56a8312d7dbf5aca360b7a46c8a7e8606f38436ed18d1943752328faa7b	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0	119.2.41.234	2026-03-07 06:45:38.84	\N	\N	2026-02-05 06:45:38.841023
9	3	87682b4f9e6159515d04d9f4617ac7061458451700ac1d9b0d236ca5d354a368	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0	119.2.41.234	2026-03-07 06:46:24.572	\N	\N	2026-02-05 06:46:24.572975
10	1	6f2b123f9501edd8a15c4f8cca51218e2ad6edfdacd802045dd928daf2232fe6	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 07:42:48.386	\N	\N	2026-02-05 07:42:48.387004
11	1	af56203a8dd41a7f1c3e263a98cf0c75a8caa97d40fdae020a20510b12654f8a	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 10:48:12.842	\N	\N	2026-02-05 10:48:12.843621
12	1	f7253835bb67bc095210a0874f8dd10cd6c6e8b3d74d14dce2540b2d98cd58d2	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 10:48:41.352	\N	\N	2026-02-05 10:48:41.35338
13	1	6c04edb0c9ae5f27abcc06fd98b7d4560828059672223d78eec25ce93c8daca4	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 10:49:07.753	\N	\N	2026-02-05 10:49:07.754375
14	1	8c527f84b3aeab59659ce68b3326381f050fe3197f71e071e4c65d4e471795cd	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 10:51:38.344	\N	\N	2026-02-05 10:51:38.345161
15	1	f2ba772cfefcf3023e74e5d4a71916334e820f864e345b1898a0a5d733b055d5	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 10:51:55.386	\N	\N	2026-02-05 10:51:55.387261
16	1	f5454c0d21f32ebc014ef01c6917246268677737225b43b9ab3594e2b92a1c41	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 10:52:30.726	\N	\N	2026-02-05 10:52:30.727047
17	1	581400d94720fae3de1ca8599bef6ee71d967ea3a2bca29429a2609c98989841	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 10:56:19.398	\N	\N	2026-02-05 10:56:19.398939
18	3	63dfb6c5a9a35b7b96fb4c759e9fbc407849ebbf7cff7f212d7a1c44517f3130	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0	103.120.170.13	2026-03-07 10:56:33.02	\N	\N	2026-02-05 10:56:33.020821
19	1	5d1f8ada9deb2c9dd3b6ca0c314ebcb21bf3a12f16c28da86eb5c2262a97c625	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 10:57:20.364	\N	\N	2026-02-05 10:57:20.365014
20	1	7734b468554a4e95eb5c83e8db738f231214dc5a0ec51e078bf8108a69364322	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 10:58:08.109	\N	\N	2026-02-05 10:58:08.110721
21	1	3f38d0906bcbb6bb441d36ff031efff098e5abd47a3a50fc78d9100e1acac2ff	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0	103.120.170.13	2026-03-07 11:02:46.78	\N	\N	2026-02-05 11:02:46.781497
22	1	fb1a9f970db011220cb4dd2088b27e727ef40c72c562e0bfc2f029e3c657fdd4	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 11:06:21.322	\N	\N	2026-02-05 11:06:21.322865
23	4	e903c6da02300aa239ce15b5b7d9c491c6485e5daec680d2b1ca1c02e96db360	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 11:08:59.64	\N	\N	2026-02-05 11:08:59.640594
24	1	921186214a9e7beca28bea99a19777d7fb069a0e916a2b7b2b91b98efbf6bea5	curl/7.81.0	::ffff:172.18.0.1	2026-03-07 11:09:23.168	\N	\N	2026-02-05 11:09:23.168857
25	3	4e997381aae8124725b25c6544f4c776a7d67f1574914e7eaf986373e908768b	Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/405.0.859829126 Mobile/15E148 Safari/604.1	103.120.170.13	2026-03-07 12:07:54.898	\N	\N	2026-02-05 12:07:54.898971
26	3	ff2e9c44ac62659a9af6b44304c37aeb59bf1eb7c9f28eeaf24d1241702b5064	Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/405.0.859829126 Mobile/15E148 Safari/604.1	103.120.170.13	2026-03-07 12:09:08.921	\N	\N	2026-02-05 12:09:08.92166
27	3	09981331a83050f9fb172fe662c550136f883d2491c8bd45ff0008d47b509e4d	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36	114.4.78.0	2026-03-07 12:10:44.067	\N	\N	2026-02-05 12:10:44.06852
28	3	c5551e0f43f6bb3f53307934ca062db15a0fa08ba725876124afff50db4087d1	Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/405.0.859829126 Mobile/15E148 Safari/604.1	103.120.170.13	2026-03-07 12:11:18.189	\N	\N	2026-02-05 12:11:18.190394
29	3	1d7ef5a86753c07d835c6fffd4ccb27e8f125b7b83d84d3aa3f9be41e8ec44fc	Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/405.0.859829126 Mobile/15E148 Safari/604.1	103.120.170.13	2026-03-07 12:12:10.936	\N	\N	2026-02-05 12:12:10.937375
30	5	ecdac8282e1cdd9b8bf2954ca783a887f5e903332a8f8119106a32c3737877c7	Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/405.0.859829126 Mobile/15E148 Safari/604.1	103.120.170.13	2026-03-07 12:13:43.692	\N	\N	2026-02-05 12:13:43.69323
31	3	48fe171fe97ffcaadc0563603cb53f475e0409af6285c61bdb44b553d86e71c4	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Mobile/15E148 Safari/604.1	114.199.107.66	2026-03-07 12:13:46.556	\N	\N	2026-02-05 12:13:46.556918
32	5	f1530164decc291c00d39c03f5836caf46ba48af33227247c6951dcd290d5c6f	Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/405.0.859829126 Mobile/15E148 Safari/604.1	103.120.170.13	2026-03-07 12:14:24.253	\N	\N	2026-02-05 12:14:24.254254
33	5	ca68210402c7c96f01e2f17cdfaebe47be1fa5eb8b8b49d066dc3d0420c054f9	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36	114.4.78.0	2026-03-07 12:14:41.244	\N	\N	2026-02-05 12:14:41.244863
34	1	e0aa49202c6bdb0c2ef878d05a98a44709e78cdefd189dff25004be8f7750499	curl/7.81.0	::ffff:172.18.0.1	2026-03-25 16:22:26.044	\N	\N	2026-02-23 16:22:26.045267
35	1	beaec581319de99bda83f0de103240cbb6e24c28b5f9ecec66f4611e888356b6	curl/7.81.0	::ffff:172.18.0.1	2026-03-26 15:59:43.213	\N	\N	2026-02-24 15:59:43.214465
36	1	f354332730fb73853184d9a5a08e3da7a0b7bdb37a825d394f3ef1b9e554edc6	curl/7.81.0	::ffff:172.18.0.1	2026-03-26 16:15:04.331	\N	\N	2026-02-24 16:15:04.332652
37	1	5036d84e6477b5eb15095631849259c7dc60d6c8cee09501f380b433a0f3eb90	curl/7.81.0	::ffff:172.18.0.1	2026-03-26 16:15:15.867	\N	\N	2026-02-24 16:15:15.868447
38	1	afe3cf8534e728fee9522f17df4ed6b07038a51d4bfaf3f2a503e69ee1d5209d	curl/7.81.0	::ffff:172.18.0.1	2026-03-26 16:15:16.017	2026-02-24 16:15:16.078748	\N	2026-02-24 16:15:16.018416
43	3	0e4c06b437460112cfeea9ae9b2d28d641b6de51ca31ccadca7e6f752e42fdea	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0	103.130.18.183	2026-03-27 17:04:05.717	\N	\N	2026-02-25 17:04:05.718294
44	1	b75ca07fa188dc0645c5bf8869b57a203e4606b6fccc4c3856f6a009ed75d7b5	curl/7.81.0	::ffff:172.18.0.1	2026-03-27 17:04:50.133	\N	\N	2026-02-25 17:04:50.134355
45	1	ebb9396aefa1a65ec52d86194e1a72c9192093971f26fa9daa6f71f30a7087c5	curl/7.81.0	::ffff:172.18.0.1	2026-03-27 17:12:03.169	\N	\N	2026-02-25 17:12:03.170337
46	1	81b26530ab9cf7609469fcf6a374ff6c32ccd056b252891448950ddc1611e478	curl/7.81.0	::ffff:172.18.0.1	2026-03-27 17:15:30.594	\N	\N	2026-02-25 17:15:30.594932
47	1	46e3096cc12a22ac3c47b11ea3ec888b789c91f3843383f483ba589e264369d3	curl/7.81.0	::ffff:172.18.0.1	2026-03-27 17:21:48.887	\N	\N	2026-02-25 17:21:48.887707
48	1	04f800df86058ad8a87e71a66be98bf724e08823d973bccfb7fc6f9a7b79f2f5	curl/7.81.0	::ffff:172.18.0.1	2026-03-27 17:22:31.191	\N	\N	2026-02-25 17:22:31.192133
49	1	6fb1e48a8d8641d2477c4722b056e9c128b5bbf8bb7dc4b8a73e91933d861e19	curl/7.81.0	::ffff:172.18.0.1	2026-03-27 17:24:11.713	\N	\N	2026-02-25 17:24:11.714338
50	1	63de2cc551eff2018d65fa2547943ef499c9a837c52b63cd2d58be650630dc57	curl/7.81.0	::ffff:172.18.0.1	2026-03-27 17:24:20.355	\N	\N	2026-02-25 17:24:20.356534
51	1	1d9aa2a0f44da5583d8450b410524c6250afda1e4f189f1d1ced56e4bec85551	curl/7.81.0	::ffff:172.18.0.1	2026-03-27 17:24:35.515	\N	\N	2026-02-25 17:24:35.515654
52	1	3efe26feb7b745183d6a8e2193f90e2c9084c6f4b063d6233f7df1cc43362a3c	curl/7.81.0	::ffff:172.18.0.1	2026-03-28 17:20:39.856	\N	\N	2026-02-26 17:20:39.85737
53	1	c6c4270e9430445a032e3ee48b6060050138b16057942dcf2ab3f50e2eabc361	curl/7.81.0	::ffff:172.18.0.1	2026-03-28 17:21:20.312	2026-02-26 17:21:20.569938	f730290fb27c0581574ba4c2f2ba410a59b68cf3c21d9c7be33e8350607fa4ab	2026-02-26 17:21:20.313568
54	1	f730290fb27c0581574ba4c2f2ba410a59b68cf3c21d9c7be33e8350607fa4ab	curl/7.81.0	::ffff:172.18.0.1	2026-03-28 17:21:20.569	\N	\N	2026-02-26 17:21:20.571759
55	1	5e284b33af47c0cd39738a015904d740d42159bf65ba0af4d4ee84188a52cc35	curl/7.81.0	::ffff:172.18.0.1	2026-03-28 17:22:14.328	2026-02-26 17:22:14.54943	1de3c132b3389091888729b4ea012c41b0e9d311baab9119df832736d33c7e3d	2026-02-26 17:22:14.329409
56	1	1de3c132b3389091888729b4ea012c41b0e9d311baab9119df832736d33c7e3d	curl/7.81.0	::ffff:172.18.0.1	2026-03-28 17:22:14.549	\N	\N	2026-02-26 17:22:14.551317
57	1	0844f7b8128aef8bf4fb653efcb003d4114561d35500ad5de86e241c2cdd047c	curl/7.81.0	::ffff:172.18.0.1	2026-03-28 17:24:29.032	2026-02-26 17:24:29.245154	87409b5424b8e4677700d608625f27000ab17b53df3a59c6fc06aa536f86b7f6	2026-02-26 17:24:29.033899
58	1	87409b5424b8e4677700d608625f27000ab17b53df3a59c6fc06aa536f86b7f6	curl/7.81.0	::ffff:172.18.0.1	2026-03-28 17:24:29.244	\N	\N	2026-02-26 17:24:29.248003
59	1	91cc86f3d91bb9fb18ed9003b0dce7083f954851613a93408c71d79a4f447a0d	curl/7.81.0	::ffff:172.18.0.1	2026-03-28 17:24:42.796	\N	\N	2026-02-26 17:24:42.797278
60	1	5e0282e0f209bed7781a0950e03f93f58893d01aaaceebad5508caea5eb07c66	curl/7.81.0	::ffff:172.18.0.1	2026-03-28 17:25:04.27	\N	\N	2026-02-26 17:25:04.270855
61	1	3797a3e7079308adcaf4b1eeeeff63744594adc4b2f1064e7a52f27865a1ae5e	curl/7.81.0	::ffff:172.18.0.1	2026-03-28 17:27:25.799	2026-02-26 17:27:26.032661	16c76db207586b9837cd6b2ddc3eb93f159b9742371428d9c7bd00ff6c1020b0	2026-02-26 17:27:25.800947
62	1	16c76db207586b9837cd6b2ddc3eb93f159b9742371428d9c7bd00ff6c1020b0	curl/7.81.0	::ffff:172.18.0.1	2026-03-28 17:27:26.032	2026-02-26 17:27:26.263635	\N	2026-02-26 17:27:26.034787
63	1	f3c43ffeda0df7d648cf315a22dafea263f55b28214d7147449894b200e894e8	curl/7.81.0	::ffff:172.18.0.1	2026-03-28 17:31:10.639	2026-02-26 17:31:10.874746	b130bff1476172e25218ae63a67330e2148db4ed83e26a50a1b3c09035a679fa	2026-02-26 17:31:10.64023
64	1	b130bff1476172e25218ae63a67330e2148db4ed83e26a50a1b3c09035a679fa	curl/7.81.0	::ffff:172.18.0.1	2026-03-28 17:31:10.874	2026-02-26 17:31:11.122156	\N	2026-02-26 17:31:10.876957
65	8	d89c02acb4fd114a2ad17aba545796b9f748730fc98558ebda7c3421823b1a06	curl/7.81.0	::ffff:172.18.0.1	2026-03-29 20:11:18.33	\N	\N	2026-02-27 20:11:18.331362
66	8	5c50d1e1e6111397046110ff7ed01b42602a8485c5a4635d71a162051ae43de7	curl/7.81.0	::ffff:172.18.0.1	2026-03-29 20:11:33.737	\N	\N	2026-02-27 20:11:33.738423
67	8	985abfc86f6dcbe9602496935aa7a7ae76c15b5851e46ed6dfd2cce17ed88715	curl/7.81.0	::ffff:172.18.0.1	2026-03-29 20:12:43.387	\N	\N	2026-02-27 20:12:43.38785
69	4	d8b8a6e1abf33107f3df6f3d7619da6ac1d2047f61834ceac7b02c833e3b6522	curl/7.81.0	38.47.180.164	2026-12-03 06:41:45.912	\N	\N	2026-11-03 06:41:45.913402
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: netpoint_user
--

COPY public.users (id, name, email, phone, password, google_id, role, created_at, updated_at) FROM stdin;
3	Dava Ardana	davaardanava10@gmail.com	+6288293673283	$2a$10$XYTSQxXLQbZ9sHB7dHaqNe0coTPsf/uCSBbieQEGklnwj.Eutr/8a	\N	user	2026-02-05 06:44:51.229484	2026-02-05 06:44:51.229484
4	tester	tester@example.com	0812	$2a$10$QBY6ar/N7gZ8XmZccqf6E.zhOMGOb7U5Wdu66n/lKufYtHz51Km1C	\N	user	2026-02-05 11:08:59.635667	2026-02-05 11:08:59.635667
5	cobasaja	cobasaja@gmail.con	+6288293673283	$2a$10$SnXxUwGqhPXmCCm067gYJe1maVnCidMFeYXUc7/5.QjoCUnuaPDtS	\N	user	2026-02-05 12:13:43.68923	2026-02-05 12:13:43.68923
1	admin	admin@netpoint.com	\N	$2a$10$xLIPHYa3Cj2fgzEyABv1a.9PKpaXKWEXQMhgKIW1Jpk6.3kpjEsMS	\N	admin	2026-02-03 15:01:35.838151	2026-02-05 05:25:39.552132
8	Test User	test@test.com	\N	$2a$10$y1gMf/t5pTIO1YW4451XQ.kSdkS.gOhi3jyqBPDGq.ItxAVNCt4fm	\N	user	2026-02-27 20:11:18.30981	2026-02-27 20:11:18.30981
\.


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: netpoint_user
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 72, true);


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

SELECT pg_catalog.setval('public.orders_id_seq', 9, true);


--
-- Name: price_list_id_seq; Type: SEQUENCE SET; Schema: public; Owner: netpoint_user
--

SELECT pg_catalog.setval('public.price_list_id_seq', 46, true);


--
-- Name: pricing_tiers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: netpoint_user
--

SELECT pg_catalog.setval('public.pricing_tiers_id_seq', 3, true);


--
-- Name: quote_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: netpoint_user
--

SELECT pg_catalog.setval('public.quote_logs_id_seq', 2, true);


--
-- Name: quotes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: netpoint_user
--

SELECT pg_catalog.setval('public.quotes_id_seq', 1, false);


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: netpoint_user
--

SELECT pg_catalog.setval('public.refresh_tokens_id_seq', 69, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: netpoint_user
--

SELECT pg_catalog.setval('public.users_id_seq', 9, true);


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
-- Name: quote_logs quote_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.quote_logs
    ADD CONSTRAINT quote_logs_pkey PRIMARY KEY (id);


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
-- Name: idx_price_bandwidth_year; Type: INDEX; Schema: public; Owner: netpoint_user
--

CREATE INDEX idx_price_bandwidth_year ON public.price_list USING btree (bandwidth_mbps, year);


--
-- Name: idx_price_list_bw_year; Type: INDEX; Schema: public; Owner: netpoint_user
--

CREATE UNIQUE INDEX idx_price_list_bw_year ON public.price_list USING btree (bandwidth_mbps, year);


--
-- Name: idx_price_status; Type: INDEX; Schema: public; Owner: netpoint_user
--

CREATE INDEX idx_price_status ON public.price_list USING btree (status);


--
-- Name: idx_price_year; Type: INDEX; Schema: public; Owner: netpoint_user
--

CREATE INDEX idx_price_year ON public.price_list USING btree (year);


--
-- Name: idx_quote_logs_status; Type: INDEX; Schema: public; Owner: netpoint_user
--

CREATE INDEX idx_quote_logs_status ON public.quote_logs USING btree (status);


--
-- Name: idx_quote_logs_user; Type: INDEX; Schema: public; Owner: netpoint_user
--

CREATE INDEX idx_quote_logs_user ON public.quote_logs USING btree (user_id);


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
-- Name: quote_logs quote_logs_building_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.quote_logs
    ADD CONSTRAINT quote_logs_building_id_fkey FOREIGN KEY (building_id) REFERENCES public.buildings(id) ON DELETE SET NULL;


--
-- Name: quote_logs quote_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: netpoint_user
--

ALTER TABLE ONLY public.quote_logs
    ADD CONSTRAINT quote_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


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

\unrestrict Sbuth7ot0jjFBLx2UzwI9hfD8xY3ow9nbbbBhvp0DGcSqeP3qe34OzFKgP0qlwA

