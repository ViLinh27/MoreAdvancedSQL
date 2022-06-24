--Create ZipCode table based on attributes in zipcode.csv file (zip, city, state, latitude, longitude, timezone, dst)
DROP TABLE ZipCode;
CREATE TABLE ZipCode
(
    zip NUMBER(5),
    city VARCHAR(30),
    state VARCHAR(2),
    latitude VARCHAR(30),
    longitude VARCHAR(30),
    timezone  NUMBER,
    dst NUMBER
);
--Then download the CHIzipcode.csv file provided on D2L.
--Write a Java program (similar to the one showed in class to connect to your Oracle database using JDBC driver) to convert the zipcode.csv file 
--into a series of SQL insert statements for ZipCode table.

--c. Use the program to join zipcodes table with restaurant_locations table and obtain latitude and longitude of all restaurants in the 
--Restaurants table.

--Print out the name, zipcode, latitude, longitude using your program.
SELECT * FROM ZipCode;
--Output should look like this:
--Shanghai Inn, 60625, "41.971614","-87.70256"