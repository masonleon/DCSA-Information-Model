\set ON_ERROR_STOP true
DROP DATABASE IF EXISTS dcsa_openapi;
DROP USER IF EXISTS dcsa_db_owner;
CREATE USER dcsa_db_owner WITH PASSWORD 'root';
