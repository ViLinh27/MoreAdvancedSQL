/* Delete the tables if they already exist */
drop table  Restaurant;
drop table  Reviewer;
drop table  Rating;

/* Create the schema for our tables */
create table Restaurant(
    rID int, 
    name varchar2(100), 
    address varchar2(100), 
    cuisine varchar2(100)
);
create table Reviewer(vID int, name varchar2(100));
create table Rating(rID int, vID int, stars int, ratingDate date);

/* Populate the tables with our data */
insert into Restaurant values(101, 'India House Restaurant', '59 W Grand Ave Chicago, IL 60654', 'Indian');
insert into Restaurant values(102, 'Bombay Wraps', '122 N Wells St Chicago, IL 60606', 'Indian');
insert into Restaurant values(103, 'Rangoli', '2421 W North Ave Chicago, IL 60647', 'Indian');
insert into Restaurant values(104, 'Cumin', '1414 N Milwaukee Ave Chicago, IL 60622', 'Indian');
insert into Restaurant values(105, 'Shanghai Inn', '4723 N Damen Ave Chicago, IL 60625', 'Chinese');
insert into Restaurant values(106, 'MingHin Cuisine', '333 E Benton Pl Chicago, IL 60601', 'Chinese');
insert into Restaurant values(107, 'Shanghai Terrace', '108 E Superior St Chicago, IL 60611', 'Chinese');
insert into Restaurant values(108, 'Jade Court', '626 S Racine Ave Chicago, IL 60607', 'Chinese');

insert into Reviewer values(2001, 'Sarah M.');
insert into Reviewer values(2002, 'Daniel L.');
insert into Reviewer values(2003, 'B. Harris');
insert into Reviewer values(2004, 'P. Suman');
insert into Reviewer values(2005, 'Suikey S.');
insert into Reviewer values(2006, 'Elizabeth T.');
insert into Reviewer values(2007, 'Cameron J.');
insert into Reviewer values(2008, 'Vivek T.');

insert into Rating values( 101, 2001,2, DATE '2011-01-22');
insert into Rating values( 101, 2001,4, DATE '2011-01-27');
insert into Rating values( 106, 2002,4, null);
insert into Rating values( 103, 2003,2, DATE '2011-01-20');
insert into Rating values( 108, 2003,4, DATE '2011-01-12');
insert into Rating values( 108, 2003,2, DATE '2011-01-30');
insert into Rating values( 101, 2004,3, DATE '2011-01-09');
insert into Rating values( 103, 2005,3, DATE '2011-01-27');
insert into Rating values( 104, 2005,2, DATE '2011-01-22');
insert into Rating values( 108, 2005,4, null);
insert into Rating values( 107, 2006,3, DATE '2011-01-15');
insert into Rating values( 106, 2006,5, DATE '2011-01-19');
insert into Rating values( 107, 2007,5, DATE '2011-01-20');


--Use the Restaurants.sql file from HW2, which creates three tables Restaurant, Reviewer, and Rating. In this problem, 
--we are concerned with the Restaurant table, which has a single attribute 'Address' of type 'varchar2(100)'. 
--We would like address to be searchable.  So we would like to create another table Restaurant_Locations with the following attributes:
-- rID, name, street_address,  city, state, zipcode, cuisine

DROP TABLE Restaurant_Locations;
--a. Create Restaurant_Locations table. Use the source dataset to determine the data types (and sizes) to use for each of the attributes.
CREATE TABLE Restaurant_Locations(
    rID int,
    name VARCHAR2(100),
    street_address VARCHAR2(100),
    city VARCHAR2(100),
    state VARCHAR2(100),
    zipcode INT,
    cuisine VARCHAR2(100)
);

--b. Write a cursor (using SQL and PL/SQL) to process each row from the original Restaurant table, extracting information as necessary to populate
--the new Restaurant_Locations table. The original address field must be split up and parsed into the new street_address, city, state, and zipcode 
--fields.
DECLARE
    /*output as populating new table I guess*/
    resid Restaurant.rID%TYPE;
    resname Restaurant.name%TYPE;
    
    streetAdd Restaurant.Address%TYPE;
    city Restaurant.Address%TYPE;
    
    resstate Restaurant.Address%TYPE;
    zip Restaurant.Address%TYPE;
    
    rescuisine Restaurant.cuisine%TYPE;
    
     /* Cursor Declaration */
CURSOR resCursor IS
    SELECT rID,name,address street,address city, address state,address zip,cuisine FROM Restaurant;
BEGIN
    OPEN resCursor;
        /*probs need to populate table here*/
    LOOP
        FETCH resCursor INTO resid,resname,streetAdd, city, resstate,zip,rescuisine;
            IF resCursor%FOUND THEN 
                /*split the address somehow here:*/
                /*insert into new table:*/
                INSERT INTO Restaurant_Locations VALUES(
                    resid,--restaurant idk
                    resname,--restaurant name
                    --matching string: ^ is begin of string, inside () is what we're matching ,$ is end of string, 
                    REGEXP_REPLACE(streetAdd, '^([^,]+) [^, ]+,.*$','\1'),--street address, \1 is backreference, contenu du premier substring du matching string
                    REGEXP_SUBSTR(city, '[[:alpha:]]+',1,4),--city
                    REGEXP_SUBSTR(resstate,'[[:alpha:]]+',1,5), --state
                    CAST(SUBSTR(zip,-5,5) AS INT), --zip
                    rescuisine
                );
            END IF;
        EXIT WHEN resCursor%NOTFOUND;
    END LOOP;
    CLOSE resCursor;
END;
/

SELECT * FROM Restaurant_Locations;

