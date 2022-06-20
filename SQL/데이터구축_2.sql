SELECT COUNT(구매일자) FROM DATADD3 WHERE 고객번호=17218;

SELECT 구매일자 FROM DATADD3 WHERE 고객번호=17218 GROUP BY 구매일자;


CREATE TABLE RFM AS  
SELECT D.고객번호, count(P.구매일자)빈도, D.공통분류,D.소비재분류, P.반기
FROM 기존_감소 D ,DATADD3 P
WHERE D.고객번호 = P.고객번호 AND D.성별=P.성별 AND D.연령대=P.연령대 AND D.거주지역 =P.거주지역
AND D.제휴사 = P.제휴사 
GROUP BY D.고객번호,D.공통분류,D.소비재분류, P.반기 ;

CREATE TABLE RFM_2 AS
SELECT 공통분류,빈도,고객번호,반기,REQ
FROM RFM;

ALTER TABLE 기존_감소 DROP (제휴사,소비재분류,식품F,구매일자);
COMMIT;
select * from rfm;


alter table 기존_감소 ADD  req NUMBER;
--requency 
alter table 기존_감소 add req number;
update 기존_감소 set REQ = 
case 
    when recent<=1 then 4
    when 1<recent and recent <=2 then 3
    when 2<recent and recent<=4 then 2
    when 4<recent  and recent <=184 then 1
end;
--기존_감소 테이블에 데이터 추가 
INSERT INTO 기존_감소(REQ) SELECT REQ FROM FREQ;
COMMIT;
ALTER TABLE 기존_감소 DROP COLUMN 빈도;
INSERT INTO 기존_감소(빈도) SELECT RECENT FROM FREQ;

SELECT COUNT(D.구매일자) FROM DATADD3 D, 기존_감소 R
WHERE R.고객번호  =D.고객번호 AND D.성별= R.성별 AND D.거주지역=R.거주지역 AND D.연령대 = R.연령대 
AND D.제휴사 = R.제휴사 AND ;

INSERT INTO DATADD3 D (공통분류_2) SELECT 공통분류 FROM 분류작업 ;
COMMIT;
ALTER TABLE DATADD3 DROP COLUMN 공통분류;
UPDATE 기존_감소 SET 공통분류 = (SELECT 공통분류 FROM PRODCL );
alter table 기존_감소 add 구매일자 number;
alter table 기존_감소 DROP COLUMN 빈도;

insert into 기존_감소(구매일자) select 구매일자 FROM DATADD3;
COMMIT;
alter table 기존_감소 add 구매일자 number;
COMMIT;

alter table 기존_감소 add 빈도 number;
insert into 기존_감소(빈도) select COUNT(구매일자) FROM 기존_감소;
alter table NEW_FREQ add 식품F number;
UPDATE NEW_FREQ set 식품F = 
case when 공통분류='신선식품' and 빈도<=172 then 1
when 공통분류='신선식품' and 빈도>172 and 빈도< 336 then 2
when 공통분류='신선식품' and 빈도>336 and 빈도< 571 then 3
when 공통분류='신선식품' and 빈도>571 then 4
end;

ALTER TABLE RFM_2 DROP COLUMN 공통분류;

commit;



ALTER TABLE DATADD3 ADD 공통분류 VARCHAR2(50);
UPDATE DATADD3 D SET D.공통분류 = (SELECT 공통분류 FROM PRODCL P WHERE P.제휴사 =D.제휴사 AND D.대분류코드 = P.대분류코드
AND D.중분류코드 = P.중분류코드 AND D.소분류코드 = P.소분류코드 );
commit;

ALTER TABLE RFM_2 ADD 공통분류 VARCHAR2(50);
UPDATE RFM_2  SET 공통분류 = (SELECT 공통분류 FROM prodcl  );
COMMIT;
ALTER TABLE RFM ADD 반기 NUMBER;


INSERT ALL RFM_2 R WHEN R.고객번호 = D.고객번호 THEN
INTO R.공통분류 VALUES(D.공통분류) SELECT D.공통분류 FROM DATADD3 D ;

INSERT ALL RFM_2 R
INTO R.공통분류 VALUES(D.공통분류) SELECT D.공통분류 FROM prodcl D ;



SELECT 공통분류  FROM DATADD3  WHERE 고객번호 = 고객번호;

UPDATE RFM_2 R SET R.공통분류 = (SELECT D.공통분류  FROM DATADD3 D WHERE D.고객번호 = R.고객번호 );
COMMIT;

MERGE INTO RFM_2 R USING DATADD3 D ON  (D.고객번호 = R.고객번호 )
  WHEN MATCHED THEN
        UPDATE SET R.공통분류 = D.공통분류;

MERGE INTO RFM_2 R USING (SELECT D.공통분류_2 FROM DATADD3 D WHERE D.고객번호 = R.고객번호 ) 

;
CREATE TABLE RR AS 
SELECT D.공통분류, COUNT(D.구매일자)빈도, D.고객번호, D.반기
FROM DATADD3 D, RFM R
WHERE  D. 고객번호 =  R.고객번호
GROUP BY  D.공통분류, D.고객번호, D.반기;


SELECT * FROM RR WHERE 고객번호=17674;





SELECT 공통분류,빈도 FROM RR WHERE 공통분류 = '식품';



ALTER TABLE RR ADD 식품_1 NUMBER;
UPDATE RR SET 식품_1 = 1 where 공통분류='식품' and 빈도<=130;

alter table rr drop (악세사리_1,악세사리_2,악세사리_3,악세사리_4);
alter table rr drop (잡화_1,잡화_2,잡화_3,잡화_4,스포츠레저_1,스포츠레저_2,스포츠레저_3,
스포츠레저_4,시설_1,시설_2,시설_3,시설_4,의류_1,의류_2,의류_3,의류_4);
commit;
alter table rr drop column 식품_1;
alter table rr add 식품_1 number;
UPDATE RR SET 식품_1 = 1 where 공통분류='식품' and 빈도<=130 ;
alter table rr add 식품_2 number;
UPDATE RR SET 식품_2 = 2 where 공통분류='식품' and 빈도>130 and 빈도<=258 ;
alter table rr add 식품_3 number;
UPDATE RR SET 식품_3 = 3 where 공통분류='식품' and 빈도>258 and 빈도<=416;
alter table rr add 식품_4 number;
UPDATE RR SET 식품_4 = 4 where 공통분류='식품' and 빈도>416 and 빈도<=2915;
commit;


ALTER TABLE RR ADD 생활_1 NUMBER;
UPDATE RR SET 생활_1 = 1 where 공통분류='생활' and 빈도<=14;
alter table rr add 생활_2 number;
UPDATE RR SET 생활_2 = 2 where 공통분류='생활' and 빈도>14 and 빈도<=25;
alter table rr add 생활_3 number;
UPDATE RR SET 생활_3 = 3 where 공통분류='생활' and 빈도>25 and 빈도<=42;
alter table rr add 생활_4 number;
UPDATE RR SET 생활_4 = 4 where 공통분류='생활' and 빈도>42 and 빈도<=360;
commit;

ALTER TABLE RFM_2 ADD 생활F NUMBER;
UPDATE rfm_2 set 생활F = 
case when 공통분류='생활' and 빈도<=14 then 1
when 공통분류='생활' and 빈도>14 and 빈도< 25 then 2
when 공통분류='생활' and 빈도>25 and 빈도< 42 then 3
when 공통분류='생활' and 빈도>42 then 4
end;



ALTER TABLE RR ADD 의류_1 NUMBER;
UPDATE RR SET 의류_1 = 1 where 공통분류='의류' and 빈도<=7;
alter table rr add 의류_2 number;
UPDATE RR SET 의류_2 = 2 where 공통분류='의류' and 빈도>7 and 빈도<=16;
alter table rr add 의류_3 number;
UPDATE RR SET 의류_3 = 3 where 공통분류='의류' and 빈도>16 and 빈도<=32;
alter table rr add 의류_4 number;
UPDATE RR SET 의류_4 = 4 where 공통분류='의류' and 빈도>33;
commit;

alter table rfm_2 drop column 의류F;
ALTER TABLE RFM_2 ADD 의류F NUMBER;
UPDATE rfm_2 set 의류F = 
case when 공통분류='의류' and 빈도<=7 then 1
when 공통분류='의류' and 빈도>7 and 빈도<= 16 then 2
when 공통분류='의류' and 빈도>16 and 빈도<= 32 then 3
when 공통분류='의류' and 빈도>32 then 4
end;


ALTER TABLE RR ADD 시설_1 NUMBER;
UPDATE RR SET 시설_1 = 1 where 공통분류='시설' and 빈도<=4;
alter table rr add 시설_2 number;
UPDATE RR SET 시설_2 = 2 where 공통분류='시설' and 빈도>4 and 빈도<=9;
alter table rr add 시설_3 number;
UPDATE RR SET 시설_3 = 3 where 공통분류='시설' and 빈도>9 and 빈도<=16;
alter table rr add 시설_4 number;
UPDATE RR SET 시설_4 = 4 where 공통분류='시설' and 빈도>16;
commit;

ALTER TABLE RFM_2 ADD 시설F NUMBER;
UPDATE rfm_2 set 시설F = 
case when 공통분류='시설' and 빈도<=4 then 1
when 공통분류='시설' and 빈도>4 and 빈도<=9 then 2
when 공통분류='시설' and 빈도>9 and 빈도< 16 then 3
when 공통분류='시설' and 빈도>16 then 4
end;

ALTER TABLE RR ADD 화장품_1 NUMBER;
UPDATE RR SET 화장품_1 = 1 where 공통분류='화장품' and 빈도<=4;
alter table rr add 화장품_2 number;
UPDATE RR SET 화장품_2 = 2 where 공통분류='화장품' and 빈도>4 and 빈도<=8;
alter table rr add 화장품_3 number;
UPDATE RR SET 화장품_3 = 3 where 공통분류='화장품' and 빈도>8 and 빈도<=14;
alter table rr add 화장품_4 number;
UPDATE RR SET 화장품_4 = 4 where 공통분류='화장품' and 빈도>14;
commit;

ALTER TABLE RFM_2 ADD 화장품F NUMBER;
UPDATE rfm_2 set 화장품F = 
case when 공통분류='화장품' and 빈도<=4 then 1
when 공통분류='화장품' and 빈도>4 and 빈도<=8 then 2
when 공통분류='화장품' and 빈도>8 and 빈도< 14 then 3
when 공통분류='화장품' and 빈도>14 then 4
end;

ALTER TABLE RR ADD 잡화_1 NUMBER;
UPDATE RR SET 잡화_1 = 1 where 공통분류='잡화' and 빈도<=3;
alter table rr add 잡화_2 number;
UPDATE RR SET 잡화_2 = 2 where 공통분류='잡화' and 빈도>3 and 빈도<=5;
alter table rr add 잡화_3 number;
UPDATE RR SET 잡화_3 = 3 where 공통분류='잡화' and 빈도>5 and 빈도<=11;
alter table rr add 잡화_4 number;
UPDATE RR SET 잡화_4 = 4 where 공통분류='잡화' and 빈도>11;
commit;

ALTER TABLE RFM_2 ADD 잡화F NUMBER;
UPDATE rfm_2 set 잡화F = 
case when 공통분류='잡화' and 빈도<=3 then 1
when 공통분류='잡화
' and 빈도>3 and 빈도<=5 then 2
when 공통분류='잡화' and 빈도>5 and 빈도< 11 then 3
when 공통분류='잡화' and 빈도>11 then 4
end;




ALTER TABLE RR ADD 악세사리_1 NUMBER;
UPDATE RR SET 악세사리_1 = 1 where 공통분류='악세사리' and 빈도<=1;
alter table rr add 악세사리_2 number;
UPDATE RR SET 악세사리_2 = 2 where 공통분류='악세사리' and 빈도>1 and 빈도<=2;
alter table rr add 악세사리_3 number;
UPDATE RR SET 악세사리_3 = 3 where 공통분류='악세사리' and 빈도>2 and 빈도<=5;
alter table rr add 악세사리_4 number;
UPDATE RR SET 악세사리_4 = 4 where 공통분류='악세사리' and 빈도>5;
commit;

ALTER TABLE RFM_2 ADD 악세사리F NUMBER;
UPDATE rfm_2 set 악세사리F = 
case when 공통분류='악세사리' and 빈도<=1 then 1
when 공통분류='악세사리' and 빈도>1 and 빈도<=2 then 2
when 공통분류='악세사리' and 빈도>2 and 빈도<=5 then 3
when 공통분류='악세사리' and 빈도>5 then 4
end;




ALTER TABLE RR ADD 스포츠레저_1 NUMBER;
UPDATE RR SET 스포츠레저_1 = 1 where 공통분류='스포츠_레저' and 빈도<=1;
alter table rr add 스포츠레저_2 number;
UPDATE RR SET 스포츠레저_2 = 2 where 공통분류='스포츠_레저' and 빈도>1 and 빈도<=2;
alter table rr add 스포츠레저_3 number;
UPDATE RR SET 스포츠레저_3 = 3 where 공통분류='스포츠_레저' and 빈도>2 and 빈도<=3;
alter table rr add 스포츠레저_4 number;
UPDATE RR SET 스포츠레저_4 = 4 where 공통분류='스포츠_레저' and 빈도>3;
commit;

ALTER TABLE RFM_2 ADD 스포츠레저F NUMBER;
UPDATE rfm_2 set 스포츠레저F = 
case when 공통분류='스포츠_레저' and 빈도<=1 then 1
when 공통분류='스포츠_레저' and 빈도>1 and 빈도<=2 then 2
when 공통분류='스포츠_레저' and 빈도>2 and 빈도<=3 then 3
when 공통분류='스포츠_레저' and 빈도>3 then 4
end;



ALTER TABLE RR ADD 전자제품_1 NUMBER;
UPDATE RR SET 전자제품_1 = 1 where 공통분류='전자제품' and 빈도<=1;
alter table rr add 전자제품_2 number;
UPDATE RR SET 전자제품_2 = 2 where 공통분류='전자제품' and 빈도>1 and 빈도<=2;
alter table rr add 전자제품_3 number;
UPDATE RR SET 전자제품_3 = 3 where 공통분류='전자제품' and 빈도>2 and 빈도<=3;
alter table rr add 전자제품_4 number;
UPDATE RR SET 전자제품_4 = 4 where 공통분류='전자제품' and 빈도>3;
commit;


ALTER TABLE RR DROP (전자제품_1,전자제품_2,전자제품_3,전자제품_4);



ALTER TABLE RFM_2 ADD 전자제품F NUMBER;
UPDATE rfm_2 set 전자제품F = 
case when 공통분류='전자제품' and 빈도<=1 then 1
when 공통분류='전자제품' and 빈도>1 and 빈도<=2 then 2
when 공통분류='전자제품' and 빈도>2 and 빈도<=3 then 3
when 공통분류='전자제품' and 빈도>3 then 4
end;




ALTER TABLE RR ADD 아동_1 NUMBER;
UPDATE RR SET 아동_1 = 1 where 공통분류='아동' and 빈도<=2;
alter table rr add 아동_2 number;
UPDATE RR SET 아동_2 = 2 where 공통분류='아동' and 빈도>2 and 빈도<=4;
alter table rr add 아동_3 number;
UPDATE RR SET 아동_3 = 3 where 공통분류='아동' and 빈도>4 and 빈도<=10;
alter table rr add 아동_4 number;
UPDATE RR SET 아동_4 = 4 where 공통분류='아동' and 빈도>10;
commit;


ALTER TABLE RFM_2 ADD 아동F NUMBER;
UPDATE rfm_2 set 아동F = 
case when 공통분류='아동' and 빈도<=2 then 1
when 공통분류='아동' and 빈도>2 and 빈도<=4 then 2
when 공통분류='아동' and 빈도>4 and 빈도<=10 then 3
when 공통분류='아동' and 빈도>10 then 4
end;



alter table rr drop (아동_1,아동_2,아동_3,아동_4);

ALTER TABLE RR ADD 문화_1 NUMBER;
UPDATE RR SET 문화_1 = 1 where 공통분류='문화' and 빈도<=1;
alter table rr add 문화_2 number;
UPDATE RR SET 문화_2 = 2 where 공통분류='문화' and 빈도>1 and 빈도<=2;
alter table rr add 문화_3 number;
UPDATE RR SET 문화_3 = 3 where 공통분류='문화' and 빈도>2 and 빈도<=4;
alter table rr add 문화_4 number;
UPDATE RR SET 문화_4 = 4 where 공통분류='문화' and 빈도>4;
commit;


ALTER TABLE RFM_2 ADD 문화F NUMBER;
UPDATE rfm_2 set 문화F = 
case when 공통분류='문화' and 빈도<=1 then 1
when 공통분류='문화' and 빈도>1 and 빈도<=2 then 2
when 공통분류='문화' and 빈도>2 and 빈도<=4 then 3
when 공통분류='문화' and 빈도>4 then 4
end;
commit;

ALTER TABLE RR ADD 가구_1 NUMBER;
UPDATE RR SET 가구_1 = 1 where 공통분류='가구' and 빈도<=1;
alter table rr add 가구_2 number;
UPDATE RR SET 가구_2 = 2 where 공통분류='가구' and 빈도<=1;
alter table rr add 가구_3 number;
UPDATE RR SET 가구_3 = 3 where 공통분류='가구' and 빈도>1 and 빈도<=2;
alter table rr add 가구_4 number;
UPDATE RR SET 가구_4 = 4 where 공통분류='가구' and 빈도>2;
commit;

ALTER TABLE RFM_2 ADD 가구F NUMBER;
UPDATE rfm_2 set 가구F = 
case when 공통분류='가구' and 빈도<=1 then 1
when 공통분류='가구' and 빈도<=1 then 2
when 공통분류='가구' and 빈도>1 and 빈도<=2 then 3
when 공통분류='가구' and 빈도>2 then 4
end;
commit;


DROP TABLE RFM;
CREATE TABLE RFM AS
SELECT RR.*,R.REQ FROM RR JOIN REQUENCY R ON RR.고객번호 =  R.고객번호 ;


rfm



SELECT * FROM RFM;

ALTER TABLE RFM  DROP COLUMN 공통분류;
ALTER TABLE RFM ADD 공통분류 VARCHAR2(50);
UPDATE t1
SET t1.COL1 = t2.COL1, t1.COL2 = t2.COL2
FROM MY_TABLE AS t1
JOIN MY_OTHER_TABLE AS t2 ON t1.COLID = t2.ID
WHERE t1.COL3 = 'OK';


UPDATE RFM T1 SET T1.반기 = T2.반기
FROM RFM T1 JOIN DATADD3 T2 ON T1.고객번호 = T2.고객번호;
ㅜ 
select R.고객번호, count(*) from datadd3 d, rfm r where r.고객번호 =  d.고객번호 and 
d.공통분류 = '생활' and d.반기 = 1 GROUP BY R.고객번호;





SELECT COUNT(*) FROM RFM;

ALTER TABLE RFM DROP COLUMN 식품1_F;
alter table rfm add 식품1_F number(10);
update rfm t1 set  t1.식품1_F = (select COUNT(*) from DATADD3 t2,RFM T1 where t1.고객번호=t2.고객번호 and t2.반기 = 1 
and t2.공통분류 ='식품' ) ;
COMMIT;


update rfm set 식품1_f = (select count(t2.구매일자) from datadd2 t2 ,rfm t1 where t1.고객번호=t2.고객번호 and t2.반기 = 1 
and t2.공통분류 ='식품'
;
create table 식품1 as 
select  COUNT(*)식품 from rfm t1, datadd3 t2 where t1.고객번호=t2.고객번호 and t2.반기 = 1 
and t2.공통분류 ='식품' 
GROUP BY T2.구매일자
;

SELECT 빈도 FROM RFM r1, datadd3 t2 where t2.고객번호 = r1.고객번호 and t2.공통분류='식품' and t2.반기=1  ;
select * from 기존_감소 r, datadd3 d where d.고객번호 = r.고객번호 and r.고객번호=17675;

alter table rfm add 식품2_F number(10);
update rfm t1 set t1.식품2_F = (select COUNT(*) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2
and t2.공통분류 ='식품');

alter table rfm add 식품3_F number(10);
update rfm t1 set t1.식품3_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3
and t2.공통분류 ='식품');

alter table rfm add 식품4_F number(10);
update rfm t1 set t1.식품4_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4
and t2.공통분류 ='식품');

alter table rfm add 생활1_F number(10);
update rfm t1 set t1.생활1_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 1 
and t2.공통분류 ='생활');

alter table rfm add 생활2_F number(10);
update rfm t1 set t1.생활2_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2
and t2.공통분류 ='생활');

alter table rfm add 생활3_F number(10);
update rfm t1 set t1.생활3_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3
and t2.공통분류 ='생활');

alter table rfm add 생활4_F number(10);
update rfm t1 set t1.생활4_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4
and t2.공통분류 ='생활');

alter table rfm add 잡화1_F number(10);
update rfm t1 set t1.잡화1_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 1 
and t2.공통분류 ='잡화');

alter table rfm add 잡화2_F number(10);
update rfm t1 set t1.잡화2_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2
and t2.공통분류 ='잡화');

alter table rfm add 잡화3_F number(10);
update rfm t1 set t1.잡화3_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3
and t2.공통분류 ='잡화');

alter table rfm add 잡화4_F number(10);
update rfm t1 set t1.잡화4_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4
and t2.공통분류 ='잡화');

commit;

alter table rfm add 화장품1_F number(10);
update rfm t1 set t1.화장품1_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 1 
and t2.공통분류 ='화장품');

alter table rfm add 화장품2_F number(10);
update rfm t1 set t1.화장품2_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2
and t2.공통분류 ='화장품');

alter table rfm add 화장품3_F number(10);
update rfm t1 set t1.화장품3_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3
and t2.공통분류 ='화장품');

alter table rfm add 화장품4_F number(10);
update rfm t1 set t1.화장품4_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4
and t2.공통분류 ='화장품');

alter table rfm add 시설1_F number(10);
update rfm t1 set t1.시설1_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 1 
and t2.공통분류 ='시설');

alter table rfm add 시설2_F number(10);
update rfm t1 set t1.시설2_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2
and t2.공통분류 ='시설');

alter table rfm add 시설3_F number(10);
update rfm t1 set t1.시설3_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3
and t2.공통분류 ='시설');

alter table rfm add 시설4_F number(10);
update rfm t1 set t1.시설4_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4
and t2.공통분류 ='시설');

alter table rfm add 문화1_F number(10);
update rfm t1 set t1.문화1_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 1 
and t2.공통분류 ='문화');

alter table rfm add 문화2_F number(10);
update rfm t1 set t1.문화2_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2
and t2.공통분류 ='문화');

alter table rfm add 문화3_F number(10);
update rfm t1 set t1.문화3_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3
and t2.공통분류 ='문화');

alter table rfm add 문화4_F number(10);
update rfm t1 set t1.문화4_F = (select COUNT(T2.구매일자) from DATADD3 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4
and t2.공통분류 ='문화');

commit;

SELECT * FROM RR;


DROP TABLE REQUENCY;

SELECT 악세사리F from rfm_2 where 악세사리F is not null;
ALTER TABLE RFM_2 ADD "14년 상반기 구매총액" NUMBER;

UPDATE RFM_2 R SET R."14년 상반기 구매총액" = (SELECT R2."14년 상반기 구매총액" FROM 기존_감소 R2 WHERE R2.고객번호 = R.고객번호);

ALTER TABLE RFM_2 ADD "14년 하반기 구매총액" NUMBER;

UPDATE RFM_2 R SET R."14년 하반기 구매총액" = (SELECT R2."14년 하반기 구매총액" FROM 기존_감소 R2 WHERE R2.고객번호 = R.고객번호);

ALTER TABLE RFM_2 ADD "15년 상반기 구매총액" NUMBER;

UPDATE RFM_2 R SET R."15년 상반기 구매총액" = (SELECT R2."15년 상반기 구매총액" FROM 기존_감소 R2 WHERE R2.고객번호 = R.고객번호);

ALTER TABLE RFM_2 ADD "15년 하반기 구매총액" NUMBER;

UPDATE RFM_2 R SET R."15년 하반기 구매총액" = (SELECT R2."15년 하반기 구매총액" FROM 기존_감소 R2 WHERE R2.고객번호 = R.고객번호);

COMMIT;
ALTER TABLE RFM_2 ADD "14년도총구매액" NUMBER;

UPDATE RFM_2 R SET R."14년도총구매액" = (SELECT R2."14년도총구매액" FROM 기존_감소 R2 WHERE R2.고객번호 = R.고객번호);

ALTER TABLE RFM_2 ADD "15년도총구매액" NUMBER;

UPDATE RFM_2 R SET R."15년도총구매액" = (SELECT R2."15년도총구매액" FROM 기존_감소 R2 WHERE R2.고객번호 = R.고객번호);

COMMIT;
--재 생성 공통분류 재작업 후
alter table new_freq drop COLUMN 선선식품f;

alter table NEW_FREQ add 신선식품F number;
UPDATE NEW_FREQ set 신선식품F = 
case when 공통분류='신선식품' and 빈도<=172 then 1
when 공통분류='신선식품' and 빈도>172 and 빈도<= 336 then 2
when 공통분류='신선식품' and 빈도>336 and 빈도<= 571 then 3
when 공통분류='신선식품' and 빈도>571 then 4
end;

alter table NEW_FREQ add 가공식품F number;
UPDATE NEW_FREQ set 가공식품F = 
case when 공통분류='가공식품' and 빈도<=353 then 1
when 공통분류='가공식품' and 빈도>353 and 빈도<= 629 then 2
when 공통분류='가공식품' and 빈도>629 and 빈도<= 997 then 3
when 공통분류='가공식품' and 빈도>997 then 4
end;

alter table NEW_FREQ add 일상용품F number;
UPDATE NEW_FREQ set 일상용품F = 
case when 공통분류='일상용품' and 빈도<=84 then 1
when 공통분류='일상용품' and 빈도>84 and 빈도<= 145 then 2
when 공통분류='일상용품' and 빈도>145 and 빈도<= 237 then 3
when 공통분류='일상용품' and 빈도>237 then 4
end;
COMMIT;


alter table NEW_FREQ add 의류F number;
UPDATE NEW_FREQ set 의류F = 
case when 공통분류='의류' and 빈도<=21 then 1
when 공통분류='의류' and 빈도>21 and 빈도<= 50 then 2
when 공통분류='의류' and 빈도>50 and 빈도<= 101 then 3
when 공통분류='의류' and 빈도>101 then 4
end;
COMMIT;

alter table NEW_FREQ add 패션잡화f number;
UPDATE NEW_FREQ set 패션잡화f = 
case when 공통분류='패션잡화' and 빈도<=10 then 1
when 공통분류='패션잡화' and 빈도>10 and 빈도<= 22 then 2
when 공통분류='패션잡화' and 빈도>22 and 빈도<= 40 then 3
when 공통분류='패션잡화' and 빈도>40 then 4
end;

alter table NEW_FREQ add 전문스포츠_레저f number;
UPDATE NEW_FREQ set 전문스포츠_레저f = 
case when 공통분류='전문스포츠/레저' and 빈도<=5 then 1
when 공통분류='전문스포츠/레저' and 빈도>5 and 빈도<= 11 then 2
when 공통분류='전문스포츠/레저' and 빈도>11 and 빈도<= 24 then 3
when 공통분류='전문스포츠/레저' and 빈도>24 then 4
end;


alter table NEW_FREQ add 디지털_가전f number;
UPDATE NEW_FREQ set 디지털_가전f = 
case when 공통분류='디지털/가전' and 빈도<=7 then 1
when 공통분류='디지털/가전' and 빈도>7 and 빈도<= 15 then 2
when 공통분류='디지털/가전' and 빈도>15 and 빈도<= 49 then 3
when 공통분류='디지털/가전' and 빈도>49 then 4
end;


alter table NEW_FREQ add 교육_문화f number;
UPDATE NEW_FREQ set 교육_문화f = 
case when 공통분류='교육/문화용품' and 빈도<=3 then 1
when 공통분류='교육/문화용품' and 빈도>3 and 빈도<= 10 then 2
when 공통분류='교육/문화용품' and 빈도>10 and 빈도<= 29 then 3
when 공통분류='교육/문화용품' and 빈도>29 then 4
end;

alter table NEW_FREQ add 가구_인테리어F number;
UPDATE NEW_FREQ set 가구_인테리어F = 
case when 공통분류='가구/인테리어' and 빈도<=5 then 1
when 공통분류='가구/인테리어' and 빈도>5 and 빈도<= 11 then 2
when 공통분류='가구/인테리어' and 빈도>11 and 빈도<= 22 then 3
when 공통분류='가구/인테리어' and 빈도>22 then 4
end;

alter table NEW_FREQ add 시설F number;
UPDATE NEW_FREQ set 시설F = 
case when 공통분류='시설' and 빈도<=2 then 1
when 공통분류='시설' and 빈도>2 and 빈도<= 4 then 2
when 공통분류='시설' and 빈도>4 and 빈도< =13 then 3
when 공통분류='시설' and 빈도>13 then 4
end;
commit;


alter table NEW_FREQ add 의료_의약F number;
UPDATE NEW_FREQ set 의료_의약F = 
case when 공통분류='의약품/의료기기' and 빈도<=1 then 1
when 공통분류='의약품/의료기기' and 빈도>1 and 빈도<= 3 then 2
when 공통분류='의약품/의료기기' and 빈도>3 and 빈도< =8 then 3
when 공통분류='의약품/의료기기' and 빈도>8 then 4
end;
commit;

alter table NEW_FREQ add 기타F number;
UPDATE NEW_FREQ set 기타f = 
case when 공통분류='기타' and 빈도<=1 then 1
when 공통분류='기타' and 빈도>1 and 빈도<= 2 then 2
when 공통분류='기타' and 빈도>2 and 빈도< =3 then 3
when 공통분류='기타' and 빈도>3 then 4
end;
commit;

create table new_frm as
select new_freq.* , freq.req
from new_freq,freq
where new_freq.고객번호 = freq.고객번호;

drop table 분류;

create table new_frm2 as
select r."14년 상반기 구매총액",r."14년 하반기 구매총액",r."15년 상반기 구매총액",r."15년 하반기 구매총액",
n.*
from 기존_감소 r, new_frm n
where n.고객번호 = r.고객번호;




create table 시간 as
select 제휴사,시간,공통분류
from datadd3
group by 제휴사,시간,공통분류;





select * from purprod
;
select p.제휴사, sum(p.구매금액),pl.공통분류,RATIO_TO_REPORT(SUM(P.구매금액)) OVER ()* 100||'%' AS RATIO
from purprod p , prodcl_2 pl
where p.제휴사 = pl.제휴사 and p.대분류코드 = pl.대분류코드 and p.중분류코드 = pl.중분류코드 and
p.소분류코드 =pl.소분류코드 and P.제휴사 = 'D'
group by  p.제휴사,pl.공통분류
ORDER BY RATIO DESC
;


alter table pur_area31 add 고객분류코드 number(10);

update pur_area31 set "고객분류코드" = "14년 상반기 구매건수"*1000 + "14년 하반기 구매건수"*100 + "15년 상반기 구매건수"*10 + "15년 하반기 구매건수";

create table 신규고객 as
select * from pur_area31 where "고객분류코드" = 10 or "고객분류코드" = 1 or "고객분류코드"= 11;

create table 신규고객 as
select * from pur_area31 where "고객분류코드" = 10 or "고객분류코드" = 1 or "고객분류코드"= 11;

create table 이탈고객 as
select * from pur_area31 where "고객분류코드" = 1000 or "고객분류코드" = 1100 or "고객분류코드" = 1110 or "고객분류코드" = 1010 or "고객분류코드"=100 or "고객분류코드" = 110;

select count(*) from 기존고객;

select count(*) from 신규고객;

select count(*) from 이탈고객;
DROP TABLE 이탈고객;


SELECT ROUND( AVG(구매일자),2) FROM PURPROD GROUP BY YEAR;


update purprod set year = substr(구매일자,1,4);

SELECT 공통분류,COUNT(*) FROM PRODCL_2 GROUP BY 공통분류 ;
SELECT 소비재분류,COUNT(*) FROM 소비재분류 GROUP BY 소비재분류 ;

select r.소비재분류,sum(p.구매금액)
from 소비재분류 r, purprod p
where p.제휴사 =r.제휴사 and p.대분류코드  = r.대분류코드 and  p.중분류코드 = r.중분류코드  and 
p.소분류코드 = r.소분류코드 
group by r.소비재분류
order by sum(p.구매금액) desc;


select p.공통분류, sum(c.구매금액),round(ratio_to_report(sum(c.구매금액)) over (),2) *100||'%' as 비율
from prodcl_2 p, purprod c
where p.제휴사 = c.제휴사 and p.대분류코드 = c.대분류코드 and p.중분류코드 = c.중분류코드 and
p.소분류코드  =c.소분류코드 
group by p.공통분류
order by sum(c.구매금액) desc;


CREATE TABLE PURCUST AS
SELECT P.고객번호 ,S.공통분류,P.제휴사,P.구매일자,P.구매금액
FROM PURPROD P, PRODCL_2 S
WHERE P.제휴사 = S.제휴사 AND P.대분류코드 = S.대분류코드 AND P.중분류코드  =S.중분류코드  AND
P.소분류코드 = S.소분류코드
GROUP BY  P.고객번호 ,S.공통분류,P.제휴사,P.구매일자,P.구매금액 ;

SELECT * FROM PURCUST;

SELECT 성별,COUNT(성별)
FROM CUSTDEMO
GROUP BY 성별;

--거주지역 그룹핑
SELECT COUNT(거주지역),ROUND(RATIO_TO_REPORT(COUNT(거주지역)) OVER() ,2)*100 ||'%' AS 비율,
CASE WHEN 거주지역 = '100' THEN  '경기'
 WHEN 거주지역 BETWEEN 010 AND 099 THEN  '서울'
 WHEN 거주지역  = '460' THEN '부산'
 WHEN 거주지역 BETWEEN 210 AND 239 THEN '인천'
 WHEN 거주지역 BETWEEN 240 AND 269 THEN '강원'
 WHEN 거주지역 BETWEEN 270 AND 299 THEN '충북'
 WHEN 거주지역 BETWEEN 300 AND 309 THEN '세종'
 WHEN 거주지역 BETWEEN 310 AND 339 THEN '충남'
 WHEN 거주지역 BETWEEN 340 AND 359 THEN '대전'
 WHEN 거주지역 BETWEEN 360 AND 409 THEN '경북'
 WHEN 거주지역 BETWEEN 410 AND 439 THEN '대구'
 WHEN 거주지역 BETWEEN 440 AND 459 THEN '울산'
 WHEN 거주지역 BETWEEN 460 AND 499 THEN '부산'
 WHEN 거주지역 BETWEEN 500 AND 539 THEN '경남'
 WHEN 거주지역 BETWEEN 540 AND 569 THEN '전북'
 WHEN 거주지역 BETWEEN 570 AND 609 THEN '전남'
 WHEN 거주지역 BETWEEN 610 AND 629 THEN '광주'
 WHEN 거주지역 BETWEEN 630 AND 639 THEN '제주'
END 
FROM CUSTDEMO
GROUP BY 거주지역
ORDER BY COUNT(거주지역)DESC;

GROUP BY 거주지역;

SELECT * FROM PURPROD;

alter table purprod add month number;
update purprod set MONTH = substr(구매일자,5,2);


--반기별로 나누어서 차이
CREATE TABLE 상반기RE AS
SELECT 고객번호,TO_DATE('2014-07-01','YYYY-MM-DD') - TO_DATE(MAX(구매일자),'YYYY-MM-DD') AS 상반기RE
FROM PURPROD
WHERE 구매일자>=20140701
GROUP BY 고객번호;


CREATE TABLE 하반기RE AS
SELECT 고객번호,TO_DATE('2015-01-01','YYYY-MM-DD') - TO_DATE(MAX(구매일자),'YYYY-MM-DD') AS 하반기RE
FROM PURPROD
WHERE 구매일자<20140701  AND 구매일자<20150101
GROUP BY 고객번호;

DROP TABLE 하반기RE;


SELECT p.제휴사,c.성별,count(구매일자),ROUND(RATIO_TO_REPORT(count(구매일자)) OVER() ,2)*100 ||'%' AS 비율
FROM PURPROD p ,custdemo c
where p.고객번호 = c.고객번호
GROUP BY p.제휴사,c.성별
ORDER BY 성별 DESC;

select sum(구매금액),avg(구매금액)
from purprod
where year=2015 and month between 1 and 6 ;

select avg(count(*))
from purprod
where year=2015 and month between 7 and 12;


select c.제휴사,sum(c.이용횟수),p.year
from channel c, purprod p
where p.고객번호 = c.고객번호 and p.year=2015 and p.month between 7 and 12
group by c.제휴사,p.year
order by sum(c.이용횟수)desc;

select sum(구매금액)상반기14
from purprod
where month between 1 and 6  and year=2014;


select sum(구매금액)하반기15
from purprod
where month between 7 and 12  and year=2015;

select sum("14년도총구매액"+"15년도총구매액")
from 기존_감소;

select sum(구매금액)
from purprod;


CREATE TABLE PUR_AREA31 AS SELECT custdemo.고객번호,
COUNT(CASE WHEN month between 1 and 6 and year=2014 THEN custdemo.고객번호 END) "14년 상반기 구매건수", 
COUNT(CASE WHEN month between 7 and 12 and year=2014 THEN custdemo.고객번호 END) "14년 하반기 구매건수", 
COUNT(CASE WHEN month between 1 and 6  and year=2015 THEN custdemo.고객번호 END) "15년 상반기 구매건수", 
COUNT(CASE WHEN month between 7 and 12  and year=2015 THEN custdemo.고객번호 END) "15년 하반기 구매건수", 
SUM(CASE WHEN  month between 1 and 6 and year=2014 THEN 구매금액 END) "14년 상반기 구매총액",
SUM(CASE WHEN month between 7 and 12 and year=2014 THEN 구매금액 END) "14년 하반기 구매총액",
SUM(CASE WHEN month between 1 and 6  and year=2015 THEN 구매금액 END) "15년 상반기 구매총액",
SUM(CASE WHEN month between 7 and 12  and year=2015 THEN 구매금액 END) "15년 하반기 구매총액" FROM purprod
LEFT OUTER JOIN custdemo ON purprod.고객번호 = custdemo.고객번호
GROUP BY custdemo.고객번호;

update pur_area31 set "14년 상반기 구매건수" = 1 where "14년 상반기 구매건수" > 0;
update pur_area31 set "14년 하반기 구매건수" = 1 where "14년 하반기 구매건수" > 0;
update pur_area31 set "15년 상반기 구매건수" = 1 where "15년 상반기 구매건수" > 0;
update pur_area31 set "15년 하반기 구매건수" = 1 where "15년 하반기 구매건수" > 0;
commit;

create table 기존고객 as
select * from pur_area31 where "14년 상반기 구매건수"=1 and "14년 하반기 구매건수"=1 and "15년 상반기 구매건수"=1 and "15년 하반기 구매건수"=1;

drop table 기존고객;

select count(*) from 기존고객;

alter table 기존고 add "14년도총구매액" number(20);
alter table 기존고객 add "15년도총구매액" number(20);

update 기존고객 set "14년도총구매액" = "14년 상반기 구매총액"+"14년 하반기 구매총액";
update 기존고객 set "15년도총구매액" = "15년 상반기 구매총액"+"15년 하반기 구매총액";
select count(*) from 기존고객;
select sum("14년도총구매액"+"15년도총구매액") from 기존고객;




create table 기존감소고객 as
select * from 기존고객 where "15년도총구매액"<"14년도총구매액"*1.126;

select sum(구매금액) ;


select sum("14년도총구매액"+"15년도총구매액") from 기존감소고객;


SELECT SUM(구매금액) 
FROM PURPROD;

SELECT SUM("14년도총구매액"+"15년도총구매액")
FROM 기존_감소;

SELECT COUNT(*) FROM 기존감소고객 ;
SELECT SUM("14년도총구매액"+"15년도총구매액") FROM 기존감소고객;
SELECT COUNT(*) FROM 기존_감소 GROUP BY 기존_감소.*;


SELECT * FROM PURPROD WHERE 고객번호 = 00001;
SELECT P.제휴사,P.구매금액,PL.중분류명,PL.소분류명,PL.공통분류,COUNT(*)횟수 FROM PRODCL_2 PL, PURPROD P WHERE P.고객번호 = 00001 AND P.제휴사 = PL.제휴사 AND
P.대분류코드 = PL.대분류코드 AND P.중분류코드 = PL.중분류코드 AND P.소분류코드 = PL.소분류코드
GROUP BY P.제휴사,P.구매금액,PL.중분류명,PL.소분류명,PL.공통분류
ORDER BY 횟수 DESC
;

 TABLE 상품추천_0 AS
SELECT P.고객번호,S.제휴사,S.중분류명,S.상품분류,S.소비재분류
FROM 소비재분류 S,PURPROD P,c0_cluster c
where s.제휴사 = p.제휴사 and s.대분류코드 = p.대분류코드 and  s.중분류코드 = p.중분류코드
and s.소분류코드= p.소분류코드 and c.고객번호= p.고객번호;

SELECT 고객번호,중분류명,상품분류,소비재분류
FROM 상품추천_0
WHERE 상품분류 = '패션/의류';
