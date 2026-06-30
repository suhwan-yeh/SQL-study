create table mysql_v1(member_id int primary key, member_name varchar(45), member_age varchar(45));

select * from mysql_v1;

alter table mysql_v1 change member_age member_addr varchar(45);

insert into mysql_v1 values('jyp', '박진영' , '경기 고양시 장항동');

alter table mysql_v1 modify member_id varchar(45);

insert into mysql_v1 values('iyou', '아이유' , '미국');
update mysql_v1 set member_name='아이유1' where member_id = 'iyou';

select * from mysql_v1 where member_id='iyou';
insert into mysql_v1 values('nhn','나훈아','이집트');
/*
	인덱스 객체 만들기 문법
		create index 생성할 인덱스 개체명 on 테이블명(열명); 
*/
-- member 테이블의 member_name열에 대한 빠른속도로 데이터를 조회 하기 위해 인덱스 개체를 생성하자.
create index idx_member_name on mysql_v1(member_name);

-- 인덱스 개체를 idx_member_name을 생성하고 나서
-- member 테이블에 저장되어 있는 이름이 아이유인 한사람의 정보를 조회
select * from mysql_v1 where member_name='아이유1';
------------------------------------------------------------------------
/*
	뷰 개체 : 가상의 테이블(가짜 테이블)
    뷰 개체 생성 문법
		create view (생성할 뷰명) as select * from 조회할 실제 테이블 명
*/
-- member 테이블에 저장된 모든 열 정보 조회
select * from mysql_v1;

-- mysql.v1 테이블과 연결되는 회원뷰 개체(mysql.v1_view) 생성
create view mysql.v1 as select * from mysql_v1;

-- member 테이블명이 아닌 회원뷰 개체(mysql_view)명으로 조회 가능
select * from mysql_v1 view;
-- 굳이 view 사용하는이유? 	
-- mysql.v1 테이블을 조작하면 데이터가 변경되거나 삭제 될 수 있어 보안에 좋지않다.
-- 그래서 뷰명으로 조회하면 mysql_1테이블을 직접 만져서 조회하지 않기때문에 보안에 좋음

/*
	스토어드 프로시저 개체 
	- 프로그램 코드를 묶어 놓은 함수와 같은 개체
*/
-- 회원테이블에 저장된 데이터들 중에서 member_name 열에 저장된 값이 '박진영'인
-- 행에 관한 모든 열의 해당되는 값들 조회
select * from mysql_v1;
select * from mysql_v1 where member_name='나훈아';
select * from product;

show tables;
select * from product where product_name='삼각김밥';
select * from member where member_name='나훈아';
/*
	스토어드 프로시저 개체 생성 문법
			DELIMITER //
			CREATE PROCEDURE 생성할 스토어드 프로스저명() 
			BEGIN <- [if 문의 중괄호와 같다]
					프로그래밍할 sql문장1; ...
                    프로그래밍할 sql문장2; ....... 
			END // <- [if 문의 중괄호와 같다]
			DELIMITER ;
            
	 주의 : DELIMITER // ~~~~ DELIMITER ; <- 열때는 // 인데 닫을때는 ; 임 공백도 있으니 주의
*/
-- 위 두 select 문을 하나의 기능인 스토어드 프로시저 개체로 만들어 보겠다
delimiter //
create procedure myProc()
begin
	select * from member where member_name='나훈아';
    select * from product where product_name='삼각김밥';
end //
delimiter ;

-- 바로 위에서 만든 myproc라는 이름의 스토어드프로시저 개체를 호출해서 실행하기 위한 문법
--  call 호출할프로시저명();
call myProc();
call myProc();

-- -----------------------------------------------------
-- 주제 : 기본 조회문 select ~ from 절 배우기 
/*
	use 문 
    - select 문으로 테이블에 저장된 데이터를 조회하기 전에 ~~~~
	  먼저 사용할 데이터 베이스를 선택할때 이용하는 예약어.
      - 사용 문법
		use 사용할 데이터베이스명;    
*/

use market_db;
/*
	select   : 조회할_데이터가_저장되어있는_열명
    from     : 조회할_데이터가_저장되어있는_테이블명
    where    : 조건열명 = 조건값
    group by : 그룹으로 _묶을_데이터들이_저장된_열명
    having    : 조건식
    order by : 정렬할_데이터가_저장된_열명 asc 또는 desc
    limit    : 숫자;
    
-- -----------------------------------------------------------------
	select 핵심 문법 
    - 	select   : 조회할_데이터가_저장되어있는_열명
        from     : 조회할_데이터가_저장되어있는_테이블명
        where    : 조건열명 = 조건값
*/
-- 실습 ㄱㄱ
desc member;
select mem_id, mem_name, mem_number, addr, phone1, phone2, height, debut_date
from member;

select * from member;

-- 실습1. 회원테이블(member)에 그룹이름이 저장된 mem_name 열의 데이터들만 조회
select mem_name from member;

-- 실습2. 회원테이블(member)에 주소, 입사년도, 그룹이름만 조회
select * from member;

select addr, debut_date, mem_id from member;

-- 실습3. 회원테이블(member)에 조회할 열명 대신 별칭을 지어서 조회된 결과창에 보여주기 위해서는 
--       아래의 문법 사용 ㄱㄱ
--       select 조회할_열명1 as 별칭명1, 조회할_열명2 as 별칭명2

select addr as "주소", debut_date as "데뷔일자" , mem_id as "그룹영명"from member;

-- 실습4. 회원테이블에서 회원그룹이 '블랙핑크'가 저장되어 있는 위치의 행이 있는 모든 열의 데이터 조회
-- 문법 : 1. select : 조회할 데이터가 저장된 열명 
--       2. from   : 조회할 테이블명
--       3.  where : 조건에서 사용할 데이터들의 저장된 열명 = 보고싶은 행 or 열
select * from member where mem_id="BLK";

-- 실습5. member테이블에서 회원그룹인원(mem_number열의 데이터)이 
select * from member where mem_number = 4;











