BEGIN;

-- drop all existing tables
DROP TABLE IF EXISTS h3.users;

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
    email           VARCHAR (30) NOT NULL UNIQUE,
    first_name      VARCHAR(30),
    last_name       VARCHAR(30),
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
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