select spending as "C1x" into @C1x from tbldata order by rand() limit 1;
select income as "C1Y" into @C1Y from tbldata order by rand() limit 1;

select spending as "C2X" into @C2X from tbldata order by rand() limit 1;
select income as "C2Y" into @C2Y from tbldata order by rand() limit 1;

SELECT CONCAT("(", @C1x,",",@C1Y,")") as C1;
SELECT CONCAT("(", @C2X,",",@C2Y,")") as C2;

DROP TABLE IF EXISTS tblIteration1;

CREATE TABLE tblIteration1 as
    SELECT customer as DATA, spending as X, income as Y,
    SQRT(POW((spending - @C1x), 2) + POW((income - @C1Y),2)) AS "Distance from C1",
    SQRT(POW((spending - @C2X), 2) + POW((income - @C2Y),2))AS "Distance from C2",
    IF(SQRT(POW((spending - @C1x),2) + POW((income - @C1Y),2)) > SQRT(POW((spending - @C2X), 2) + POW((income - @C2Y),2)), "C2", "C1") AS "Cluster_In"
    FROM tblData;

SELECT * from tblIteration1;

SELECT distinct(Cluster_In) as NewC,AVG(x) as NewCx, AVG(y) as NewCy FROM tblIteration1 GROUP BY Cluster_In;