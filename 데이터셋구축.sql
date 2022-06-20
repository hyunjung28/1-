alter table purprod add month number;
update purprod set year = substr(구매일자,5,2);


UPDATE ;  

CREATE TABLE RECENCY AS
SELECT 고객번호, TO_DATE('2015-01-01','YYYY-MM-DD')- TO_DATE(MAX(구매일자),'YYYY-MM-DD') AS RECENCY
FROM PURPROD WHERE 구매일자 < 20150101
GROUP BY 고객번호
ORDER BY RECENCY DESC;

select 고객번호, count(구매일자)
from purprod where 구매일자<20150101
GROUP BY 고객번호;



alter table datadd3 drop column 공통분류;\

alter table datadd3 add 반기 number(2);

update datadd3 set 반기 = 1 where 분기 = 2 or 분기 = 1;
update datadd3 set 반기 = 2 where 분기 = 3 or 분기 = 4;
update datadd3 set 반기 = 3 where 분기 = 5 or 분기 = 6;
update datadd3 set 반기 = 4 where 분기 = 7 or 분기 = 8;
commit;


insert into datadd3 
select p2.공통분류 
from prodcl p2;



from datadd3 p1, prodcl p2 where p1.제휴사 = p2.제휴사 and 
p1.대분류코드 = p2.대분류코드 and p1.중분류코드 = p2.중분류코드 and p1.소분류코드 = p2.소분류코드;



drop table pur_area31;

CREATE TABLE PUR_AREA31 AS SELECT custdemo.고객번호,
COUNT(CASE WHEN 반기 = 1 THEN custdemo.고객번호 END) "14년 상반기 구매건수", 
COUNT(CASE WHEN 반기 = 2 THEN custdemo.고객번호 END) "14년 하반기 구매건수", 
COUNT(CASE WHEN 반기 = 3 THEN custdemo.고객번호 END) "15년 상반기 구매건수", 
COUNT(CASE WHEN 반기 = 4 THEN custdemo.고객번호 END) "15년 하반기 구매건수", 
SUM(CASE WHEN 반기 = 1 THEN 구매금액 END) "14년 상반기 구매총액",
SUM(CASE WHEN 반기 = 2 THEN 구매금액 END) "14년 하반기 구매총액",
SUM(CASE WHEN 반기 = 3 THEN 구매금액 END) "15년 상반기 구매총액",
SUM(CASE WHEN 반기 = 4 THEN 구매금액 END) "15년 하반기 구매총액" FROM datadd3
LEFT OUTER JOIN custdemo ON datadd3.고객번호 = custdemo.고객번호 where custdemo.성별='F'
GROUP BY custdemo.고객번호;

update pur_area31 set "14년 상반기 구매건수" = 1 where "14년 상반기 구매건수" > 0;
update pur_area31 set "14년 하반기 구매건수" = 1 where "14년 하반기 구매건수" > 0;
update pur_area31 set "15년 상반기 구매건수" = 1 where "15년 상반기 구매건수" > 0;
update pur_area31 set "15년 하반기 구매건수" = 1 where "15년 하반기 구매건수" > 0;

select * from purcust3;

drop table 이탈고객;

create table 기존고객 as
select * from pur_area31 where "14년 상반기 구매건수"=1 and
"14년 하반기 구매건수"=1 and "15년 상반기 구매건수"=1 and "15년 하반기 구매건수"=1;


alter table pur_area31 add 고객분류코드 number(10);
update pur_area31 set "고객분류코드" = "14년 상반기 구매건수"*1000 + "14년 하반기 구매건수"*100 + "15년 상반기 구매건수"*10 + "15년 하반기 구매건수";

select * from 기존고객;

create table 신규고객 as
select * from pur_area31 where "고객분류코드" = 10 or "고객분류코드" = 1 or "고객분류코드"= 11;

create table 이탈고객 as
select * from pur_area31 where "고객분류코드" = 1000 or "고객분류코드" = 1100 or "고객분류코드" = 1110 or "고객분류코드" = 1010 or "고객분류코드"=100 or "고객분류코드" = 110;


--create table 기존고객구매정보 as
select d.고객번호, d.제휴사, d.성별, d.연령대, d.구매금액, d.거주지역, d.분기 ,pl.공통분류 from datadd3 d
inner join prodcl pl on pl.제휴사 = d.제휴사 and pl.고객번호 = d.고객번호
where "고객번호" in (select 고객번호 from 기존고객);

create table 기존고객구매정보 as
select d.고객번호, d.제휴사, d.성별, d.연령대, d.구매금액, d.거주지역, pl.공통분류, d.분기 
from datadd3 d , prodcl pl where "고객번호" in (select 고객번호 from 기존고객);

select 분기,공통분류, sum(구매금액), count(*) from 기존고객구매정보 group by 분기, 공통분류 order by 공통분류,  분기;
commit;

create table 신규고객구매정보 as
select d.고객번호, d.제휴사, d.성별, d.연령대, d.구매금액, d.거주지역, pl.공통분류, d.분기 
from datadd3 d , prodcl pl where D.제휴사= PL.제휴사 ;

select 분기, sum(구매금액),count(*) from 신규고객구매정보 group by 분기 order by 분기;
commit;

create table 이탈고객구매정보 as
select d.고객번호, d.제휴사, d.성별, d.연령대, d.구매금액, d.거주지역, pl.공통분류, d.분기 
from datadd3 d , prodcl pl where "고객번호" in (select 고객번호 from 이탈고객);

select 분기, sum(구매금액),count(*) from 이탈고객구매정보 group by 분기 order by 분기;
commit;

DROP TABLE 신규고객구매정보;

alter table 기존고객 add "14년도총구매액" number(20);
alter table 기존고객 add "15년도총구매액" number(20);

update 기존고객 set "14년도총구매액" = "14년 상반기 구매총액"+"14년 하반기 구매총액";
update 기존고객 set "15년도총구매액" = "15년 상반기 구매총액"+"15년 하반기 구매총액";

SELECT COUNT(*) FROM PUR_AREA32;
WHERE NOT "15년도총구매액"<"14년도총구매액";

SELECT count(*) from 신규고객구매정보;

select 공통분류,분기,sum(구매금액)총구매액
from 신규고객구매정보
group by 공통분류,분기
order by 총구매액 desc;

create view 기존감소고객_년도기준 as
select a.고객번호,a."14년도총구매액",a."15년도총구매액",d.반기
from 기존고객 a,datadd3 d
where "15년도총구매액"<"14년도총구매액" ;

create table 기존감소고객_구매정보 as
select d.제휴사, d.연령대, d.구매금액, d.거주지역, pl.공통분류, d.분기 
from datadd3 d , prodcl pl where 고객번호 in (select 고객번호 from 기존감소고객_년도기준 where "성별"='F');

drop table 기존고객_감소고객;

select 분기, 공통분류, sum(구매금액) from 기존감소고객_구매정보 group by 분기, 공통분류 order by 공통분류, 분기;

select "14년도총구매액",반기 from 기존감소고객_년도기준 order by  "14년도총구매액" desc;


SELECT "14년 상반기 구매총액","14년 하반기 구매총액","15년 상반기 구매총액","15년 하반기 구매총액", "14년도총구매액","15년도총구매액"
FROM 기존고객;

CREATE VIEW 기존고객구매
AS select d.제휴사, d.연령대, d.구매금액, d.거주지역, pl.공통분류, d.분기 
from datadd3 d , prodcl pl where 고객번호 in (select 고객번호 from 기존감소고객_년도기준 where "성별"='F');

SELECT 반기,"14년도총구매액" 
FROM DATADD3 
WHERE 반기=4;



CREATE TABLE 기존고객_감소고객 AS
SELECT A.고객번호, D.제휴사,D.연령대,D.거주지역,D.반기,B.공통분류,A."14년도총구매액",A."15년도총구매액"
FROM 기존고객 A, DATADD3 D, PRODCL B
WHERE "14년 상반기 구매총액"*1.126>"15년 하반기 구매총액" AND A.고객번호=D.고객번호 AND B.제휴사=D.제휴사 AND
B.대분류코드= D.대분류코드 AND B.중분류코드= D.중분류코드 AND B.소분류코드= D.소분류코드
GROUP BY A.고객번호, D.제휴사,D.연령대,D.거주지역,D.반기,B.공통분류,A."14년도총구매액",A."15년도총구매액";

SELECT  
 SUM(SUM("14년 상반기 구매총액")) OVER(partition by "14년 상반기 구매총액" order by "14년 상반기 구매총액" desc) AS 상반기14,
 SUM(SUM("14년 하반기 구매총액")) OVER(partition by "14년 하반기 구매총액" order by "14년 하반기 구매총액" desc) AS 하반기14,
SUM(SUM("15년 상반기 구매총액")) OVER(partition by "15년 상반기 구매총액" order by "15년 상반기 구매총액" desc) AS 상반기15,
SUM(SUM("15년 하반기 구매총액")) OVER(partition by "15년 하반기 구매총액" order by "15년 하반기 구매총액"desc) AS 하반기15
FROM 기존고객 
group by  "14년 상반기 구매총액","14년 하반기 구매총액","15년 상반기 구매총액","15년 하반기 구매총액";


sELECT sum("15년 상반기 구매총액")gk반기14
--sum("14년 하반기 구매총액")하반기14,
--sum("15년 상반기 구매총액")상반기15,sum("15년 하반기 구매총액")하반기15
FROM 기존고객 ;
--group by  "14년 상반기 구매총액";

SELECT * FROM 기존고객_감소고객;
SELECT 공통분류,SUM("14년도총구매액"),SUM("15년도총구매액"),
ROUND(RATIO_TO_REPORT(SUM(("15년도총구매액"-"14년도총구매액")/"14년도총구매액")) OVER (),2)*100 ||'% 'AS PERCENTAGE
FROM 기존고객_감소고객
GROUP BY 공통분류;

select 거주지역,sum("14년도총구매액")총구매14,sum("15년도총구매액")
from 기존고객_감소고객
group by 거주지역
order by 총구매14 desc;





ALTER TABLE 기존고객_감소고객 DROP (재분류);

ALTER TABLE 기존고객_감소고객 ADD 재분류 VARCHAR2(50);

UPDATE 기존고객_감소고객 SET 재분류 ='비내구재' WHERE
공통분류 = '식품' OR 공통분류 = '생활' OR 공통분류 = '시설' OR 공통분류 = '화장품' OR 공통분류 = '잡화' ;   

UPDATE 기존고객_감소고객 SET 재분류 ='준내구재' WHERE
공통분류 = '의류' OR 공통분류 = '악세사리' OR 공통분류 = '스포츠_레저' OR 공통분류 = '아동' OR 공통분류 = '문화' ;   

UPDATE 기존고객_감소고객 SET 재분류 ='내구재' WHERE
공통분류 = '가구' OR 공통분류 = '전자제품';
COMMIT;



CREATE TABLE 사분위 AS
SELECT PERCENTILE_DISC(0.25) WITHIN GROUP ( ORDER BY "14년도총구매액"+"15년도총구매액") AS Q1,
PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY "14년도총구매액"+"15년도총구매액") AS Q3,
PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY "14년도총구매액"+"15년도총구매액")
-PERCENTILE_DISC(0.25) WITHIN GROUP ( ORDER BY "14년도총구매액"+"15년도총구매액") AS IQR
FROM 기존고객_감소고객_구매;

CREATE TABLE 기존고객_감소고객_이상치제거 AS
SELECT r.* from 기존고객_감소고객_구매 r, 사분위 s
where  r."14년도총구매액"+"15년도총구매액" > (s.q1-1.5*iqr) and
r."14년도총구매액"+"15년도총구매액" <(s.q3+1.5*iqr);


drop table 기존고객_감소고객_이상치제거;
select * from 기존고객_감소고객_이상치제거 ;

select * from 기존고객_감소고객_이상치제거 where 고객번호 =17667;




create table 식품 as
select a.고객번호,b."14년 상반기 구매총액",b."14년 하반기 구매총액",b."15년 상반기 구매총액",b."15년 하반기 구매총액",a."반기"
from 기존고객_감소고객_이상치제거 a,기존고객 b
where a.공통분류='식품' and a.고객번호 =b.고객번호;

drop table purprod;

create table 식품_분류 as
select 고객번호,"14년 상반기 구매총액","14년 하반기 구매총액","15년 상반기 구매총액","15년 하반기 구매총액",
width_bucket("14년 상반기 구매총액",59583,68211952,5)분14상 ,
 width_bucket("14년 하반기 구매총액",5695,46133853,5)분14하,
 width_bucket("15년 상반기 구매총액",7000,60671404,5)분15상 ,
 width_bucket("15년 하반기 구매총액",2859,32400627,5)분15하 
from 식품 group by 고객번호,"14년 상반기 구매총액","14년 하반기 구매총액","15년 상반기 구매총액","15년 하반기 구매총액";

select min("15년 하반기 구매총액")
from 식품;
select count(*)
from 식품_분류 where 분15상=1;
select count(*)
from 식품_분류 where 분14상=5;



drop table 기존고객_감소고객_구매;
select max("15년 하반기 구매총액")
from 식품;

select count(*) from 기존고객_감소고객_구매;


create table 기존고객_감소고객_구매 as 
select a.고객번호,a."14년도총구매액",a."15년도총구매액",a."14년 상반기 구매총액",a."14년 하반기 구매총액",a."15년 상반기 구매총액",
a."15년 하반기 구매총액"
from 기존고객 a
where  a."14년 상반기 구매총액"*1.126>a."15년 하반기 구매총액"  
group by a.고객번호,a."14년도총구매액",a."15년도총구매액",a."14년 상반기 구매총액",a."14년 하반기 구매총액",a."15년 상반기 구매총액",
a."15년 하반기 구매총액"
order by a."14년도총구매액",a."15년도총구매액";

select count(*) from 기존고객_감소고객_이상치제거;
select * from 기존고객_감소고객  where 고객번호=15756;
drop table 기존고객_감소고객_구매;


alter table 기존고객_감소 add 식품_1F number(20);

update 기존감소고객_년도기준 t1 set t1.식품_1 = 
(select sum(t2.구매금액) from 기존감소고객_구매정보 t2 Where t1."고객번호"=t2."고객번호" and t2.반기 = 1 and t2.공통분류 ='식품');
alter table 기존고객_감소 add 식품_빈도1 number(20);




update 기존고객_감소 set 식품_1F = sum("14년 상반기 구매건수")  WHERE EXISTS SELECT 
FROM 기존감소_구매정보 T2, 기존고객_감소 T1 WHERE  T2.공통분류 ='식품'



DROP TABLE ;

SELECT R.* FROM 기존고객_감소 R
FULL OUTER JOIN 기존감소_구매정보 P ON P.고객번호 = R.고객번호;


--create table 기존감소_구매정보 as
select D.고객번호, P.공통분류, D.반기 
from DATADD3 D 
inner join PRODCL P where "고객번호" in (select 고객번호 from 기존고객) AND
D.제휴사 =P.제휴사
GROUP BY D.고객번호, P.공통분류, D.반기 ;

CREATE TEMPORARY TABLESPACE temp01 TEMPFILE '/app/oracle/temp01.dbf' size 5600M;
alter tablespace LOG_SPACE add datafile '/u02/oradata/log_space2.dbf' size 1024M;
alter database datafile '/oracle_db/oradata/XE/TEMP01.dbf' autoextend on;

update 기존고객_감소 T1 set T1.식품_1F = (SELECT SUM(T1."14년 상반기 구매건수") FROM 기존고객_감소 T1,
DATADD3 D WHERE D.고객번호 = T1.고객번호 AND D.반기 = 1 AND 
WHERE T1.고객번호 = T2.고객번호;

CREATE TEMPORARY TABLESPACE TEMP2

    TEMPFILE 'D:\oracle_db\oradata\XE\TEMP2.DBF' SIZE 500M REUSE

    AUTOEXTEND ON NEXT 100M MAXSIZE unlimited

    EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M;

DROP  TABLE 기존고객_감소;

create table 기존고객_감소 as
select R.고객번호, R."14년 상반기 구매건수",  R."14년 하반기 구매건수", R."15년 상반기 구매건수",  R."15년 하반기 구매건수",
R."14년 상반기 구매총액",  R."14년 하반기 구매총액", R."15년 상반기 구매총액",  R."15년 하반기 구매총액"
from 기존고객 R
where R."14년 상반기 구매총액"*1.126 >R."15년 하반기 구매총액"
GROUP BY R.고객번호, R."14년 상반기 구매건수",  R."14년 하반기 구매건수", R."15년 상반기 구매건수",  R."15년 하반기 구매건수",
R."14년 상반기 구매총액",  R."14년 하반기 구매총액", R."15년 상반기 구매총액",  R."15년 하반기 구매총액";

SELECT COUNT(*) FROM 기존고객_감소 ;


create table 감소고객_구매 as
select R.고객번호,P.공통분류, D.성별,D.거주지역,D.시간,D.연령대
from 기존고객 R,PRODCL P, DATADD3 D
WHERE D.제휴사 = P.제휴사 AND D.대분류코드 = P.대분류코드 AND D.중분류코드 = P.중분류코드 AND D.소분류코드 = P.소분류코드
AND R.고객번호 = D.고객번호
GROUP BY R.고객번호,P.공통분류,D.성별,D.거주지역,D.시간,D.연령대;

DROP TABLE 기존감소_구매정보;
ALTER TABLE 감소고객_구매 ADD 식품1_F NUMBER(10);

UPDATE 감소고객_구매 T1 SET T1.식품1_F = (SELECT SUM(T2."14년 상반기 구매건수") FROM 기존고객_감소 T2
WHERE  T1.공통분류='식품' AND T1.고객번호 =T2.고객번호);
COMMIT;
update 기존감소고객_년도기준 t1 set t1.식품_1 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 
where t1."고객번호"=t2."고객번호" and t2.반기 = 1 and t2.공통분류 ='식품');

WHERE T2.고객번호 =T1.고객번호 AND T2.공통분류='식품';

select count(*) from rfm;


select datadd3.고객번호,prodcl.중분류명
from datadd3, prodcl
group by datadd3.고객번호,prodcl.중분류명;




MERGE 
 INTO 기존_감소 A
USING DATADD3 D
   ON (A.고객번호 = D.고객번호 AND A.성별=D.성별 AND A.연령대 = D.연령대 AND A.거주지역 = D.거주지역)
 WHEN MATCHED THEN
      UPDATE 
         SET A.구매시간 = D.구매일자;
        
ALTER TABLE 기존_감소 ADD 구매일자 NUMBER(20);
ALTER TABLE 기존_감소 DROP COLUMN 구매일자;
INSERT INTO 기존_감소(구매일자) SELECT 구매일자 FROM DATADD3 WHERE DATADD3.고객번호 =기존_감소.고객번호;

UPDATE 기존_감소 A
SET A.구매일자 = (SELECT A.구매일자 FROM DATADD3 D WHERE 
A.고객번호 = D.고객번호 AND A.성별=D.성별 AND A.연령대 = D.연령대 AND A.거주지역 = D.거주지역 AND  ROWNUM = 1);

update 기존감소고객_년도기준 t1 set t1.식품_1 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 
where t1."고객번호"=t2."고객번호" and t2.반기 = 1 and t2.공통분류 ='식품');
--RECENCY 

CREATE TABLE FREQ AS
SELECT D.고객번호,
(TO_DATE('2016-01-01','YYYY-MM-DD') -TO_DATE(MAX(D.구매일자),'YYYY-MM-DD')) AS RECENT
FROM DATADD3 D, 기존_감소 R
WHERE R.고객번호 = D.고객번호 AND R.성별=D.성별 AND R.연령대 = D.연령대 AND R.거주지역 = D.거주지역
GROUP BY D.고객번호;

SELECT RECENT FROM FREQ WHERE RECENT>365;


CREATE  TABLE REQUENCY AS
--SELECT * FROM FREQ  OUTER JOIN 기존_감소 ON 기존_감소.고객번호 = FREQ.고객번호;
SELECT * FROM FREQ  OUTER JOIN 기존_감소 USING(고객번호);
 
 DROP TABLE REQUENCY;
 SELECT * FROM REQUENCY WHERE RECENT>370;
 SELECT TO_DATE('2016-01-01','YYYY-MM-DD') -TO_DATE(MAX(D.구매일자),'YYYY-MM-DD')
 FROM FREQ WHERE ;
 
 
 create table new_freq as
 select d.고객번호,p. 공통분류, count(d.구매일자)빈도 
 from prodcl_2 p, datadd3 d
 where p.제휴사 = d.제휴사 and p.대분류코드 = d.대분류코드 and p.중분류코드 =d.중분류코드 and p.소분류코드 = d.소분류코드
 and d."고객번호" in (select 고객번호 from 기존_감소)
 group by d.고객번호,p.공통분류;
 
 drop table new_freq;
CREATE TABLE NEW_FREQ AS 
select d.고객번호, count(d.구매일자)빈도 , p.공통분류
from prodcl_2 p, datadd3 d
where p.제휴사 = d.제휴사 and p.대분류코드 = d.대분류코드 and p.중분류코드 =d.중분류코드 and p.소분류코드 = d.소분류코드
and d."고객번호" in (select 고객번호 from 기존_감소)
 group by d.고객번호,p.공통분류
 ;
 
 select 공통분류,count(*)수,round(ratio_to_report(count(*)) over(),2) *100 || '%' as ratio from prodcl_2  group by 공통분류 order by 수 desc;
 
drop table prodcl;
select * from new_frm3;

create table new_frm3 as
select r.* , q."14년 상반기 구매총액",q."14년 하반기 구매총액",q."15년 상반기 구매총액",q."15년 하반기 구매총액"
from new_freq r, 기존_감소 q
where r.고객번호 = q.고객번호 ;

create table new_rfm3 as
select r.* , q.req
from new_frm3 r, freq q
where r.고객번호 = q.고객번호;