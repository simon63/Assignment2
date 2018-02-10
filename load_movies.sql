/* These statements should be executed only once */
CREATE DATABASE movies;
USE movies;
/*************************************************/

DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS movie;
DROP TABLE IF EXISTS rating;

CREATE TABLE person (
    id INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR(30) NOT NULL UNIQUE
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/movies/person.csv' 
INTO TABLE person
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

CREATE TABLE movie (
    id INTEGER NOT NULL PRIMARY KEY,
    title VARCHAR(60) NOT NULL UNIQUE KEY
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/movies/movie.csv' 
INTO TABLE movie
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

CREATE TABLE rating (
    person_id INTEGER NOT NULL REFERENCES person (id),
    movie_id INTEGER NOT NULL REFERENCES movie (id),
    rank INTEGER COMMENT 'rating score of each movie by a person on a scale of 1 to 5',
    CHECK (IFNULL(rank, 1) BETWEEN 1 AND 5),
    CONSTRAINT PRIMARY KEY (person_id , movie_id),
    INDEX (person_id , movie_id) COMMENT 'good practice to define an index with first column being a reference to another table (FK)',
    INDEX (movie_id , person_id) COMMENT 'index on a foreign key (FK) column'
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/movies/rating.csv' 
INTO TABLE rating
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(person_id, movie_id, @rank)
SET rank = nullif(@rank, '');
