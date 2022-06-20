select 소비재분류, count(*) from purcust4 group by 소비재분류;

create table 반기별구매액 as
select 고객번호,
SUM(CASE WHEN 반기 = 1 THEN 구매금액 END) "y14_1",
SUM(CASE WHEN 반기 = 2 THEN 구매금액 END) "y14_2",
SUM(CASE WHEN 반기 = 3 THEN 구매금액 END) "y15_1",
SUM(CASE WHEN 반기 = 4 THEN 구매금액 END) "y15_2", 
SUM(CASE WHEN 반기 = 1 and "소비재분류"='선매품' THEN 구매금액 END) "선매품_1",
SUM(CASE WHEN 반기 = 2 and "소비재분류"='선매품' THEN 구매금액 END) "선매품_2",
SUM(CASE WHEN 반기 = 3 and "소비재분류"='선매품' THEN 구매금액 END) "선매품_3",
SUM(CASE WHEN 반기 = 4 and "소비재분류"='선매품' THEN 구매금액 END) "선매품_4",
SUM(CASE WHEN 반기 = 1 and "소비재분류"='편의품' THEN 구매금액 END) "편의품_1",
SUM(CASE WHEN 반기 = 2 and "소비재분류"='편의품' THEN 구매금액 END) "편의품_2",
SUM(CASE WHEN 반기 = 3 and "소비재분류"='편의품' THEN 구매금액 END) "편의품_3",
SUM(CASE WHEN 반기 = 4 and "소비재분류"='편의품' THEN 구매금액 END) "편의품_4",
SUM(CASE WHEN 반기 = 1 and "소비재분류"='전문품' THEN 구매금액 END) "전문품_1",
SUM(CASE WHEN 반기 = 2 and "소비재분류"='전문품' THEN 구매금액 END) "전문품_2",
SUM(CASE WHEN 반기 = 3 and "소비재분류"='전문품' THEN 구매금액 END) "전문품_3",
SUM(CASE WHEN 반기 = 4 and "소비재분류"='전문품' THEN 구매금액 END) "전문품_4",
SUM(CASE WHEN 반기 = 1 and "소비재분류"='기타' THEN 구매금액 END) "기타_1",
SUM(CASE WHEN 반기 = 2 and "소비재분류"='기타' THEN 구매금액 END) "기타_2",
SUM(CASE WHEN 반기 = 3 and "소비재분류"='기타' THEN 구매금액 END) "기타_3",
SUM(CASE WHEN 반기 = 4 and "소비재분류"='기타' THEN 구매금액 END) "기타_4"
FROM PURCUST4
group by 고객번호
order by 고객번호;

commit;

select count(*) from custdemo;

create table 제휴사별반기구매액 as
select 고객번호,
SUM(CASE WHEN 반기 = 1 and 제휴사 = 'A' THEN 구매금액 END) "A_1",
SUM(CASE WHEN 반기 = 2 and 제휴사 = 'A' THEN 구매금액 END) "A_2",
SUM(CASE WHEN 반기 = 3 and 제휴사 = 'A' THEN 구매금액 END) "A_3",
SUM(CASE WHEN 반기 = 4 and 제휴사 = 'A' THEN 구매금액 END) "A_4",
SUM(CASE WHEN 반기 = 1 and 제휴사 = 'B' THEN 구매금액 END) "B_1",
SUM(CASE WHEN 반기 = 2 and 제휴사 = 'B' THEN 구매금액 END) "B_2",
SUM(CASE WHEN 반기 = 3 and 제휴사 = 'B' THEN 구매금액 END) "B_3",
SUM(CASE WHEN 반기 = 4 and 제휴사 = 'B' THEN 구매금액 END) "B_4",
SUM(CASE WHEN 반기 = 1 and 제휴사 = 'C' THEN 구매금액 END) "C_1",
SUM(CASE WHEN 반기 = 2 and 제휴사 = 'C' THEN 구매금액 END) "C_2",
SUM(CASE WHEN 반기 = 3 and 제휴사 = 'C' THEN 구매금액 END) "C_3",
SUM(CASE WHEN 반기 = 4 and 제휴사 = 'C' THEN 구매금액 END) "C_4",
SUM(CASE WHEN 반기 = 1 and 제휴사 = 'D' THEN 구매금액 END) "D_1",
SUM(CASE WHEN 반기 = 2 and 제휴사 = 'D' THEN 구매금액 END) "D_2",
SUM(CASE WHEN 반기 = 3 and 제휴사 = 'D' THEN 구매금액 END) "D_3",
SUM(CASE WHEN 반기 = 4 and 제휴사 = 'D' THEN 구매금액 END) "D_4"
from purcust4
group by "고객번호"
order by "고객번호";

select round(avg(구매금액)) from purcust4;

commit;
create table prodcost as
select 소분류코드, min(구매금액) 제품기본금액 from purprod group by 소분류코드 order by 소분류코드;
create table prodcost2 as
select 소분류코드, 제품기본금액, rank() over (order by 제품기본금액 desc) 기본금액순위 from prodcost;

select count(*) from prodcost2;

alter table prodcost2 add 금액등급 number(2);

update prodcost2 set 금액등급 = 1 where 제품기본금액 >= 50000;
update prodcost2 set 금액등급 = 2 where 제품기본금액 < 50000 and 제품기본금액>=10000;
update prodcost2 set 금액등급 = 3 where 제품기본금액 < 10000;

select * from prodcl where "소분류코드" in (select 소분류코드 from prodcost2 where 금액등급 = 1);



select 고객번호,
SUM(CASE WHEN 반기 = 1 and 금액등급 = 1 THEN 구매금액 END) "고가_1",
SUM(CASE WHEN 반기 = 2 and 금액등급 = 1 THEN 구매금액 END) "고가_2",
SUM(CASE WHEN 반기 = 3 and 금액등급 = 1 THEN 구매금액 END) "고가_3",
SUM(CASE WHEN 반기 = 4 and 금액등급 = 1 THEN 구매금액 END) "고가_4",
SUM(CASE WHEN 반기 = 1 and 금액등급 = 2 THEN 구매금액 END) "중가_1",
SUM(CASE WHEN 반기 = 2 and 금액등급 = 2 THEN 구매금액 END) "중가_2",
SUM(CASE WHEN 반기 = 3 and 금액등급 = 2 THEN 구매금액 END) "중가_3",
SUM(CASE WHEN 반기 = 4 and 금액등급 = 2 THEN 구매금액 END) "중가_4",
SUM(CASE WHEN 반기 = 1 and 금액등급 = 3 THEN 구매금액 END) "저가_1",
SUM(CASE WHEN 반기 = 2 and 금액등급 = 3 THEN 구매금액 END) "저가_2",
SUM(CASE WHEN 반기 = 3 and 금액등급 = 3 THEN 구매금액 END) "저가_3",
SUM(CASE WHEN 반기 = 4 and 금액등급 = 3 THEN 구매금액 END) "저가_4"
from purcust4
group by 고객번호
order by 고객번호;

select 멤버십명, count(*) from membership group by 멤버십명;

select 공통분류, count(*) from prodcl group by "공통분류";
commit;
create table 공통분류별반기구매액 as
select 고객번호,
SUM(CASE WHEN 반기 = 1 and 공통분류 = '가공식품' THEN 구매금액 END) "가공식품_1",
SUM(CASE WHEN 반기 = 2 and 공통분류 = '가공식품' THEN 구매금액 END) "가공식품_2",
SUM(CASE WHEN 반기 = 3 and 공통분류 = '가공식품' THEN 구매금액 END) "가공식품_3",
SUM(CASE WHEN 반기 = 4 and 공통분류 = '가공식품' THEN 구매금액 END) "가공식품_4",
SUM(CASE WHEN 반기 = 1 and 공통분류 = '신선식품' THEN 구매금액 END) "신선식품_1",
SUM(CASE WHEN 반기 = 2 and 공통분류 = '신선식품' THEN 구매금액 END) "신선식품_2",
SUM(CASE WHEN 반기 = 3 and 공통분류 = '신선식품' THEN 구매금액 END) "신선식품_3",
SUM(CASE WHEN 반기 = 4 and 공통분류 = '신선식품' THEN 구매금액 END) "신선식품_4",
SUM(CASE WHEN 반기 = 1 and 공통분류 = '일상용품' THEN 구매금액 END) "일상용품_1",
SUM(CASE WHEN 반기 = 2 and 공통분류 = '일상용품' THEN 구매금액 END) "일상용품_2",
SUM(CASE WHEN 반기 = 3 and 공통분류 = '일상용품' THEN 구매금액 END) "일상용품_3",
SUM(CASE WHEN 반기 = 4 and 공통분류 = '일상용품' THEN 구매금액 END) "일상용품_4",
SUM(CASE WHEN 반기 = 1 and 공통분류 = '의류' THEN 구매금액 END) "의류_1",
SUM(CASE WHEN 반기 = 2 and 공통분류 = '의류' THEN 구매금액 END) "의류_2",
SUM(CASE WHEN 반기 = 3 and 공통분류 = '의류' THEN 구매금액 END) "의류_3",
SUM(CASE WHEN 반기 = 4 and 공통분류 = '의류' THEN 구매금액 END) "의류_4",
SUM(CASE WHEN 반기 = 1 and 공통분류 = '패션잡화' THEN 구매금액 END) "패션잡화_1",
SUM(CASE WHEN 반기 = 2 and 공통분류 = '패션잡화' THEN 구매금액 END) "패션잡화_2",
SUM(CASE WHEN 반기 = 3 and 공통분류 = '패션잡화' THEN 구매금액 END) "패션잡화_3",
SUM(CASE WHEN 반기 = 4 and 공통분류 = '패션잡화' THEN 구매금액 END) "패션잡화_4",
SUM(CASE WHEN 반기 = 1 and 공통분류 = '전문스포츠/레저' THEN 구매금액 END) "전문스포츠/레저_1",
SUM(CASE WHEN 반기 = 2 and 공통분류 = '전문스포츠/레저' THEN 구매금액 END) "전문스포츠/레저_2",
SUM(CASE WHEN 반기 = 3 and 공통분류 = '전문스포츠/레저' THEN 구매금액 END) "전문스포츠/레저_3",
SUM(CASE WHEN 반기 = 4 and 공통분류 = '전문스포츠/레저' THEN 구매금액 END) "전문스포츠/레저_4",
SUM(CASE WHEN 반기 = 1 and 공통분류 = '디지털/가전' THEN 구매금액 END) "디지털/가전_1",
SUM(CASE WHEN 반기 = 2 and 공통분류 = '디지털/가전' THEN 구매금액 END) "디지털/가전_2",
SUM(CASE WHEN 반기 = 3 and 공통분류 = '디지털/가전' THEN 구매금액 END) "디지털/가전_3",
SUM(CASE WHEN 반기 = 4 and 공통분류 = '디지털/가전' THEN 구매금액 END) "디지털/가전_4",
SUM(CASE WHEN 반기 = 1 and 공통분류 = '교육/문화용품' THEN 구매금액 END) "교육/문화용품_1",
SUM(CASE WHEN 반기 = 2 and 공통분류 = '교육/문화용품' THEN 구매금액 END) "교육/문화용품_2",
SUM(CASE WHEN 반기 = 3 and 공통분류 = '교육/문화용품' THEN 구매금액 END) "교육/문화용품_3",
SUM(CASE WHEN 반기 = 4 and 공통분류 = '교육/문화용품' THEN 구매금액 END) "교육/문화용품_4",
SUM(CASE WHEN 반기 = 1 and 공통분류 = '가구/인테리어' THEN 구매금액 END) "가구/인테리어_1",
SUM(CASE WHEN 반기 = 2 and 공통분류 = '가구/인테리어' THEN 구매금액 END) "가구/인테리어_2",
SUM(CASE WHEN 반기 = 3 and 공통분류 = '가구/인테리어' THEN 구매금액 END) "가구/인테리어_3",
SUM(CASE WHEN 반기 = 4 and 공통분류 = '가구/인테리어' THEN 구매금액 END) "가구/인테리어_4",
SUM(CASE WHEN 반기 = 1 and 공통분류 = '시설' THEN 구매금액 END) "시설_1",
SUM(CASE WHEN 반기 = 2 and 공통분류 = '시설' THEN 구매금액 END) "시설_2",
SUM(CASE WHEN 반기 = 3 and 공통분류 = '시설' THEN 구매금액 END) "시설_3",
SUM(CASE WHEN 반기 = 4 and 공통분류 = '시설' THEN 구매금액 END) "시설_4",
SUM(CASE WHEN 반기 = 1 and 공통분류 = '의약품/의료기기' THEN 구매금액 END) "의약품/의료기기_1",
SUM(CASE WHEN 반기 = 2 and 공통분류 = '의약품/의료기기' THEN 구매금액 END) "의약품/의료기기_2",
SUM(CASE WHEN 반기 = 3 and 공통분류 = '의약품/의료기기' THEN 구매금액 END) "의약품/의료기기_3",
SUM(CASE WHEN 반기 = 4 and 공통분류 = '의약품/의료기기' THEN 구매금액 END) "의약품/의료기기_4"
from purcust4
group by "고객번호"
order by "고객번호";

create table 반기별주중주말구매액 as
select 고객번호,
SUM(CASE WHEN 반기 = 1 and 주중_주말 = '주중' THEN 구매금액 END) "주중_1",
SUM(CASE WHEN 반기 = 2 and 주중_주말 = '주중' THEN 구매금액 END) "주중_2",
SUM(CASE WHEN 반기 = 3 and 주중_주말 = '주중' THEN 구매금액 END) "주중_3",
SUM(CASE WHEN 반기 = 4 and 주중_주말 = '주중' THEN 구매금액 END) "주중_4",
SUM(CASE WHEN 반기 = 1 and 주중_주말 = '주말' THEN 구매금액 END) "주말_1",
SUM(CASE WHEN 반기 = 2 and 주중_주말 = '주말' THEN 구매금액 END) "주말_2",
SUM(CASE WHEN 반기 = 3 and 주중_주말 = '주말' THEN 구매금액 END) "주말_3",
SUM(CASE WHEN 반기 = 4 and 주중_주말 = '주말' THEN 구매금액 END) "주말_4"

from purcust4
group by 고객번호
order by 고객번호;

commit;
ALTER TABLE c0 ALTER COLUMN 고객번호 varchar(5);

alter table purcust4 add 구매등급 varchar(10);
update purcust4 set 구매등급 = '고가' where 구매금액 > 2*23678;
update purcust4 set 구매등급 = '중가' where 구매금액 <= 2*23678 and 구매금액 > 0.5*23678;
update purcust4 set 구매등급 = '저가' where 구매금액 <= 0.5*23678;

create table c0_new as
select to_char(고객번호) 고객번호 from c0;

update c0_new set 고객번호 = concat('0000',고객번호) where length(고객번호) = 1;
update c0_new set 고객번호 = concat('000',고객번호) where length(고객번호) = 2;
update c0_new set 고객번호 = concat('00',고객번호) where length(고객번호) = 3;
update c0_new set 고객번호 = concat('0',고객번호) where length(고객번호) = 4;


create table c1_new as
select to_char(고객번호) 고객번호 from c1;

update c1_new set 고객번호 = concat('0000',고객번호) where length(고객번호) = 1;
update c1_new set 고객번호 = concat('000',고객번호) where length(고객번호) = 2;
update c1_new set 고객번호 = concat('00',고객번호) where length(고객번호) = 3;
update c1_new set 고객번호 = concat('0',고객번호) where length(고객번호) = 4;

create table c2_new as
select to_char(고객번호) 고객번호 from c2;

update c2_new set 고객번호 = concat('0000',고객번호) where length(고객번호) = 1;
update c2_new set 고객번호 = concat('000',고객번호) where length(고객번호) = 2;
update c2_new set 고객번호 = concat('00',고객번호) where length(고객번호) = 3;
update c2_new set 고객번호 = concat('0',고객번호) where length(고객번호) = 4;


select 고객번호 from c0_new order by 고객번호;
select 고객번호 from c1_new order by 고객번호;
select 고객번호 from c2_new order by 고객번호;


select * from purcust4 where 고객번호 in (select 고객번호 from c0_new) order by 고객번호;
select * from channel where 고객번호 in (select 고객번호 from c0_new) order by 고객번호;
select count(*) from channel where 고객번호 in (select 고객번호 from c0_new);
select 제휴사, count(제휴사) from channel where 고객번호 in (select 고객번호 from c0_new) group by 제휴사;
select 제휴사, count(제휴사) from channel where 고객번호 in (select 고객번호 from c1_new) group by 제휴사;
select 제휴사, count(제휴사) from channel where 고객번호 in (select 고객번호 from c2_new) group by 제휴사;

select 구매등급, count(구매등급) from purcust4 where 고객번호 in (select 고객번호 from c0_new) group by 구매등급;
select 구매등급, count(구매등급) from purcust4 where 고객번호 in (select 고객번호 from c1_new) group by 구매등급;
select 구매등급, count(구매등급) from purcust4 where 고객번호 in (select 고객번호 from c2_new) group by 구매등급;

select 연령대, count(연령대), round(ratio_to_report(count(연령대)) over (),3 )  as 비율 from purcust4 where 고객번호 in (select 고객번호 from c0_new) group by 연령대 order by 비율 desc;
select 연령대, count(연령대), round(ratio_to_report(count(연령대)) over (),3 )  as 비율 from purcust4 where 고객번호 in (select 고객번호 from c1_new) group by 연령대 order by 비율 desc;
select 연령대, count(연령대), round(ratio_to_report(count(연령대)) over (),3 )  as 비율 from purcust4 where 고객번호 in (select 고객번호 from c2_new) group by 연령대 order by 비율 desc;

select 공통분류, count(공통분류), round(ratio_to_report(count(공통분류)) over (),3 )  as 비율 from purcust4 where 고객번호 in (select 고객번호 from c0_new) group by 공통분류 order by 비율 desc;
select 공통분류, count(공통분류), round(ratio_to_report(count(공통분류)) over (),3 )  as 비율 from purcust4 where 고객번호 in (select 고객번호 from c1_new) group by 공통분류 order by 비율 desc;
select 공통분류, count(공통분류), round(ratio_to_report(count(공통분류)) over (),3 )  as 비율 from purcust4 where 고객번호 in (select 고객번호 from c2_new) group by 공통분류 order by 비율 desc;

select 구매등급, count(구매등급), round(ratio_to_report(count(구매등급)) over (),3 )  as 비율 from purcust4 where 고객번호 in (select 고객번호 from c0_new) group by 구매등급 order by 비율 desc;
select 구매등급, count(구매등급), round(ratio_to_report(count(구매등급)) over (),3 )  as 비율 from purcust4 where 고객번호 in (select 고객번호 from c1_new) group by 구매등급 order by 비율 desc;
select 구매등급, count(구매등급), round(ratio_to_report(count(구매등급)) over (),3 )  as 비율 from purcust4 where 고객번호 in (select 고객번호 from c2_new) group by 구매등급 order by 비율 desc;

select 제휴사, count(제휴사), round(ratio_to_report(count(제휴사)) over (),3 )  as 비율 from purcust4 where 고객번호 in (select 고객번호 from c0_new) group by 제휴사 order by 비율 desc;
select 제휴사, count(제휴사), round(ratio_to_report(count(제휴사)) over (),3 )  as 비율 from purcust4 where 고객번호 in (select 고객번호 from c1_new) group by 제휴사 order by 비율 desc;
select 제휴사, count(제휴사), round(ratio_to_report(count(제휴사)) over (),3 )  as 비율 from purcust4 where 고객번호 in (select 고객번호 from c2_new) group by 제휴사 order by 비율 desc;

select 주중_주말, count(주중_주말), round(ratio_to_report(count(주중_주말)) over (),3 )  as 비율 from purcust4 where 고객번호 in (select 고객번호 from c0_new) group by 주중_주말 order by 비율 desc;
select 주중_주말, count(주중_주말), round(ratio_to_report(count(주중_주말)) over (),3 )  as 비율 from purcust4 where 고객번호 in (select 고객번호 from c1_new) group by 주중_주말 order by 비율 desc;
select 주중_주말, count(주중_주말), round(ratio_to_report(count(주중_주말)) over (),3 )  as 비율 from purcust4 where 고객번호 in (select 고객번호 from c2_new) group by 주중_주말 order by 비율 desc;

select 구매등급, count(구매등급) from purcust4 group by 구매등급;

select sum(가공식품_4 - 가공식품_1) 가공, sum(신선식품_4 - 신선식품_1) 신선, sum(일상용품_4 - 일상용품_1) 일상, sum(의류_4 - 의류_1) 의류, sum(패션잡화_4 - 패션잡화_1) 패션, sum("전문스포츠/레저_4" - "전문스포츠/레저_1") 스포츠, sum("디지털/가전_4"-"디지털/가전_1") 가전, sum("교육/문화용품_4" - "교육/문화용품_1") 문화, sum("가구/인테리어_4"-"가구/인테리어_1") 가구, sum(시설_4-시설_1) 시설, sum("의약품/의료기기_4"-"의약품/의료기기_1") 의약 from 공통분류별반기구매액 where 고객번호 in (select 고객번호 from c2_new);

select sum(A_4 - A_1) A, sum(B_4 - B_1) B , sum(C_4 - C_1) C, sum(D_4 -D_1) D from 제휴사별반기구매액 where 고객번호 in (select 고객번호 from c0_new);

alter table prodcl add 대중분류코드 varchar(20);

update prodcl set 대중분류코드 = concat("제휴사", "중분류코드");

alter table purprod add 대중분류코드 varchar(20);

update purprod set 대중분류코드 = concat("제휴사", "중분류코드");

commit;