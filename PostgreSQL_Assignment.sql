-- Active: 1747498472132@@127.0.0.1@5432@conservation_db@public
create DATABASE conservation_db;

-- CREATE rangers Table
CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    region VARCHAR(255)
)


CREATE type conservation_status_type as ENUM('Endangered', 'Vulnerable');


-- CREATE species Table
CREATE TABLE species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(255),
    scientific_name VARCHAR(255),
    discovery_date DATE,
    conservation_status conservation_status_type 
)


-- CREATE sightings Table
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INTEGER REFERENCES species(species_id),
    ranger_id INTEGER REFERENCES rangers(ranger_id),
    location VARCHAR(255),
    sighting_time TIMESTAMP without time zone,
    notes TEXT
)


-- Initial data to "rangers" table
INSERT INTO rangers (name, region) VALUES
    ('Alice Green', 'Northern Hills'), 
    ('Bob White', 'River Delta'),
    ('Carol King', 'Mountain Range');


-- Initial data to "species" table
INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
    ('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
    ('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
    ('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
    ('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered')


-- Initial data to "sightings" table
INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
    (1,1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
    (2,2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
    (3,3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
    (1,2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL)


-- 1. Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'

INSERT INTO rangers (name, region) VALUES ('Derek Fox', 'Coastal Plains')


-- 2️. Count unique species ever sighted

SELECT count(DISTINCT species_id) as "unique_species_count" from sightings


-- 3. Find all sightings where the location includes "Pass"
SELECT * from sightings WHERE location ILIKE('%Pass%')


-- 4. 