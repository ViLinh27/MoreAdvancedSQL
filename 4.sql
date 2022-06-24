SET SERVEROUTPUT ON;
--Consider the TASK and CONTRACT tables defined by the following script, which also populates the JOB table:?

DROP TABLE CONTRACT CASCADE CONSTRAINTS;
DROP TABLE TASK CASCADE CONSTRAINTS;

CREATE TABLE TASK (
    TaskID CHAR(3),
    TaskName VARCHAR(20),
    ContractCount NUMERIC(1,0) DEFAULT 0,--a count of how many workers have signed contracts to work on that task
    
    CONSTRAINT PK_TASK PRIMARY KEY (TaskID)
);

CREATE TABLE CONTRACT(
    TaskID CHAR(3),
    WorkerID CHAR(7),
    Payment NUMERIC(6,2),
    
    CONSTRAINT PK_CONTRACT PRIMARY KEY (TaskID, WorkerID),
    CONSTRAINT FK_CONTRACTTASK FOREIGN KEY (TaskID) REFERENCES TASK (TaskID)
);

INSERT INTO TASK (TaskID, TaskName) VALUES ('333', 'Security' );
INSERT INTO TASK (TaskID, TaskName) VALUES ('322', 'Infrastructure');
INSERT INTO TASK (TaskID, TaskName) VALUES ('896', 'Compliance' );

SELECT * FROM TASK;
COMMIT;

--The ContractCount attribute of TASK should store a count of how many workers have signed contracts to work on that task, 
--that is, the number of records in CONTRACT with that TaskID, and its value should never exceed 3. 

--Your task is to write three triggers that will maintain the value of the ContractCount attribute in TASK as changes are made to the 
--CONTRACT table. 
--Write a script file Problem2.sql containing definitions of the 
--following three triggers:

--1. The first trigger, named NewContract, will fire when a user attempts to INSERT a row into CONTRACT. This trigger will check the value of
--ContractCount for the corresponding task. If ContractCount is less than 3, then there is still room in the task for another worker, 
--so it will allow the INSERT to occur and will increase the value of ContractCount by one. 
--If ContractCount is equal to 3, then the task is full, so it will cancel the INSERT and display an error message stating that the task is full.
CREATE OR REPLACE TRIGGER NewContract 
    AFTER INSERT ON CONTRACT--try after if that no work
    FOR EACH ROW
--WHEN ((SELECT ContractCount FROM TASK WHERE TASK.TaskID = :NEW.TaskID)<3) --NEED some subquery to look for contract count in task
DECLARE
--var for contract count
    concounter NUMBER;
--exception with a name
    invalid_tasks EXCEPTION;
BEGIN
--query to find contract count
    SELECT ContractCount INTO concounter FROM TASK WHERE TASK.TaskID = :NEW.TaskID;
--if contract count is less than 3
IF(concounter<3) THEN
    --add 1
        UPDATE TASK
        SET ContractCount = ContractCount + 1 --doesn't seem to go up...need to check
        WHERE TaskID = :NEW.TaskID;
        COMMIT;
    --with the update stuff

--else if = 3
ELSIF (concounter=3) THEN 
--send message of Task yada yada is full with dbms print whatever
    DBMS_OUTPUT.PUT_LINE('Task is full. Rejected');
        --raise exception var
                --this creates rollback
    RAISE invalid_tasks;


END IF;
END NewContract;
/

--debug
--choose a task iD that has less than 3 contract counts
--keep adding some contracts to see what happens
INSERT INTO TASK (TaskID, TaskName) VALUES ('227', 'Security' );
SELECT ContractCount, TaskID FROM TASK;

INSERT INTO TASK (TaskID, TaskName) VALUES ('222', 'Research' );
SELECT ContractCount, TaskID FROM TASK;

INSERT INTO TASK (TaskID, TaskName) VALUES ('223', 'Development' );
SELECT ContractCount, TaskID FROM TASK;

INSERT INTO TASK (TaskID, TaskName) VALUES ('224', 'Marketing' );
SELECT ContractCount, TaskID FROM TASK;

INSERT INTO TASK (TaskID, TaskName) VALUES ('225', 'Updates' );
SELECT ContractCount, TaskID FROM TASK;

INSERT INTO TASK (TaskID, TaskName) VALUES ('226', 'User Testing' );
SELECT ContractCount, TaskID FROM TASK;

--2. The second trigger, named EndContract, will fire when a user attempts to DELETE one or more rows from CONTRACT. 
--This trigger will update the values of 
--ContractCount for any affected tasks to make sure they are accurate after the rows are deleted, by decreasing the value of ContractCount 
--by one each time a
--worker is removed from a task.
CREATE OR REPLACE TRIGGER EndContract
    BEFORE DELETE ON CONTRACT
    FOR EACH ROW
DECLARE
    --var for contract count
    concounter NUMBER;
    endcon EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--debug');
    --query to find contract count
    SELECT ContractCount INTO concounter FROM TASK WHERE TASK.TaskID = :NEW.TaskID;
    --if contract count = 0 then print error message raise invalid exception
    IF (concounter = 0) THEN
        RAISE endcon;
    --else if there are contracts:
    ELSIF (concounter > 0) THEN
        UPDATE TASK
        SET ContractCount = ContractCount - 1 --since the condition involves deletion by user
        WHERE TaskID = :NEW.TaskID;
    END IF;
END EndContract;
/

--debug by deleting arbitrary values--can put here :
DELETE FROM TASK WHERE TASKID = '333';

--3. The third trigger, named NoChanges, will fire when a user attempts to UPDATE one or more rows of CONTRACT. The trigger will 
--cancel the UPDATE and display an error message stating that no updates are permitted to existing rows of CONTRACT.
CREATE OR REPLACE TRIGGER NoChanges
    BEFORE UPDATE ON CONTRACT
    FOR EACH ROW
DECLARE
    cancelTasks EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('No updates are permitted.');
    --print some message for the error
    RAISE cancelTasks;
END NoChanges;
/

--debug:
UPDATE TASK
SET TASKID = '444'
WHERE TaskName = 'Compliance';
--NewContract and EndContract should be row-level triggers; NoChanges should be a statement-level trigger.

--Run the script to define your triggers and test them to make sure they work by doing a few INSERTS, DELETES, and UPDATES on the 
--CONTRACT table.


--try the nochanges first: add UPDATE ON CONTRACT at the end