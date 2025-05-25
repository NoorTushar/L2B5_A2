-- Active: 1747498472132@@127.0.0.1@5432@conservation_db
create DATABASE conservation_db;

-- CREATE rangers Table
CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    region VARCHAR(255)
)


-- CREATE species Table
CREATE TABLE species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(255),
    scientific_name VARCHAR(255),
    discovery_date DATE,
    conservation_status VARCHAR(25)
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


-- Problem 1. Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'

INSERT INTO rangers (name, region) VALUES ('Derek Fox', 'Coastal Plains')


-- Problem 2️. Count unique species ever sighted

SELECT count(DISTINCT species_id) as "unique_species_count" FROM sightings


-- Problem 3. Find all sightings where the location includes "Pass"
SELECT * FROM sightings WHERE location ILIKE('%Pass%')


-- Problem 4. List each ranger's name and their total number of sightings.

SELECT name, count(sighting_id) as "total_sightings" FROM rangers
    JOIN sightings ON "sightings".ranger_id = "rangers".ranger_id
    GROUP BY name;


-- Problem 5. List species that have never been sighted.

SELECT common_name FROM species
    LEFT JOIN sightings on "sightings".species_id = "species".species_id
    WHERE sighting_id IS NULL;


-- Problem 6. Show the most recent 2 sightings
SELECT  common_name, sighting_time, name from sightings
    JOIN species ON "sightings".species_id = "species".species_id
    JOIN rangers ON "sightings".ranger_id = "rangers".ranger_id
    ORDER BY sighting_time DESC LIMIT 2


-- Problem 7. Update all species discovered before year 1800 to have status 'Historic'

UPDATE species
    SET "conservation_status" =  'Historic' WHERE "discovery_date" < '1800-01-01'

-- Problem 8. Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.

-- Morning: before 12 PM
-- Afternoon: 12 PM–5 PM
-- Evening: after 5 PM

SELECT 
    sighting_id,
    CASE 
        WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;


-- Problem 9️. Delete rangers who have never sighted any species

DELETE FROM rangers WHERE ranger_id IN (
    SELECT "rangers".ranger_id FROM "rangers"
    LEFT JOIN sightings ON "rangers".ranger_id = "sightings".ranger_id
        WHERE "sightings".ranger_id IS NULL
);

