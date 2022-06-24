

/* Delete the tables if they already exist */
drop table  Restaurant;
drop table  Reviewer;
drop table  Rating;

/* Create the schema for our tables */
create table Restaurant(rID int, name varchar2(100), address varchar2(100), cuisine varchar2(100));
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


--The restaurants in the database continue to be visited and reviewed. Information about new restaurant reviews is made available as:
--(RestaurantName, UserName, Rating, RatingDate)

--Restaurant names and user names are assumed to be unique. 
--Write a PL/SQL stored procedure that accepts the above input string and inserts new restaurant rating information into the Rating table. 
--If a new user appears, it inserts into the Reviewer table.
CREATE OR REPLACE PROCEDURE newReview (
    resName IN VARCHAR2,
    userName IN VARCHAR2,
    rating IN NUMBER,
    ratingDate IN VARCHAR2
    )
IS
    resID INT;
    userID NUMBER;
    doesResExist INT;
    doesUserExist INT;
    doesUserNameExist INT;
    maxExistingUserID INT;
    
    resException EXCEPTION;
BEGIN
    --DBMS_OUTPUT.PUT_LINE('--need to insert new retaurant rating');
    
    --look for the restaurant--does restaurant in input already exist
    --SELECT resName FROM Restaurant WHERE resName = Restaurant.name;--look for record
    SELECT COUNT(resName) INTO doesResExist FROM Restaurant WHERE resName = Restaurant.name;--look for count of record
    
    --make an IF to see if resaurant exists inside subquery
        --IF NOT EXISTS() THEN raise an exception if restaruant doesn't exist
    --IF NOT EXISTS(SELECT resName FROM Restaurant WHERE resName = Restaurant.name) THEN --oracle doesnt like if exist inside procedure
    IF doesResExist = 0 THEN
        RAISE resException;
    --else if restaurant exists
    ELSE
        --resID = the seelect (looking for the restaurant)
        SELECT rID INTO resID FROM Restaurant WHERE Restaurant.name = resName;
        --needs paramter to ensure only one row: WHERE ROWNUM = 1
    END IF;
    
    --does the user ID exist---does the userName from input have an existing ID with it
    --SELECT  vID FROM Reviewer WHERE Reviewer.name = userName;--look if user exists
    SELECT COUNT(vID) INTO doesUserExist FROM Reviewer WHERE Reviewer.name = userName;--look for count of user record
    --if exists: userID = userID of corresponding name
        --IF EXISTS(SELECT vID FROM Reviewer WHERE name=userName) THEN --oracle doesnt like if exist inside procedure
    IF doesUserExist > 0 THEN
    --IF revID_check != NULL THEN
        SELECT viD into userID FROM Reviewer WHERE Reviewer.name = userName;
    --else (if not exsists) then userID = query of max user ID + 1
    ELSE
        SELECT (MAX(vID)+1) INTO userID FROM Reviewer;--make a new userID
    --no need to have nested ifs
    END IF;
    
    INSERT INTO Rating VALUES(resID,userID,rating,TO_DATE(ratingDate,'MM/DD/YYYY'));--new restaurant rating info
    
    
    --if new user, insert into Reviwer
        -- see if username EXISTS (query to find the existing reviewer names)
    SELECT COUNT(userName) INTO doesUserNameExist FROM Reviewer WHERE Reviewer.name = userName;
    --IF NOT EXISTS(SELECT userName FROM Reviewer WHERE Reviewer.name = userName) THEN --oracle doesnt like if exist inside procedure
    IF doesUserNameExist = 0 THEN
        --instead of null, make subquery to find max of existing ID and then add 1
        SELECT (MAX(vID)+ 1) INTO maxExistingUserID FROM Reviewer;
        INSERT INTO Reviewer VALUES(maxExistingUserID, userName);
    END IF;
     
END;
/
--test:
CALL newReview('Jade Court','Sarah M.', 4,'08/17/2017');
CALL newReview('Shanghai Terrace','Cameron J.', 5, '08/17/2017');
CALL newReview('Rangoli','Vivek T.',3,'09/17/2017');
CALL newReview('Shanghai Inn','Audrey M.',2,'07/08/2017');
CALL newReview('Cumin','Cameron J.', 2, '09/17/2017');

--bonus : Create a table ‘Top5Restaurants’ restaurants in the database as: Create table Top5Restaurants(rID int)
--Top5Restaurants holds the rIDs of top 5 restaurants in Chicago. Write a statement (+5) or row-level trigger(+10) on the Rating table that 
--computes top 5 restaurants and populates the Top5Restaurants table. This trigger is fired every time a restaurant receives a new rating. 
--Test your procedure and trigger in SQL Developer to insert the following four strings:
--(‘Jade Court’,`Sarah M.’, 4, ‘08/17/2017’)
--(‘Shanghai Terrace’,`Cameron J.’, 5, ‘08/17/2017’)
--(‘Rangoli’,`Vivek T.’,3,`09/17/2017’)
--(‘Shanghai Inn’,`Audrey M.’,2,`07/08/2017’);
--(‘Cumin’,`Cameron J.’, 2, ‘09/17/2017’)

--for trigger, same skeelton as prev trigger
--top 5 has rIDS
--if new review, empty/drop top 5
--in trigger do drop table and create table if new rating
--trigger on insert on review table

DROP TABLE Top5Restaurants;
CREATE TABLE Top5Restaurants(rID int);

DECLARE
    resID Restaurant.rID%TYPE;
    c NUMBER:=0;
CURSOR Rescursor IS
    SELECT res.rID FROM Restaurant res --find what we want: top 5 res by rating in desc order
    INNER JOIN Rating rat ON rat.rid = res.rid
    GROUP BY res.rid ORDER BY AVG(rat.stars) DESC;
BEGIN
    OPEN Rescursor;
        LOOP
            FETCH Rescursor INTO resID; --fetches resID from the query we got
            IF ResCursor%FOUND AND c < 5 THEN
                INSERT INTO Top5Restaurants VALUES(resID);
                c := c+1;
            END IF;
            EXIT WHEN Rescursor%NOTFOUND;
        END LOOP;
    ClOSE ResCursor;
END;
/

--display the top5 restaurants
SELECT * FROM Top5Restaurants;

SET SERVEROUTPUT ON