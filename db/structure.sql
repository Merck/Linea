--Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
-- PostgreSQL database dump
--
SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: algorithms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE algorithms (
    id integer NOT NULL,
    name character varying,
    path character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: algorithms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE algorithms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: algorithms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE algorithms_id_seq OWNED BY algorithms.id;


--
-- Name: columns; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE columns (
    id integer NOT NULL,
    name character varying,
    description text,
    data_type character varying,
    business_name text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_business_key boolean,
    table_id integer
);


--
-- Name: columns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE columns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: columns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE columns_id_seq OWNED BY columns.id;


--
-- Name: contributors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contributors (
    id integer NOT NULL,
    dataset_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: contributors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contributors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contributors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contributors_id_seq OWNED BY contributors.id;


--
-- Name: dataset_algorithms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dataset_algorithms (
    id integer NOT NULL,
    dataset_id integer,
    algorithm_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: dataset_algorithms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dataset_algorithms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataset_algorithms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dataset_algorithms_id_seq OWNED BY dataset_algorithms.id;


--
-- Name: dataset_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dataset_tags (
    id integer NOT NULL,
    taggedby_id integer,
    tag_id integer,
    dataset_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: dataset_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dataset_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataset_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dataset_tags_id_seq OWNED BY dataset_tags.id;


--
-- Name: dataset_visual_tools; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dataset_visual_tools (
    id integer NOT NULL,
    name character varying,
    dataset_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: dataset_visual_tools_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dataset_visual_tools_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataset_visual_tools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dataset_visual_tools_id_seq OWNED BY dataset_visual_tools.id;


--
-- Name: datasets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE datasets (
    id integer NOT NULL,
    name character varying,
    description text,
    terms_of_service_id integer,
    owner_id integer,
    subject_area_id integer,
    country_code character varying,
    size integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    dataset_hash character varying,
    datasource_id integer,
    restricted character varying DEFAULT 'private'::character varying,
    status character varying DEFAULT 'unknown'::character varying,
    external_id character varying,
    domain character varying,
    ingested boolean DEFAULT false,
    middlegate_type character varying
);


--
-- Name: datasets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE datasets_id_seq OWNED BY datasets.id;


--
-- Name: datasources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE datasources (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: datasources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE datasources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: datasources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE datasources_id_seq OWNED BY datasources.id;


--
-- Name: elasticsearch_sources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE elasticsearch_sources (
    id integer NOT NULL,
    user_elasticsearch_solution_id integer,
    dataset_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: elasticsearch_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE elasticsearch_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: elasticsearch_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE elasticsearch_sources_id_seq OWNED BY elasticsearch_sources.id;


--
-- Name: ingest_activities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ingest_activities (
    id integer NOT NULL,
    dataset_id integer,
    user_id integer,
    comment text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ingest_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ingest_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ingest_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ingest_activities_id_seq OWNED BY ingest_activities.id;


--
-- Name: like_activities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE like_activities (
    id integer NOT NULL,
    dataset_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: like_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE like_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: like_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE like_activities_id_seq OWNED BY like_activities.id;


--
-- Name: lineages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lineages (
    id integer NOT NULL,
    child_dataset_id integer,
    parent_dataset_id integer,
    operation character varying,
    comment character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    algorithm_id integer
);


--
-- Name: lineages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lineages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lineages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lineages_id_seq OWNED BY lineages.id;


--
-- Name: newsfeed_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE newsfeed_items (
    id integer NOT NULL,
    like_activity_id integer,
    share_activity_id integer,
    review_activity_id integer,
    ingest_activity_id integer,
    dataset_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    update_activity_id integer
);


--
-- Name: newsfeed_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE newsfeed_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: newsfeed_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE newsfeed_items_id_seq OWNED BY newsfeed_items.id;


--
-- Name: request_accesses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE request_accesses (
    id integer NOT NULL,
    user_id integer,
    dataset_id integer,
    reason text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    emailed_owner_at timestamp without time zone,
    emailed_user_at timestamp without time zone,
    owner_id integer,
    status integer DEFAULT 0
);


--
-- Name: request_accesses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE request_accesses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: request_accesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE request_accesses_id_seq OWNED BY request_accesses.id;


--
-- Name: review_activities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE review_activities (
    id integer NOT NULL,
    user_id integer,
    dataset_id integer,
    review text,
    rating integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: review_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE review_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: review_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE review_activities_id_seq OWNED BY review_activities.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: search_activities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE search_activities (
    id integer NOT NULL,
    user_id integer,
    search_terms character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: search_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE search_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: search_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE search_activities_id_seq OWNED BY search_activities.id;


--
-- Name: share_activities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE share_activities (
    id integer NOT NULL,
    dataset_id integer,
    user_id integer,
    comment character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: share_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE share_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: share_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE share_activities_id_seq OWNED BY share_activities.id;


--
-- Name: subject_areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE subject_areas (
    id integer NOT NULL,
    name character varying,
    description character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: subject_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subject_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subject_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subject_areas_id_seq OWNED BY subject_areas.id;


--
-- Name: tables; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tables (
    id integer NOT NULL,
    name character varying,
    dataset_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: tables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tables_id_seq OWNED BY tables.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying,
    created_by_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: terms_of_services; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE terms_of_services (
    id integer NOT NULL,
    name character varying,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: terms_of_services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE terms_of_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: terms_of_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE terms_of_services_id_seq OWNED BY terms_of_services.id;


--
-- Name: update_activities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE update_activities (
    id integer NOT NULL,
    user_id integer,
    dataset_id integer,
    comment text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: update_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE update_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: update_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE update_activities_id_seq OWNED BY update_activities.id;


--
-- Name: user_elasticsearch_solutions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_elasticsearch_solutions (
    id integer NOT NULL,
    ip_address character varying,
    index_name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    host character varying,
    external_id character varying,
    port integer
);


--
-- Name: user_elasticsearch_solutions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_elasticsearch_solutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_elasticsearch_solutions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_elasticsearch_solutions_id_seq OWNED BY user_elasticsearch_solutions.id;


--
-- Name: user_solutions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_solutions (
    id integer NOT NULL,
    user_id integer,
    middlegate_serviceable_id integer,
    middlegate_serviceable_type character varying,
    status character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_solutions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_solutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_solutions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_solutions_id_seq OWNED BY user_solutions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying,
    full_name character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    password_hash character varying,
    salt character varying,
    last_login timestamp without time zone,
    is_admin boolean,
    subject_area_id integer,
    address character varying,
    country character varying,
    country_code character varying,
    department character varying,
    email character varying,
    first_name character varying,
    location character varying,
    manager character varying,
    state character varying,
    title character varying,
    postal_code character varying,
    region character varying,
    last_name character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: v2_access_control_lists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE v2_access_control_lists (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    v2_dataset_id character varying
);


--
-- Name: v2_access_control_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE v2_access_control_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: v2_access_control_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE v2_access_control_lists_id_seq OWNED BY v2_access_control_lists.id;


--
-- Name: v2_arguments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE v2_arguments (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: v2_arguments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE v2_arguments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: v2_arguments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE v2_arguments_id_seq OWNED BY v2_arguments.id;


--
-- Name: v2_columns; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE v2_columns (
    id integer NOT NULL,
    name character varying,
    descr character varying,
    type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    v2_table_id character varying
);


--
-- Name: v2_columns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE v2_columns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: v2_columns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE v2_columns_id_seq OWNED BY v2_columns.id;


--
-- Name: v2_datasets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE v2_datasets (
    id integer NOT NULL,
    type character varying,
    hdfs_folder character varying,
    jdbc_connection character varying,
    notification_uri character varying,
    owner character varying,
    public boolean,
    uri character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: v2_datasets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE v2_datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: v2_datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE v2_datasets_id_seq OWNED BY v2_datasets.id;


--
-- Name: v2_input_datasets_transformations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE v2_input_datasets_transformations (
    id integer NOT NULL,
    v2_dataset_id integer,
    v2_transformation_id integer
);


--
-- Name: v2_input_datasets_transformations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE v2_input_datasets_transformations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: v2_input_datasets_transformations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE v2_input_datasets_transformations_id_seq OWNED BY v2_input_datasets_transformations.id;


--
-- Name: v2_output_datasets_transformations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE v2_output_datasets_transformations (
    id integer NOT NULL,
    v2_dataset_id integer,
    v2_transformation_id integer
);


--
-- Name: v2_output_datasets_transformations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE v2_output_datasets_transformations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: v2_output_datasets_transformations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE v2_output_datasets_transformations_id_seq OWNED BY v2_output_datasets_transformations.id;


--
-- Name: v2_parameters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE v2_parameters (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: v2_parameters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE v2_parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: v2_parameters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE v2_parameters_id_seq OWNED BY v2_parameters.id;


--
-- Name: v2_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE v2_roles (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    v2_access_control_list_id character varying
);


--
-- Name: v2_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE v2_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: v2_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE v2_roles_id_seq OWNED BY v2_roles.id;


--
-- Name: v2_schedule_rules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE v2_schedule_rules (
    id integer NOT NULL,
    type character varying,
    job character varying,
    start_date character varying,
    frequency character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: v2_schedule_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE v2_schedule_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: v2_schedule_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE v2_schedule_rules_id_seq OWNED BY v2_schedule_rules.id;


--
-- Name: v2_schemas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE v2_schemas (
    id integer NOT NULL,
    type_domain character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    v2_dataset_id character varying
);


--
-- Name: v2_schemas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE v2_schemas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: v2_schemas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE v2_schemas_id_seq OWNED BY v2_schemas.id;


--
-- Name: v2_table_names; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE v2_table_names (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: v2_table_names_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE v2_table_names_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: v2_table_names_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE v2_table_names_id_seq OWNED BY v2_table_names.id;


--
-- Name: v2_tables; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE v2_tables (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    v2_schema_id character varying
);


--
-- Name: v2_tables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE v2_tables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: v2_tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE v2_tables_id_seq OWNED BY v2_tables.id;


--
-- Name: v2_transformations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE v2_transformations (
    id integer NOT NULL,
    type character varying,
    user_id integer,
    scheduled boolean,
    database_uri character varying,
    jdbc_driver_id character varying,
    "user" character varying,
    password character varying,
    class_path character varying,
    command character varying,
    script character varying,
    file_uri character varying,
    ingest_download_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: v2_transformations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE v2_transformations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: v2_transformations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE v2_transformations_id_seq OWNED BY v2_transformations.id;


--
-- Name: v2_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE v2_users (
    id integer NOT NULL,
    principal character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    v2_access_control_list_id character varying,
    v2_transformation_id character varying
);


--
-- Name: v2_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE v2_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: v2_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE v2_users_id_seq OWNED BY v2_users.id;


--
-- Name: view_activities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE view_activities (
    id integer NOT NULL,
    dataset_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: view_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE view_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: view_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE view_activities_id_seq OWNED BY view_activities.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY algorithms ALTER COLUMN id SET DEFAULT nextval('algorithms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY columns ALTER COLUMN id SET DEFAULT nextval('columns_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contributors ALTER COLUMN id SET DEFAULT nextval('contributors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY dataset_algorithms ALTER COLUMN id SET DEFAULT nextval('dataset_algorithms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY dataset_tags ALTER COLUMN id SET DEFAULT nextval('dataset_tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY dataset_visual_tools ALTER COLUMN id SET DEFAULT nextval('dataset_visual_tools_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY datasets ALTER COLUMN id SET DEFAULT nextval('datasets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY datasources ALTER COLUMN id SET DEFAULT nextval('datasources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY elasticsearch_sources ALTER COLUMN id SET DEFAULT nextval('elasticsearch_sources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ingest_activities ALTER COLUMN id SET DEFAULT nextval('ingest_activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY like_activities ALTER COLUMN id SET DEFAULT nextval('like_activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lineages ALTER COLUMN id SET DEFAULT nextval('lineages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY newsfeed_items ALTER COLUMN id SET DEFAULT nextval('newsfeed_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY request_accesses ALTER COLUMN id SET DEFAULT nextval('request_accesses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY review_activities ALTER COLUMN id SET DEFAULT nextval('review_activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY search_activities ALTER COLUMN id SET DEFAULT nextval('search_activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY share_activities ALTER COLUMN id SET DEFAULT nextval('share_activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subject_areas ALTER COLUMN id SET DEFAULT nextval('subject_areas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tables ALTER COLUMN id SET DEFAULT nextval('tables_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY terms_of_services ALTER COLUMN id SET DEFAULT nextval('terms_of_services_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY update_activities ALTER COLUMN id SET DEFAULT nextval('update_activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_elasticsearch_solutions ALTER COLUMN id SET DEFAULT nextval('user_elasticsearch_solutions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_solutions ALTER COLUMN id SET DEFAULT nextval('user_solutions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY v2_access_control_lists ALTER COLUMN id SET DEFAULT nextval('v2_access_control_lists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY v2_arguments ALTER COLUMN id SET DEFAULT nextval('v2_arguments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY v2_columns ALTER COLUMN id SET DEFAULT nextval('v2_columns_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY v2_datasets ALTER COLUMN id SET DEFAULT nextval('v2_datasets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY v2_input_datasets_transformations ALTER COLUMN id SET DEFAULT nextval('v2_input_datasets_transformations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY v2_output_datasets_transformations ALTER COLUMN id SET DEFAULT nextval('v2_output_datasets_transformations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY v2_parameters ALTER COLUMN id SET DEFAULT nextval('v2_parameters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY v2_roles ALTER COLUMN id SET DEFAULT nextval('v2_roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY v2_schedule_rules ALTER COLUMN id SET DEFAULT nextval('v2_schedule_rules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY v2_schemas ALTER COLUMN id SET DEFAULT nextval('v2_schemas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY v2_table_names ALTER COLUMN id SET DEFAULT nextval('v2_table_names_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY v2_tables ALTER COLUMN id SET DEFAULT nextval('v2_tables_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY v2_transformations ALTER COLUMN id SET DEFAULT nextval('v2_transformations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY v2_users ALTER COLUMN id SET DEFAULT nextval('v2_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY view_activities ALTER COLUMN id SET DEFAULT nextval('view_activities_id_seq'::regclass);


--
-- Name: algorithms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY algorithms
    ADD CONSTRAINT algorithms_pkey PRIMARY KEY (id);


--
-- Name: columns_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY columns
    ADD CONSTRAINT columns_pkey PRIMARY KEY (id);


--
-- Name: contributors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contributors
    ADD CONSTRAINT contributors_pkey PRIMARY KEY (id);


--
-- Name: dataset_algorithms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dataset_algorithms
    ADD CONSTRAINT dataset_algorithms_pkey PRIMARY KEY (id);


--
-- Name: dataset_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dataset_tags
    ADD CONSTRAINT dataset_tags_pkey PRIMARY KEY (id);


--
-- Name: dataset_visual_tools_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dataset_visual_tools
    ADD CONSTRAINT dataset_visual_tools_pkey PRIMARY KEY (id);


--
-- Name: datasets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY datasets
    ADD CONSTRAINT datasets_pkey PRIMARY KEY (id);


--
-- Name: datasources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY datasources
    ADD CONSTRAINT datasources_pkey PRIMARY KEY (id);


--
-- Name: elasticsearch_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY elasticsearch_sources
    ADD CONSTRAINT elasticsearch_sources_pkey PRIMARY KEY (id);


--
-- Name: ingest_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ingest_activities
    ADD CONSTRAINT ingest_activities_pkey PRIMARY KEY (id);


--
-- Name: like_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY like_activities
    ADD CONSTRAINT like_activities_pkey PRIMARY KEY (id);


--
-- Name: lineages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lineages
    ADD CONSTRAINT lineages_pkey PRIMARY KEY (id);


--
-- Name: newsfeed_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY newsfeed_items
    ADD CONSTRAINT newsfeed_items_pkey PRIMARY KEY (id);


--
-- Name: request_accesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY request_accesses
    ADD CONSTRAINT request_accesses_pkey PRIMARY KEY (id);


--
-- Name: review_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY review_activities
    ADD CONSTRAINT review_activities_pkey PRIMARY KEY (id);


--
-- Name: search_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY search_activities
    ADD CONSTRAINT search_activities_pkey PRIMARY KEY (id);


--
-- Name: share_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY share_activities
    ADD CONSTRAINT share_activities_pkey PRIMARY KEY (id);


--
-- Name: subject_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subject_areas
    ADD CONSTRAINT subject_areas_pkey PRIMARY KEY (id);


--
-- Name: tables_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tables
    ADD CONSTRAINT tables_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: terms_of_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY terms_of_services
    ADD CONSTRAINT terms_of_services_pkey PRIMARY KEY (id);


--
-- Name: update_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY update_activities
    ADD CONSTRAINT update_activities_pkey PRIMARY KEY (id);


--
-- Name: user_elasticsearch_solutions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_elasticsearch_solutions
    ADD CONSTRAINT user_elasticsearch_solutions_pkey PRIMARY KEY (id);


--
-- Name: user_solutions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_solutions
    ADD CONSTRAINT user_solutions_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: v2_access_control_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY v2_access_control_lists
    ADD CONSTRAINT v2_access_control_lists_pkey PRIMARY KEY (id);


--
-- Name: v2_arguments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY v2_arguments
    ADD CONSTRAINT v2_arguments_pkey PRIMARY KEY (id);


--
-- Name: v2_columns_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY v2_columns
    ADD CONSTRAINT v2_columns_pkey PRIMARY KEY (id);


--
-- Name: v2_datasets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY v2_datasets
    ADD CONSTRAINT v2_datasets_pkey PRIMARY KEY (id);


--
-- Name: v2_input_datasets_transformations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY v2_input_datasets_transformations
    ADD CONSTRAINT v2_input_datasets_transformations_pkey PRIMARY KEY (id);


--
-- Name: v2_output_datasets_transformations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY v2_output_datasets_transformations
    ADD CONSTRAINT v2_output_datasets_transformations_pkey PRIMARY KEY (id);


--
-- Name: v2_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY v2_parameters
    ADD CONSTRAINT v2_parameters_pkey PRIMARY KEY (id);


--
-- Name: v2_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY v2_roles
    ADD CONSTRAINT v2_roles_pkey PRIMARY KEY (id);


--
-- Name: v2_schedule_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY v2_schedule_rules
    ADD CONSTRAINT v2_schedule_rules_pkey PRIMARY KEY (id);


--
-- Name: v2_schemas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY v2_schemas
    ADD CONSTRAINT v2_schemas_pkey PRIMARY KEY (id);


--
-- Name: v2_table_names_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY v2_table_names
    ADD CONSTRAINT v2_table_names_pkey PRIMARY KEY (id);


--
-- Name: v2_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY v2_tables
    ADD CONSTRAINT v2_tables_pkey PRIMARY KEY (id);


--
-- Name: v2_transformations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY v2_transformations
    ADD CONSTRAINT v2_transformations_pkey PRIMARY KEY (id);


--
-- Name: v2_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY v2_users
    ADD CONSTRAINT v2_users_pkey PRIMARY KEY (id);


--
-- Name: view_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY view_activities
    ADD CONSTRAINT view_activities_pkey PRIMARY KEY (id);


--
-- Name: index_columns_on_table_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_columns_on_table_id ON columns USING btree (table_id);


--
-- Name: index_request_accesses_on_dataset_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_request_accesses_on_dataset_id ON request_accesses USING btree (dataset_id);


--
-- Name: index_request_accesses_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_request_accesses_on_user_id ON request_accesses USING btree (user_id);


--
-- Name: index_tables_on_dataset_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tables_on_dataset_id ON tables USING btree (dataset_id);


--
-- Name: index_user_services_on_middlegate_serviceable; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_services_on_middlegate_serviceable ON user_solutions USING btree (middlegate_serviceable_id, middlegate_serviceable_type);


--
-- Name: index_user_solutions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_solutions_on_user_id ON user_solutions USING btree (user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_04e24b47bf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY newsfeed_items
    ADD CONSTRAINT fk_rails_04e24b47bf FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_0adc12ff76; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lineages
    ADD CONSTRAINT fk_rails_0adc12ff76 FOREIGN KEY (parent_dataset_id) REFERENCES datasets(id);


--
-- Name: fk_rails_135eba5206; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY datasets
    ADD CONSTRAINT fk_rails_135eba5206 FOREIGN KEY (terms_of_service_id) REFERENCES terms_of_services(id);


--
-- Name: fk_rails_196e5c9b71; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY datasets
    ADD CONSTRAINT fk_rails_196e5c9b71 FOREIGN KEY (owner_id) REFERENCES users(id);


--
-- Name: fk_rails_1b0215aa1d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lineages
    ADD CONSTRAINT fk_rails_1b0215aa1d FOREIGN KEY (algorithm_id) REFERENCES algorithms(id);


--
-- Name: fk_rails_1f8cad7211; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY view_activities
    ADD CONSTRAINT fk_rails_1f8cad7211 FOREIGN KEY (dataset_id) REFERENCES datasets(id);


--
-- Name: fk_rails_1fab00a03c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY review_activities
    ADD CONSTRAINT fk_rails_1fab00a03c FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_23b15e7bde; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY view_activities
    ADD CONSTRAINT fk_rails_23b15e7bde FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_3a55713179; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY newsfeed_items
    ADD CONSTRAINT fk_rails_3a55713179 FOREIGN KEY (ingest_activity_id) REFERENCES ingest_activities(id);


--
-- Name: fk_rails_3cd363597b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY datasets
    ADD CONSTRAINT fk_rails_3cd363597b FOREIGN KEY (datasource_id) REFERENCES datasources(id);


--
-- Name: fk_rails_66465004df; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY newsfeed_items
    ADD CONSTRAINT fk_rails_66465004df FOREIGN KEY (dataset_id) REFERENCES datasets(id);


--
-- Name: fk_rails_6b4bacbc02; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY share_activities
    ADD CONSTRAINT fk_rails_6b4bacbc02 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_6ebfcd8bb6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY review_activities
    ADD CONSTRAINT fk_rails_6ebfcd8bb6 FOREIGN KEY (dataset_id) REFERENCES datasets(id);


--
-- Name: fk_rails_74a69d394c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY newsfeed_items
    ADD CONSTRAINT fk_rails_74a69d394c FOREIGN KEY (update_activity_id) REFERENCES update_activities(id);


--
-- Name: fk_rails_75adfa0433; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contributors
    ADD CONSTRAINT fk_rails_75adfa0433 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_7811bbbf5f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dataset_tags
    ADD CONSTRAINT fk_rails_7811bbbf5f FOREIGN KEY (tag_id) REFERENCES tags(id);


--
-- Name: fk_rails_7d19a49f3f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY like_activities
    ADD CONSTRAINT fk_rails_7d19a49f3f FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_7e35bd7838; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY update_activities
    ADD CONSTRAINT fk_rails_7e35bd7838 FOREIGN KEY (dataset_id) REFERENCES datasets(id);


--
-- Name: fk_rails_7edafb6fd5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contributors
    ADD CONSTRAINT fk_rails_7edafb6fd5 FOREIGN KEY (dataset_id) REFERENCES datasets(id);


--
-- Name: fk_rails_803f015a72; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ingest_activities
    ADD CONSTRAINT fk_rails_803f015a72 FOREIGN KEY (dataset_id) REFERENCES datasets(id);


--
-- Name: fk_rails_82770fcc36; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY newsfeed_items
    ADD CONSTRAINT fk_rails_82770fcc36 FOREIGN KEY (share_activity_id) REFERENCES share_activities(id);


--
-- Name: fk_rails_8bc8e11bf9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dataset_algorithms
    ADD CONSTRAINT fk_rails_8bc8e11bf9 FOREIGN KEY (algorithm_id) REFERENCES algorithms(id);


--
-- Name: fk_rails_8d3354137b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_8d3354137b FOREIGN KEY (subject_area_id) REFERENCES subject_areas(id);


--
-- Name: fk_rails_8e9745d08d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dataset_algorithms
    ADD CONSTRAINT fk_rails_8e9745d08d FOREIGN KEY (dataset_id) REFERENCES datasets(id);


--
-- Name: fk_rails_8ec2492b55; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dataset_visual_tools
    ADD CONSTRAINT fk_rails_8ec2492b55 FOREIGN KEY (dataset_id) REFERENCES datasets(id);


--
-- Name: fk_rails_b0b08ef296; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY search_activities
    ADD CONSTRAINT fk_rails_b0b08ef296 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_ba85b8adea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY like_activities
    ADD CONSTRAINT fk_rails_ba85b8adea FOREIGN KEY (dataset_id) REFERENCES datasets(id);


--
-- Name: fk_rails_bffdbba717; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lineages
    ADD CONSTRAINT fk_rails_bffdbba717 FOREIGN KEY (child_dataset_id) REFERENCES datasets(id);


--
-- Name: fk_rails_c9d789ee4e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY newsfeed_items
    ADD CONSTRAINT fk_rails_c9d789ee4e FOREIGN KEY (review_activity_id) REFERENCES review_activities(id);


--
-- Name: fk_rails_cbfe703c36; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ingest_activities
    ADD CONSTRAINT fk_rails_cbfe703c36 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_d12ba0be1b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY newsfeed_items
    ADD CONSTRAINT fk_rails_d12ba0be1b FOREIGN KEY (like_activity_id) REFERENCES like_activities(id);


--
-- Name: fk_rails_d3006b8837; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY share_activities
    ADD CONSTRAINT fk_rails_d3006b8837 FOREIGN KEY (dataset_id) REFERENCES datasets(id);


--
-- Name: fk_rails_d43fcc232e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY datasets
    ADD CONSTRAINT fk_rails_d43fcc232e FOREIGN KEY (subject_area_id) REFERENCES subject_areas(id);


--
-- Name: fk_rails_dcfa885b53; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY update_activities
    ADD CONSTRAINT fk_rails_dcfa885b53 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_e9786c7a1b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dataset_tags
    ADD CONSTRAINT fk_rails_e9786c7a1b FOREIGN KEY (dataset_id) REFERENCES datasets(id);


--
-- Name: fk_rails_f11c6891bc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dataset_tags
    ADD CONSTRAINT fk_rails_f11c6891bc FOREIGN KEY (taggedby_id) REFERENCES users(id);


--
-- Name: fk_rails_faadba6f50; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT fk_rails_faadba6f50 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140715173149');

INSERT INTO schema_migrations (version) VALUES ('20140716192026');

INSERT INTO schema_migrations (version) VALUES ('20140716193137');

INSERT INTO schema_migrations (version) VALUES ('20140716193658');

INSERT INTO schema_migrations (version) VALUES ('20140717134525');

INSERT INTO schema_migrations (version) VALUES ('20140717143429');

INSERT INTO schema_migrations (version) VALUES ('20140717150200');

INSERT INTO schema_migrations (version) VALUES ('20140717152432');

INSERT INTO schema_migrations (version) VALUES ('20140717200831');

INSERT INTO schema_migrations (version) VALUES ('20140717201733');

INSERT INTO schema_migrations (version) VALUES ('20140718132729');

INSERT INTO schema_migrations (version) VALUES ('20140718163619');

INSERT INTO schema_migrations (version) VALUES ('20140718174755');

INSERT INTO schema_migrations (version) VALUES ('20140718190210');

INSERT INTO schema_migrations (version) VALUES ('20140718192111');

INSERT INTO schema_migrations (version) VALUES ('20140718200458');

INSERT INTO schema_migrations (version) VALUES ('20140718203906');

INSERT INTO schema_migrations (version) VALUES ('20140718204828');

INSERT INTO schema_migrations (version) VALUES ('20140718205953');

INSERT INTO schema_migrations (version) VALUES ('20140718211733');

INSERT INTO schema_migrations (version) VALUES ('20140718213212');

INSERT INTO schema_migrations (version) VALUES ('20140718214051');

INSERT INTO schema_migrations (version) VALUES ('20140722201104');

INSERT INTO schema_migrations (version) VALUES ('20140722201353');

INSERT INTO schema_migrations (version) VALUES ('20140728141305');

INSERT INTO schema_migrations (version) VALUES ('20140729171607');

INSERT INTO schema_migrations (version) VALUES ('20140729180930');

INSERT INTO schema_migrations (version) VALUES ('20140729181015');

INSERT INTO schema_migrations (version) VALUES ('20140730190946');

INSERT INTO schema_migrations (version) VALUES ('20140731002004');

INSERT INTO schema_migrations (version) VALUES ('20140806174749');

INSERT INTO schema_migrations (version) VALUES ('20140806175604');

INSERT INTO schema_migrations (version) VALUES ('20140813191545');

INSERT INTO schema_migrations (version) VALUES ('20140815184648');

INSERT INTO schema_migrations (version) VALUES ('20150309143440');

INSERT INTO schema_migrations (version) VALUES ('20150317170443');

INSERT INTO schema_migrations (version) VALUES ('20150331184628');

INSERT INTO schema_migrations (version) VALUES ('20150402092917');

INSERT INTO schema_migrations (version) VALUES ('20150402165814');

INSERT INTO schema_migrations (version) VALUES ('20150402170205');

INSERT INTO schema_migrations (version) VALUES ('20150406140958');

INSERT INTO schema_migrations (version) VALUES ('20150409085303');

INSERT INTO schema_migrations (version) VALUES ('20150409085811');

INSERT INTO schema_migrations (version) VALUES ('20150410135512');

INSERT INTO schema_migrations (version) VALUES ('20150504112230');

INSERT INTO schema_migrations (version) VALUES ('20150504120355');

INSERT INTO schema_migrations (version) VALUES ('20150512133810');

INSERT INTO schema_migrations (version) VALUES ('20150513123041');

INSERT INTO schema_migrations (version) VALUES ('20150513150619');

INSERT INTO schema_migrations (version) VALUES ('20150519085026');

INSERT INTO schema_migrations (version) VALUES ('20150519092121');

INSERT INTO schema_migrations (version) VALUES ('20150519141127');

INSERT INTO schema_migrations (version) VALUES ('20150520084614');

INSERT INTO schema_migrations (version) VALUES ('20150520122450');

INSERT INTO schema_migrations (version) VALUES ('20150521105345');

INSERT INTO schema_migrations (version) VALUES ('20150616130103');

INSERT INTO schema_migrations (version) VALUES ('20150629105540');

INSERT INTO schema_migrations (version) VALUES ('20150701150258');

INSERT INTO schema_migrations (version) VALUES ('20150727113836');

INSERT INTO schema_migrations (version) VALUES ('20150727115133');

INSERT INTO schema_migrations (version) VALUES ('20150727115228');

INSERT INTO schema_migrations (version) VALUES ('20150727115250');

INSERT INTO schema_migrations (version) VALUES ('20150727121121');

INSERT INTO schema_migrations (version) VALUES ('20150727121146');

INSERT INTO schema_migrations (version) VALUES ('20150727121231');

INSERT INTO schema_migrations (version) VALUES ('20150727123443');

INSERT INTO schema_migrations (version) VALUES ('20150729122601');

INSERT INTO schema_migrations (version) VALUES ('20150729132821');

INSERT INTO schema_migrations (version) VALUES ('20150730075502');

INSERT INTO schema_migrations (version) VALUES ('20150730075532');

INSERT INTO schema_migrations (version) VALUES ('20150730082819');

INSERT INTO schema_migrations (version) VALUES ('20150730083439');

INSERT INTO schema_migrations (version) VALUES ('20150730084536');

