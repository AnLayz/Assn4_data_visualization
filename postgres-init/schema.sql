--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-10-15 23:02:05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 4863 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 16956)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_trx_id text NOT NULL,
    subscriber_id text,
    subscribe_date timestamp without time zone,
    first_order_date timestamp without time zone,
    customer_postal_code text,
    customer_city text,
    customer_country text,
    customer_country_code text,
    age integer,
    gender text
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 17040)
-- Name: customers_raw; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers_raw (
    customer_trx_id text,
    subscriber_id text,
    subscribe_date text,
    first_order_date text,
    customer_postal_code text,
    customer_city text,
    customer_country text,
    customer_country_code text,
    age text,
    gender text
);


ALTER TABLE public.customers_raw OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16951)
-- Name: geolocations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.geolocations (
    geo_postal_code text,
    geo_lat double precision,
    geo_lon double precision,
    geolocation_city text,
    geo_country text
);


ALTER TABLE public.geolocations OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17091)
-- Name: geolocations_raw; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.geolocations_raw (
    geo_postal_code text,
    geo_lat text,
    geo_lon text,
    geolocation_city text,
    geo_country text
);


ALTER TABLE public.geolocations_raw OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16989)
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    order_id text NOT NULL,
    order_item_id integer NOT NULL,
    product_id text,
    seller_id text,
    shipping_limit_date timestamp without time zone,
    price numeric(12,2),
    freight_value numeric(12,2)
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17075)
-- Name: order_items_raw; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items_raw (
    order_id text,
    order_item_id text,
    product_id text,
    seller_id text,
    shipping_limit_date text,
    price text,
    freight_value text
);


ALTER TABLE public.order_items_raw OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17011)
-- Name: order_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_payments (
    order_id text NOT NULL,
    payment_sequential integer NOT NULL,
    payment_type text,
    payment_installments integer,
    payment_value numeric(12,2)
);


ALTER TABLE public.order_payments OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17085)
-- Name: order_payments_raw; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_payments_raw (
    order_id text,
    payment_sequential text,
    payment_type text,
    payment_installments text,
    payment_value text
);


ALTER TABLE public.order_payments_raw OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17023)
-- Name: order_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_reviews (
    review_id text NOT NULL,
    order_id text,
    review_score integer,
    review_comment_title_en text,
    review_comment_message_en text,
    review_creation_date timestamp without time zone,
    review_answer_timestamp timestamp without time zone
);


ALTER TABLE public.order_reviews OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17062)
-- Name: order_reviews_raw; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_reviews_raw (
    review_id text,
    order_id text,
    review_score text,
    review_comment_title_en text,
    review_comment_message_en text,
    review_creation_date text,
    review_answer_timestamp text
);


ALTER TABLE public.order_reviews_raw OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16977)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id text NOT NULL,
    customer_trx_id text,
    order_status text,
    order_purchase_timestamp timestamp without time zone,
    order_approved_at timestamp without time zone,
    order_delivered_carrier_date timestamp without time zone,
    order_delivered_customer_date timestamp without time zone,
    order_estimated_delivery_date timestamp without time zone
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16970)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_id text NOT NULL,
    product_category text,
    product_name_length_chars integer,
    product_description_length_chars integer,
    product_photos_qty integer,
    product_weight_g integer,
    product_length_cm double precision,
    product_height_cm double precision,
    product_width_cm double precision
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16963)
-- Name: sellers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sellers (
    seller_id text NOT NULL,
    seller_name text,
    seller_postal_code text,
    seller_city text,
    country_code text,
    seller_country text
);


ALTER TABLE public.sellers OWNER TO postgres;

--
-- TOC entry 4689 (class 2606 OID 16962)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_trx_id);


--
-- TOC entry 4701 (class 2606 OID 16995)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (order_id, order_item_id);


--
-- TOC entry 4704 (class 2606 OID 17017)
-- Name: order_payments order_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_payments
    ADD CONSTRAINT order_payments_pkey PRIMARY KEY (order_id, payment_sequential);


--
-- TOC entry 4706 (class 2606 OID 17029)
-- Name: order_reviews order_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_reviews
    ADD CONSTRAINT order_reviews_pkey PRIMARY KEY (review_id);


--
-- TOC entry 4696 (class 2606 OID 16983)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 4693 (class 2606 OID 16976)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- TOC entry 4691 (class 2606 OID 16969)
-- Name: sellers sellers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sellers
    ADD CONSTRAINT sellers_pkey PRIMARY KEY (seller_id);


--
-- TOC entry 4697 (class 1259 OID 17038)
-- Name: idx_items_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_items_order ON public.order_items USING btree (order_id);


--
-- TOC entry 4698 (class 1259 OID 17036)
-- Name: idx_items_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_items_product ON public.order_items USING btree (product_id);


--
-- TOC entry 4699 (class 1259 OID 17037)
-- Name: idx_items_seller; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_items_seller ON public.order_items USING btree (seller_id);


--
-- TOC entry 4694 (class 1259 OID 17035)
-- Name: idx_orders_customer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_customer ON public.orders USING btree (customer_trx_id);


--
-- TOC entry 4702 (class 1259 OID 17039)
-- Name: idx_payments_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_order ON public.order_payments USING btree (order_id);


--
-- TOC entry 4708 (class 2606 OID 16996)
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- TOC entry 4709 (class 2606 OID 17001)
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 4710 (class 2606 OID 17006)
-- Name: order_items order_items_seller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.sellers(seller_id);


--
-- TOC entry 4711 (class 2606 OID 17018)
-- Name: order_payments order_payments_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_payments
    ADD CONSTRAINT order_payments_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- TOC entry 4712 (class 2606 OID 17030)
-- Name: order_reviews order_reviews_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_reviews
    ADD CONSTRAINT order_reviews_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- TOC entry 4707 (class 2606 OID 16984)
-- Name: orders orders_customer_trx_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_trx_id_fkey FOREIGN KEY (customer_trx_id) REFERENCES public.customers(customer_trx_id);


-- Completed on 2025-10-15 23:02:05

--
-- PostgreSQL database dump complete
--

