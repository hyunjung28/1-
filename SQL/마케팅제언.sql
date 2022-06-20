--c0
SELECT * FROM C0;

SELECT SUM(P.구매금액), S.시간, RATIO_TO_REPORT(COUNT(S.시간)) OVER () 
FROM PURPROD P, 시간 S
WHERE P.제휴사 = S.제휴사 AND "고객번호" IN (SELECT 고객번호 FROM C0)
GROUP BY P.구매금액, S.시간;

ALTER TABLE PURPROD ADD 시간 VARCHAR2(20);
ALTER TABLE PURPROD DROP COLUMN 시간;

COMMIT;
UPDATE PURPROD SET 시간 = '오전'  WHERE  구매시간 <=12;
UPDATE PURPROD SET 시간 = '오후'  WHERE  구매시간 >12;

COMMIT;

DROP TABLE 시간;


RATIO_TO_REPORT(SUM(P.구매금액)) OVER() 
,AVG(P.구매금액),

SELECT C.제휴사,avg(C.이용횟수)
FROM CHANNEL C
WHERE 고객번호 IN (SELECT 고객번호 FROM C0 GROUP BY 고객번호) 
GROUP BY  C.제휴사;



SELECT PL.공통분류,SUM(P.구매금액),ROUND(AVG(P.구매금액),2), RATIO_TO_REPORT(SUM(P.구매금액)) OVER () 
FROM PRODCL_2 PL, PURPROD P
WHERE P.고객번호 IN (SELECT 고객번호 FROM C0 GROUP BY 고객번호) AND P.제휴사 = PL.제휴사 AND P.대분류코드 =PL.대분류코드 AND
P.중분류코드 = PL.중분류코드  AND P.소분류코드 = PL.소분류코드
GROUP BY PL.공통분류
ORDER BY SUM(P.구매금액) DESC;

select * from c1;

--c1
SELECT C.제휴사,avg(C.이용횟수),count(c.이용횟수)
FROM CHANNEL C
WHERE 고객번호 IN (SELECT 고객번호 FROM C2_cluster GROUP BY 고객번호) 
GROUP BY  C.제휴사
order by sum(c.이용횟수) desc;
--채널 이용 비율
SELECT C.제휴사,count(c.이용횟수),ratio_to_report(count(c.이용횟수)) over ()
FROM CHANNEL C
WHERE 고객번호 IN (SELECT 고객번호 FROM C2_cluster GROUP BY 고객번호) 
GROUP BY  C.제휴사
order by sum(c.이용횟수) desc;

--제휴사 이용 비율
select p.제휴사 ,count(p.제휴사),ratio_to_report(count(p.제휴사)) over () 
FROM purprod p
WHERE 고객번호 IN (SELECT 고객번호 FROM C0_cluster GROUP BY 고객번호) 
GROUP BY  p.제휴사;



--어떤 상품 많이 구매하는지
SELECT PL.공통분류,SUM(P.구매금액),ROUND(AVG(P.구매금액),2), RATIO_TO_REPORT(SUM(P.구매금액)) OVER () 
FROM PRODCL_2 PL, PURPROD P
WHERE P.고객번호 IN (SELECT 고객번호 FROM C2_cluster GROUP BY 고객번호) AND P.제휴사 = PL.제휴사 AND P.대분류코드 =PL.대분류코드 AND
P.중분류코드 = PL.중분류코드  AND P.소분류코드 = PL.소분류코드
GROUP BY PL.공통분류
ORDER BY SUM(P.구매금액) DESC;

--오전 오후
SELECT P.시간,COUNT(P.시간),RATIO_TO_REPORT(COUNT(P.시간)) OVER ()
FROM PURPROD P
WHERE  P.고객번호 IN (SELECT 고객번호 FROM C2_cluster GROUP BY 고객번호)
GROUP BY P.시간;

SELECT * FROM C0_CLUSTER;
SELECT RECENCY,COUNT(RECENCY) FROM C0_CLUSTER GROUP BY RECENCY ORDER BY RECENCY DESC;
drop table c0;

SELECT 연령대,COUNT(연령대),RATIO_TO_REPORT(COUNT(연령대))  OVER () FROM C2_CLUSTER GROUP BY 연령대
ORDER BY 연령대 DESC ;

SELECT COUNT(*), AVG(P.구매금액)
FROM PURPROD P
WHERE 고객번호 IN(SELECT 고객번호 FROM C2_CLUSTER GROUP BY 고객번호);
