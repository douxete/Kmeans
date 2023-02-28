drop database if exists dbkmeans;

create database dbkmeans;

use dbkmeans;

create table tblData (
    customer int,
    spending decimal(4,2),
    income decimal(4,2)
);

insert into tblData values
(1	,20,	30),
(2	,60,	20),
(3	,40,	50),
(4	,80,	70),
(5	,90,	80),
(6	,10,	10),
(7	,30,	40),
(8	,50,	60),
(9	,70,	90),
(10,10,	20);