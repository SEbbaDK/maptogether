CREATE ROLE maptogether WITH LOGIN PASSWORD 'maptogether';
CREATE DATABASE maptogether WITH OWNER maptogether ENCODING 'UTF8';
GRANT ALL PRIVILEGES ON DATABASE maptogether TO maptogether;

