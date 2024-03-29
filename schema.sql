BEGIN;

-- drop all existing tables
DROP TABLE IF EXISTS h3.users_scopes;
DROP TABLE IF EXISTS h3.users;
DROP TABLE IF EXISTS h3.scopes;
DROP TABLE IF EXISTS h3.practitioners;

-- drop h3 schema
DROP SCHEMA IF EXISTS h3;

-- drop all existing functions
DROP FUNCTION IF EXISTS set_current_timestamp_updated_at();

-- create schema
CREATE SCHEMA IF NOT EXISTS h3;

-- create table for users
CREATE TABLE h3.users (
    id              SERIAL PRIMARY KEY,
    token_version   INT DEFAULT 0,
    email           VARCHAR(30) NOT NULL UNIQUE,
    first_name      VARCHAR(30),
    last_name       VARCHAR(30),
    phone_number    VARCHAR(10),
    gender_pref     VARCHAR(6),
    apoint_pref     VARCHAR(9),
    first_visit     BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

-- create a table for practitioner profile data
CREATE TABLE h3.practitioners (
  user_id           INT REFERENCES h3.users (id),
  business_name     VARCHAR(30),
  address           VARCHAR(30),
  city              VARCHAR(30),
  state             VARCHAR(30),
  zip               VARCHAR(30),
  setup_complete    BOOLEAN DEFAULT FALSE,
  modalities        VARCHAR(500),
  session_fee       VARCHAR(3),
  session_time      VARCHAR(3),
  main_focus        VARCHAR(500),
  affiliation       VARCHAR(500),
  experience        VARCHAR(2),
  biography         VARCHAR(500),
  PRIMARY KEY       (user_id),
  created_at      TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  updated_at      TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

-- create the table for scopes
CREATE TABLE h3.scopes (
  id                SERIAL PRIMARY KEY,
  name              VARCHAR(50) NOT NULL,
  description       VARCHAR NOT NULL,
  created_at        TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  updated_at        TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

-- create the user / scopes junction table
CREATE TABLE h3.users_scopes (
  user_id           INT REFERENCES h3.users (id),
  scope_id          INT REFERENCES h3.scopes (id),
  PRIMARY KEY       (user_id, scope_id)
);

-- function to update timestamp
CREATE FUNCTION set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;

-- trigger for updating td.users updated_at
CREATE TRIGGER set_h3_users_updated_at BEFORE UPDATE ON h3.users FOR EACH ROW EXECUTE PROCEDURE set_current_timestamp_updated_at();

-- trigger for updating td.scopes updated_at
CREATE TRIGGER set_h3_scopes_updated_at BEFORE UPDATE ON h3.scopes FOR EACH ROW EXECUTE PROCEDURE set_current_timestamp_updated_at();

-- trigger for updating td.practitioners updated_at
CREATE TRIGGER set_h3_practitioners_updated_at BEFORE UPDATE ON h3.practitioners FOR EACH ROW EXECUTE PROCEDURE set_current_timestamp_updated_at();