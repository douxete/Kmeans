use dbkmeans;

drop procedure if exists sp0;

DELIMITER ##
CREATE PROCEDURE sp0(numIteration int)
    BEGIN
        DECLARE i int;
        SET i = 0;

        select spending as "C1X" into @C1X from tbldata order by rand() limit 1;
        select income as "C1Y" into @C1Y from tbldata order by rand() limit 1;

        select spending as "C2X" into @C2X from tbldata order by rand() limit 1;
        select income as "C2Y" into @C2Y from tbldata order by rand() limit 1;

        SELECT CONCAT("(", @C1X,",",@C1Y,")") as C1, CONCAT("(", @C2X,",",@C2Y,")") as C2;

        WHILE i <= numIteration DO

            DROP TABLE IF EXISTS tblIteration1;

            CREATE TABLE tblIteration1 as
                SELECT customer as DATA, spending as X, income as Y,
                SQRT(POW((spending - @C1X), 2) + POW((income - @C1Y),2)) AS "Distance from C1",
                SQRT(POW((spending - @C2X), 2) + POW((income - @C2Y),2))AS "Distance from C2",
                IF(SQRT(POW((spending - @C1X),2) + POW((income - @C1Y),2)) > SQRT(POW((spending - @C2X), 2) + POW((income - @C2Y),2)), "C2", "C1") AS "Cluster_In"
                FROM tblData;

            DROP TABLE IF EXISTS tblNewC;

            CREATE TABLE tblNewC AS
                SELECT distinct(Cluster_In) as NewC,AVG(x) as NewCx, AVG(y) as NewCy FROM tblIteration1 GROUP BY Cluster_In;

            SELECT NewCx INTO @C1X FROM tblNewC LIMIT 1;
            SELECT NewCx INTO @C2X FROM tblNewC LIMIT 1 OFFSET 1;

            SELECT NewCy INTO @C1Y FROM tblNewC LIMIT 1;
            SELECT NewCy INTO @C2Y FROM tblNewC LIMIT 1 OFFSET 1;


            SELECT CONCAT("(", @C1X,",",@C1Y,")") as "New C1", CONCAT("(", @C2X,",",@C2Y,")") as "New C2";

            SET i = i+1;
            
        END WHILE;
    END
##
DELIMITER ;

CALL sp0(10);