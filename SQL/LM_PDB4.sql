alter table cuspur2 add 구매등급 number(2);

update cuspur2 set "구매등급" = 1 where "총순위" <= 3230;
update cuspur2 set "구매등급" = 2 where "총순위" > 3230 and "총순위"<=6461;
update cuspur2 set "구매등급" = 3 where "총순위" > 6461 and "총순위"<=9692;
update cuspur2 set "구매등급" = 4 where "총순위" > 9692 and "총순위"<=12922;
update cuspur2 set "구매등급" = 5 where "총순위" > 12922 and "총순위"<=16152;
update cuspur2 set "구매등급" = 6 where "총순위" > 16152;

alter table 기존감소고객_년도기준2 add 구매등급 number(2);

update 기존감소고객_년도기준2 set 구매등급 = 1 where 고객번호 in (select 고객번호 from cuspur2 where 구매등급 = 1);
update 기존감소고객_년도기준2 set 구매등급 = 2 where 고객번호 in (select 고객번호 from cuspur2 where 구매등급 = 2);
update 기존감소고객_년도기준2 set 구매등급 = 3 where 고객번호 in (select 고객번호 from cuspur2 where 구매등급 = 3);
update 기존감소고객_년도기준2 set 구매등급 = 4 where 고객번호 in (select 고객번호 from cuspur2 where 구매등급 = 4);
update 기존감소고객_년도기준2 set 구매등급 = 5 where 고객번호 in (select 고객번호 from cuspur2 where 구매등급 = 5);
update 기존감소고객_년도기준2 set 구매등급 = 6 where 고객번호 in (select 고객번호 from cuspur2 where 구매등급 = 6);

alter table 기존감소고객_구매정보2 add 구매등급 number(2);

update 기존감소고객_구매정보2 set 구매등급 = 1 where 고객번호 in (select 고객번호 from cuspur2 where 구매등급 = 1);
update 기존감소고객_구매정보2 set 구매등급 = 2 where 고객번호 in (select 고객번호 from cuspur2 where 구매등급 = 2);
update 기존감소고객_구매정보2 set 구매등급 = 3 where 고객번호 in (select 고객번호 from cuspur2 where 구매등급 = 3);
update 기존감소고객_구매정보2 set 구매등급 = 4 where 고객번호 in (select 고객번호 from cuspur2 where 구매등급 = 4);
update 기존감소고객_구매정보2 set 구매등급 = 5 where 고객번호 in (select 고객번호 from cuspur2 where 구매등급 = 5);
update 기존감소고객_구매정보2 set 구매등급 = 6 where 고객번호 in (select 고객번호 from cuspur2 where 구매등급 = 6);

commit;

select 고객번호, "14년도총구매액", "15년도총구매액" from 기존감소고객_년도기준2 where 성별 = 'F';

alter table 기존감소고객_년도기준2 add 총구매액 number(20);

update 기존감소고객_년도기준2 set 총구매액 = "14년도총구매액" + "15년도총구매액";

select PERCENTILE_DISC(0.25) within group (order by 총구매액) as q1 from 기존감소고객_년도기준2;

select PERCENTILE_DISC(0.75) within group (order by 총구매액) as q3 from 기존감소고객_년도기준2;
create table 사분위_iqr as
select PERCENTILE_DISC(0.25) within group (order by 총구매액) as q1,
PERCENTILE_DISC(0.75) within group (order by 총구매액) as q3,
PERCENTILE_DISC(0.75) within group (order by 총구매액) - PERCENTILE_DISC(0.25) within group (order by 총구매액) as iqr from 기존감소고객_년도기준2;

create table 기존감소고객_년도기준_이상치제거 as
select r.* from 기존감소고객_년도기준2 r, 사분위_iqr s where r.총구매액 > (s.q1 - 1.5*s.iqr) and r.총구매액 < (s.q3 + 1.5*s.iqr);

select count(*) from 기존감소고객_년도기준_이상치제거 where 성별 = 'F';

create table 기존감소고객_구매정보2_이상치제거 as
select r.* from 기존감소고객_구매정보2 r where 고객번호 in (select 고객번호 from 기존감소고객_년도기준_이상치제거);

select count(*) from 기존감소고객_구매정보2_이상치제거;

select * from 기존감소고객_년도기준_이상치제거 where 구매등급 = 1;

select count(*) from 기존감소고객_구매정보;

select t2.고객번호, sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t2.반기 = 1 and t2.공통분류 ='식품' group by t2.고객번호 order by t2."고객번호";

alter table 기존감소고객_년도기준 add 식품_1 number(20);
update 기존감소고객_년도기준 t1 set t1.식품_1 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 1 and t2.공통분류 ='식품');

alter table 기존감소고객_년도기준 add 식품_2 number(20);
update 기존감소고객_년도기준 t1 set t1.식품_2 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2 and t2.공통분류 ='식품');

alter table 기존감소고객_년도기준 add 식품_3 number(20);
update 기존감소고객_년도기준 t1 set t1.식품_3 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3 and t2.공통분류 ='식품');

alter table 기존감소고객_년도기준 add 식품_4 number(20);
update 기존감소고객_년도기준 t1 set t1.식품_4 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4 and t2.공통분류 ='식품');

alter table 기존감소고객_년도기준 add 생활_1 number(20);
update 기존감소고객_년도기준 t1 set t1.생활_1 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 1 and t2.공통분류 ='생활');

alter table 기존감소고객_년도기준 add 생활_2 number(20);
update 기존감소고객_년도기준 t1 set t1.생활_2 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2 and t2.공통분류 ='생활');

alter table 기존감소고객_년도기준 add 생활_3 number(20);
update 기존감소고객_년도기준 t1 set t1.생활_3 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3 and t2.공통분류 ='생활');

alter table 기존감소고객_년도기준 add 생활_4 number(20);
update 기존감소고객_년도기준 t1 set t1.생활_4 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4 and t2.공통분류 ='생활');

alter table 기존감소고객_년도기준 add 잡화_1 number(20);
update 기존감소고객_년도기준 t1 set t1.잡화_1 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 1 and t2.공통분류 ='잡화');

alter table 기존감소고객_년도기준 add 잡화_2 number(20);
update 기존감소고객_년도기준 t1 set t1.잡화_2 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2 and t2.공통분류 ='잡화');

alter table 기존감소고객_년도기준 add 잡화_3 number(20);
update 기존감소고객_년도기준 t1 set t1.잡화_3 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3 and t2.공통분류 ='잡화');

alter table 기존감소고객_년도기준 add 잡화_4 number(20);
update 기존감소고객_년도기준 t1 set t1.잡화_4 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4 and t2.공통분류 ='잡화');

alter table 기존감소고객_년도기준 add 화장품_1 number(20);
update 기존감소고객_년도기준 t1 set t1.화장품_1 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 1 and t2.공통분류 ='화장품');

alter table 기존감소고객_년도기준 add 화장품_2 number(20);
update 기존감소고객_년도기준 t1 set t1.화장품_2 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2 and t2.공통분류 ='화장품');

alter table 기존감소고객_년도기준 add 화장품_3 number(20);
update 기존감소고객_년도기준 t1 set t1.화장품_3 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3 and t2.공통분류 ='화장품');

alter table 기존감소고객_년도기준 add 화장품_4 number(20);
update 기존감소고객_년도기준 t1 set t1.화장품_4 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4 and t2.공통분류 ='화장품');

alter table 기존감소고객_년도기준 add 시설_1 number(20);
update 기존감소고객_년도기준 t1 set t1.시설_1 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 1 and t2.공통분류 ='시설');

alter table 기존감소고객_년도기준 add 시설_2 number(20);
update 기존감소고객_년도기준 t1 set t1.시설_2 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2 and t2.공통분류 ='시설');

alter table 기존감소고객_년도기준 add 시설_3 number(20);
update 기존감소고객_년도기준 t1 set t1.시설_3 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3 and t2.공통분류 ='시설');

alter table 기존감소고객_년도기준 add 시설_4 number(20);
update 기존감소고객_년도기준 t1 set t1.시설_4 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4 and t2.공통분류 ='시설');

alter table 기존감소고객_년도기준 add 문화_1 number(20);
update 기존감소고객_년도기준 t1 set t1.문화_1 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 1 and t2.공통분류 ='문화');

alter table 기존감소고객_년도기준 add 문화_2 number(20);
update 기존감소고객_년도기준 t1 set t1.문화_2 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2 and t2.공통분류 ='문화');

alter table 기존감소고객_년도기준 add 문화_3 number(20);
update 기존감소고객_년도기준 t1 set t1.문화_3 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3 and t2.공통분류 ='문화');

alter table 기존감소고객_년도기준 add 문화_4 number(20);
update 기존감소고객_년도기준 t1 set t1.문화_4 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4 and t2.공통분류 ='문화');

alter table 기존감소고객_년도기준 add 의류_1 number(20);
update 기존감소고객_년도기준 t1 set t1.의류_1 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 1 and t2.공통분류 ='의류');

alter table 기존감소고객_년도기준 add 의류_2 number(20);
update 기존감소고객_년도기준 t1 set t1.의류_2 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2 and t2.공통분류 ='의류');

alter table 기존감소고객_년도기준 add 의류_3 number(20);
update 기존감소고객_년도기준 t1 set t1.의류_3 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3 and t2.공통분류 ='의류');

alter table 기존감소고객_년도기준 add 의류_4 number(20);
update 기존감소고객_년도기준 t1 set t1.의류_4 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4 and t2.공통분류 ='의류');

alter table 기존감소고객_년도기준 add 가구_1 number(20);
update 기존감소고객_년도기준 t1 set t1.가구_1 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 1 and t2.공통분류 ='가구');

alter table 기존감소고객_년도기준 add 가구_2 number(20);
update 기존감소고객_년도기준 t1 set t1.가구_2 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2 and t2.공통분류 ='가구');

alter table 기존감소고객_년도기준 add 가구_3 number(20);
update 기존감소고객_년도기준 t1 set t1.가구_3 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3 and t2.공통분류 ='가구');

alter table 기존감소고객_년도기준 add 가구_4 number(20);
update 기존감소고객_년도기준 t1 set t1.가구_4 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4 and t2.공통분류 ='가구');


alter table 기존감소고객_년도기준 add 아동_1 number(20);
update 기존감소고객_년도기준 t1 set t1.아동_1 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 1 and t2.공통분류 ='아동');

alter table 기존감소고객_년도기준 add 아동_2 number(20);
update 기존감소고객_년도기준 t1 set t1.아동_2 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2 and t2.공통분류 ='아동');

alter table 기존감소고객_년도기준 add 아동_3 number(20);
update 기존감소고객_년도기준 t1 set t1.아동_3 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3 and t2.공통분류 ='아동');

alter table 기존감소고객_년도기준 add 아동_4 number(20);
update 기존감소고객_년도기준 t1 set t1.아동_4 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4 and t2.공통분류 ='아동');

alter table 기존감소고객_년도기준 add 스포츠_레저_1 number(20);
update 기존감소고객_년도기준 t1 set t1.스포츠_레저_1 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 1 and t2.공통분류 ='스포츠_레저');

alter table 기존감소고객_년도기준 add 스포츠_레저_2 number(20);
update 기존감소고객_년도기준 t1 set t1.스포츠_레저_2 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2 and t2.공통분류 ='스포츠_레저');

alter table 기존감소고객_년도기준 add 스포츠_레저_3 number(20);
update 기존감소고객_년도기준 t1 set t1.스포츠_레저_3 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3 and t2.공통분류 ='스포츠_레저');

alter table 기존감소고객_년도기준 add 스포츠_레저_4 number(20);
update 기존감소고객_년도기준 t1 set t1.스포츠_레저_4 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4 and t2.공통분류 ='스포츠_레저');

alter table 기존감소고객_년도기준 add 악세사리_1 number(20);
update 기존감소고객_년도기준 t1 set t1.악세사리_1 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 1 and t2.공통분류 ='악세사리');

alter table 기존감소고객_년도기준 add 악세사리_2 number(20);
update 기존감소고객_년도기준 t1 set t1.악세사리_2 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2 and t2.공통분류 ='악세사리');

alter table 기존감소고객_년도기준 add 악세사리_3 number(20);
update 기존감소고객_년도기준 t1 set t1.악세사리_3 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3 and t2.공통분류 ='악세사리');

alter table 기존감소고객_년도기준 add 악세사리_4 number(20);
update 기존감소고객_년도기준 t1 set t1.악세사리_4 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4 and t2.공통분류 ='악세사리');

alter table 기존감소고객_년도기준 add 전자제품_1 number(20);
update 기존감소고객_년도기준 t1 set t1.전자제품_1 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 1 and t2.공통분류 ='전자제품');

alter table 기존감소고객_년도기준 add 전자제품_2 number(20);
update 기존감소고객_년도기준 t1 set t1.전자제품_2 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 2 and t2.공통분류 ='전자제품');

alter table 기존감소고객_년도기준 add 전자제품_3 number(20);
update 기존감소고객_년도기준 t1 set t1.전자제품_3 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 3 and t2.공통분류 ='전자제품');

alter table 기존감소고객_년도기준 add 전자제품_4 number(20);
update 기존감소고객_년도기준 t1 set t1.전자제품_4 = (select sum(t2.구매금액) from 기존감소고객_구매정보 t2 where t1."고객번호"=t2."고객번호" and t2.반기 = 4 and t2.공통분류 ='전자제품');

select 제휴사, count(*) from prodcl group by 제휴사;

select 대분류코드, count(대분류코드) from prodcl where 제휴사 = 'C' group by "대분류코드";

select * from prodcl where 제휴사 = 'B' order by 소분류코드;

select * from purcust3 where 고객번호 = '00003' and 소비재분류 = '선매품'
