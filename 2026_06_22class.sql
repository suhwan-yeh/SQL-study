
-- 한줄 주석

# 한줄 주석

/*
 여러 줄 주석
 여러 줄 주석 
*/
--  현재 MySQL DBMS 서버에 만들어져 있는 데이터베이스 목록 보기 명령
show databases;

--  사용할 데이터베이스 선택 명령
-- 작성 문법 :    use 사용할데이터베이스명;
use world;

/*
	특정 테이블에 저장된 모든 열의 데이터들을 조회(검색)
    
	문법
		select 조회할데이터가_저장된_열명1, 열명2, 열명3
        from 조회할_테이블명;
	
    문법
		select *
        from 조회할_테이블명;
        
	문법 
		select *
        from 조회할_테이블명
        where 조건값이_저장된_열명 = 조건값; 
		
    요약 : member 테이블(표)에 저장된 member_id, member_addr 열 세로 방향의 각칸에 저장된 값 조회
*/
-- 풀이  : member테이블에 저장된 데이터들 중에서 
--        member_id열 방향(세로 방향)에 저장된 데이터와 
--        member_addr열 방향(세로 방향)에 저장된 데이터 들만 모두 조회
		  select member_id, member_addr
          from member;

-- 풀이   :  member 테이블에 저장된 모든 열의 데이터들 조회
		  select  *
          from member;

-- 풀이   : member_name열 방향(세로 방향)에 저장된 이름들 중에서 "아이유"가 저장된 행 위치의 모든 열의 값 조회
-- 요약   : 이름이 아이유인 회원의 모든 열 데이터 조회 
		  select *
          from member
          where member_name = '아이유';

-- 맛보기 끝 

-- ---------------------------------------------------------------------------------------------
/*
	개체(객체) ?  데이터로 표현하고자 하는 데이터베이스의 구성요소
    
    개체 종류 : 테이블 ,  인덱스,  뷰, 스토어드프로시저, 트리거, 함수, 커서 등.......

	1.인덱스(index) 개체 
    - 데이터베이스 테이블에 저장된 데이터의 검색 속도를 향상시키기 위한 개체 
*/
-- 인덱스 개체를 생성해서 사용하지 않고 
-- member테이블에 저장되어 있는 이름이 아이유인 한사람의 정보 조회
select  * from  member
where member_name = '아이유';

/*
	인덱스 객체 만들기 문법
		CREATE INDEX 생성할인덱스개체명 ON 테이블명(열명);
*/
-- member 테이블의 member_name열에 대한 빠른속도로 데이터를 조회 하기 위해 인덱스 개체를 생성하자.
CREATE INDEX idx_member_name ON member(member_name);

-- 인덱스 개체를 idx_member_name 을 생성하고 나서 
-- member테이블에 저장되어 있는 이름이 아이유인 한사람의 정보를 조회 
select * from member
where member_name = '아이유';

-- ------------------------------------------------------------------------------
/*
	뷰 개체  :   가상의 테이블(가짜 테이블)
    
    뷰 개체 생성 문법
		
			create view 생성할뷰명
            as select * from 조회할_실제_테이블명;
*/
-- member 테이블에 저장된 모든 열 정보 조회 
select * from member;

-- member 테이블과 연결되는 회원뷰 개체(member_view) 생성
create view member_view
as select * from member;

-- member 테이블명이 아닌~~~ 회원뷰 개체(member_view)명으로 
-- member 테이블의 정보를 조회 할수 있다.
select * from member_view;


-- 조회시 테이블을 사용하지 않고 굳이 뷰를 사용하여 조회한 이유는?
-- 1. member테이블을 조작하면 데이터가 변경되거나 삭제 될수 있어 보안에 좋지 않음
--    그래서 뷰명으로 조회 하면 member테이블을 직접 만져서 조회하지 않기떄문에 보안에 좋음
-- 2. 긴 조회 SELECT SQL문을 간략하게 만들수도 있다.
-- ---------------------------------------------------------------------------

/*
	스토어드 프로시저 개체 :  프로그램 코드를 묶어 놓은 함수와 같은 개체 
*/
-- 회원테이블(member)에 저장된 데이터들 중에서 member_name열에 저장된 값이 '나훈아'인
-- 행 에 관한 모든 열의 해당되는 값들을 조회 
select * from member where member_name = '나훈아';

-- 상품테이블(product)에 저장된 데이터들 중에서 product_name열에 저장된 값이 '삼각김밥'인
-- 행 에 관한 모든 열의 해당되는 값들을 조회 
select * from product where product_name = '삼각김밥';

/*
	스토어드 프로시저 개체 생성 문법
    
			DELIMITER //
			CREATE PROCEDURE 생성할스토어드프로시저명() 
			BEGIN
					프로그래밍할 SQL문장1;
                    프로그래밍할 SQL문장2; ..........
			END //
			DELIMITER ;
            
	  참고. 위 첫 행과 마지막 행에 구분 문자라는 의미의 DELIMITER // 와 
           DELIMITER; 문을 작성 하였는데...
           일단 이것은 스토어드 프로시저를 만들기 위해 묶어 주는 약속의 문법 이라고 생각 하면됩니다.    
            
*/
--  위 두 SELECT 문을 하나의 기능인 스토어드 프로시저 개체로 만들어 보겠습니다.
DELIMITER //
CREATE PROCEDURE myProc()
BEGIN
		select * from member where member_name = '나훈아';
        select * from product where product_name = '삼각김밥';
END //
DELIMITER ;

-- 바로 위에서 만든 myProc라는 이름의 스토어드프로시저 개체를 호출해서 실행하기 위한 문법
--   CALL 호출할프로시저명();
CALL myProc();
CALL myProc();
CALL myProc();

-- -------------------------------------------------------------------------------
-- 주제 : 기본 조회문  SELECT ~ FROM 절 배우기 

/*
		USE 문
		- SELECT문으로 테이블에 저장된 데이터를 조회하기 전에 ~~~~~
          먼저 사용할 데이터베이스를 선택할때 이용하는 예약어.
          
		- 사용 문법
			USE 사용할데이터베이스명;
*/
use market_db;

/*
	SELECT 문?
		- 특정 테이블 표에 저장되어 있는 데이터를 조회하여 가져올때 사용되는 SQL구문.
        
    SELECT문 전체 작성 문법
		
		 SELECT 조회할_데이터가_저장되어있는_열명
         FROM   조회할_데이터가_저장되어있는_테이블명
         WHERE  조건열명 = 조건값
         GROUP BY 그룹으로_묶을_데이터들이_저장된_열명
         HAVING  조건식
         ORDER BY 정렬할_데이터가_저장된_열명 ASC 또는 DESC
         LIMIT 숫자;
			
	----------------------------------------------------
    
		SELECT 핵심 문법1.
        
		 SELECT 조회할_데이터가_저장되어있는_열명
         FROM   조회할_데이터가_저장되어있는_테이블명
         WHERE  조건열명 = 조건값;					
*/
-- 실습0. member테이블에 저장된 모든 열의 값 조회 
select mem_id, mem_name, mem_number, addr, phone1, phone2, height, debut_date
from member;

-- select -> 테이블에서 데이터를 조회 해서 가져올때 사용되는 예약어.
-- * -> 조회해 올 데이터가 저장된 모든열명.
-- from -> 테이블에서 데이터를 조회해 온다는 의미의 예약어. 
-- member -> 조회할 데이터가 저장된 테이블명.
select *
from member;
-- 풀어서 해석하면? member테이블에 저장된 모든 열의 데이터들을 조회해서 가져오라~ 의미 

-- 실습1. 회원테이블(member)에 그룹이름이 저장된 mem_name열의 데이터들만 조회 
-- 작성 문법
--          select 조회할_데이터가_저장된_열명  from  조회할_테이블명;
select mem_name from member;

--  실습2. 회원테이블(member)에 주소addr, 입사년도debut_date, 그룹이름mem_name열의 데이터들만 조회
select addr, debut_date, mem_name from member;

-- 실습3. 회원테이블(member)에 조회할 열명 대신 별칭을 지어서 조회된 결과창에 보여주기 위해서는 
--       아래의 문법을 사용하자.
--        select 조회할_열명1 as 별칭명1,   조회할_열명2  as 별칭명2
--        from  조회할테이블명;
-- 또는
--        select 조회할_열명1   별칭명1,    조회할_열명2   별칭명2
--        from  조회할테이블명;
select addr as "주소", debut_date as "데뷔일자", mem_name  "그룹명" from member;

-- 실습4. 회원테이블(member)에서 회원그룹이름(mem_name열에 저장되어 있는 데이터들)이 
--       '블랙핑크'가 저장되어 있는 위치의 행이 있는 모든 열의 데이터를 조회
-- 		 요약 : 회원그룹이름이 '블랙핑크' 인 모든 열의 값들 조회!

-- 문법 
--      select 조회할_데이터가_저장된_열명
--      from   조회할_테이블명
--      where  조건에서_사용할_데이터들이_저장된_열명  = 비교할_조건값;
select *
from member
where mem_name = '블랙핑크';

-- 실습5. member테이블에서 회원그룹인원(mem_number열의 데이터)이 4명인 그룹의 모든 열의 데이터 조회
select * 
from member
where mem_number = 4;

-- 실습6.  관계(비교) 연산자 기호  <=     >=    <    >   =
--         member테이블에서 회원 그룹 평균키들 중에서 
--         데이터가 162이상인 회원그룹의 아이디들, 회원그룹명들  조회 
select mem_id,  mem_name  from member  
where  height  >=  162;

-- 실습 7-1.  관계(비교) 연산자 기호  <=     >=    <    >   =
--           논리 연산자 기호   AND    OR

-- member테이블에서 회원그룹 평균키(height열에 저장된 데이터들)가 165이상이면서!
-- 그룹 인원(mem_number열에 저장된 데이터들)이 6명 초과인 회원그룹의 
-- 회원그룹명(mem_name열에 저장된 데이터들), 
-- 그룹평균키(height열에 저장된 데이터들), 
-- 그룹인원(mem_number열에 저장된 데이터들) 조회!!!!
select mem_name, height, mem_number from member
where height >= 165 and  mem_number > 6;

-- member테이블에서 회원그룹 평균키가  165이상 이거나 또는~ 그룹 인원이 6명 초과인 회원그룹의?
-- 회원그룹명, 회원평균키, 회원그룹인원수 조회!!!!
select mem_name, height,  mem_number  from member
where height >= 165 or  mem_number >  6;

-- 실습 7-1-1. BETWEEN  AND절 미사용한 경우 
-- 회원그룹의 평균키가 163이상 이면서 165이하인 회원그룹의 그룹명,평균키,그룹인원수 조회!!
select mem_name, height,  mem_number from member
where height >= 163  and  height <=  165;

/*
BETWEEN AND 절 작성 문법

   select 열명  from  테이블명
   where 비교할_값들이_저장된_열명 between 범위의최솟값 and 범위의최댓값;
*/
-- 실습 7-1-2. BETWEEN  AND절 사용한 경우 
-- 회원그룹의 평균키가 163이상 이면서 165이하인 회원그룹의 그룹명,평균키,그룹인원수 조회!!  
select mem_name, height,  mem_number from member
where height  between  163  and  165;

-- 실습 8. 회원그룹의 평균키가 165이상이거나 또는 그룹인원이 6명 초과인 
--        회원그룹들의 그룹명, 그룹평균키, 그룹인원수 조회!!!!!!!
select mem_name,  height,  mem_number from member
where height >= 165 or mem_number > 6;

-- 실습 8-1. 회원그룹이 사는 지역이 경기 또는 전남 또는 경남 중 한곳이라도 해당되는 그룹의 이름, 주소 조회!!!
--  IN() 절을 사용하지 않고 조회!!!!!!!    
select mem_name, addr  from member
where  addr = '경기' or  addr = '전남' or  addr = '경남';

-- 실습 8-2. 회원그룹이 사는 지역이 경기 또는 전남 또는 경남 중 한곳이라도 해당되는 그룹의 이름, 주소 조회!!!
--  IN() 절을 사용해 조회!!!!!!!    
--  문법
--      where 비교할_데이터가_저장된_열명  IN('비교할값1', '비교할값2', '비교할값3');
select mem_name, addr  from member
where  addr in('경기', '전남', '경남');

/*
	Like
    - 문자열 데이터의 일부 글자가 옆의 데이터로 포함되어 있는 행에 대한 열의 값 조회 하는 예약어.
	  예를 들어 회원그룹명의 첫 글자가 '우' 문자로 시작하는 단어를 포함하는 데이터가 저장된 
      행에 관한 열의 데이터를 조회할수 있습니다.
	- 문법
			where  비교할_데이터가_저장된_열명 LIKE '문자%'; 
*/
-- 실습9. member테이블에서 회원그룹명 중에서 '우' 문자로 시작하는 단어가 포함된 데이터가 있으면 
--       그 행에 관한 모든 열의 데이터들 조회
select * from member
where mem_name like '우%';

-- 실습9-1. LIKE절에 _언더바 기호 사용 가능 
--  member테이블에서 회원그룹명 중에서 앞 두글자는 상관없고 뒷 단어가 '핑크'인 
--  회원그룹의 이름이 저장되어 있으면? 이름이 저장된 행에 관한 모든 열의 데이터를 조회
select * from member
where mem_name like '__핑크';

-- 실습9-2. LIKE절에 %단어%  사용 
--  member 테이블에서 회원그룹명 중에서 '마' 단어가 포함하고 있는 그룹명이 저장되어 있으면?
--  그 그룹의 행에 관한 모든 열의 데이터를 조회 
select * from member
where mem_name like '%마%';

-- 실습9-2-1. LIKE절에 '%단어' 사용 
-- member테이블에서 회원그룹명 중에서 '친구' 단어로 끝나는 그룹명이 저장되어 있으면?
-- 그 해당 그룹의 행에 관한 모든 열의 데이터 조회 !!!
select * from member
where mem_name like '%친구';

/*
	서브 쿼리 구문
		-  안쪽 SELECT구문을 이용하여 조회한 결과 데이터들을 
           바깥쪽 SELECT구문을 이용하여 다시 조회하는 전체 구문을 말함.
           
		- 문법
				SELECT * FROM 테이블명
                WHERE 조건열명 > (SELECT * FROM 테이블명
								WHERE 조건열명 = 조건열의 값들과 비교할 값);
*/
-- 실습 10-1. 서브쿼리를 사용하지 않고 두개의 SELECT문장을 사용한 예

-- 문제. 회원 그룹명이 에이핑크인 회원그룹의 평균키보다~ 큰~ 그룹회원의 그룹이름과 그룹평균키 조회 하고 싶다.

	-- 순서1. 일단 에이핑크 그룹의 평균키 164 조회 해 오자
	select height from member where mem_name = '에이핑크';
	
	-- 순서2. 에이핑크 그룹의 평균키는 순서1.에서 조회 했으므로 164입니다.
	--       where 조건절의 조건값 자리에 164를 대입해서 164보다 큰~ 그룹의 이름과 평균키를 조회하면 된다.
    select mem_name, height from member
    where height  > 164;

-- 실습 10-2. 서브쿼리 사용
-- 문제. 회원 그룹명이 에이핑크인 회원그룹의 평균키보다~ 큰~ 그룹회원의 그룹이름과 그룹평균키 조회 하고 싶다.
    select mem_name, height from member
    where height  >  (select height from member 
                      where mem_name = '에이핑크');
-- --------------------------------------------------------------------------------------
-- 연습문제 
--  1번.  회원테이블에서 모든 회원의 ID와 그룹이름을 조회 해라.
select mem_id, mem_name from member;

--  2번.  회원테이블에서 그룹회원의 평균키가 167이상인 그룹회원의 모든 열의 정보 조회 해라.
select * from member
where height >= 167;

--  3번.   회원테이블에서 그룹인원수가 5명 이하인 그룹의 이름과 인원수 조회 해라.
select mem_name,  mem_number from member
where mem_number <= 5;

--  4번.  구매 테이블(buy)에서 상품가격이 100 이상인 구매한 상품의 이름과 가격을 조회 해라.
select prod_name, price from buy
where price >= 100;

--  5번.  회원 테이블에서 주소가 '경기'인 회원그룹의 모든 열정보를 조회 해라.
select * from member
where  addr = '경기';

--  6번.  구매 테이블(buy)에서 '패션' 분류의 상품 이름과 구매수량을 조회 해라.
select prod_name, amount from buy
where group_name = '패션';

--  7번. 회원 테이블에서 '서울'에 사는 그룹회원 이름과 전화번호(국번,뒷번호 모두 포함)해서 조회해라.
select mem_name, phone1, phone2 from member
where  addr =  '서울';

--  8번. 회원 테이블에서 그룹명이 '트와이스'인  그룹 회원의 모든 열정보 조회 해라 .
select  * from member
where  mem_name = '트와이스';

-- 9번. '블랙핑크'라는 이름을 가진 그룹회원이 구매한 모든 제품의 정보(모든열값)를 조회 하시오.
-- 서브쿼리 사용!
select * from buy
where mem_id = (select mem_id from member
				where mem_name = '블랙핑크');


--  10번. 회원 테이블에서 그룹 인원수가 8명인 그룹의 모든 열정보를 조회 하라.

--  11번. 구매 테이블에서 구매한 상품이름에 '지갑'단어가 포함된 상품의 모든 열정보를 조회 하라 
select * from buy
where prod_name like '%지갑%';

--  12번. 회원 테이블에서 평균키가 165cm 이하인 그룹의 이름과 평균키를 조회 하라
select mem_name, height from member
where height <= 165;

--  13번. 회원 테이블에서 '여자친구' 또는 '트와이스' 그룹이름가진 모든 열정보를 조회 하라
select * from member
where mem_name in('여자친구','트와이스');

--  14번. 구매 테이블에서 구매한 제품 수량이 3이상인 
--        구매한그룹의 그룹아이디, 상품의 이름, 가격을 조회하라 
select mem_id, prod_name,  price from buy
where amount >= 3;

--  15번. 회원 테이블에서 사는지역이 '강남'인 회원의 이름과 주소를 조회 하라 
select mem_name, addr from member
where  addr = '강남';
-- 조회 되지 않음! 이유 : 사는 지역이 강남인 회원그룹 없음


--  16번. 구매 테이블에서 '디지털' 분류(group_name열)의 상품 중 가격(price열)이 200이하인 
--        구매한_상품의_이름(prod_name열)을 조회 하라
select prod_name  from buy
where group_name = '디지털' and  price <= 200; 

--  17번. 회원 테이블에서 그룹 평균키가 162cm이상인 그룹의 이름을 조회하라
select mem_name from member
where height >= 162;

-- 18번. 구매 테이블에서 특정그룹('블랙핑크')의 구매 내역에서 
--       가격이 50이상인 구매한_상품의_모든열 정보 조회하라
-- 서브쿼리~~~~~~~~~

select * from buy
where price >= 50  AND mem_id = (select mem_id from member
								  where mem_name = '블랙핑크');
/*
먼저 member테이블에 저장된 블랙핑크 그룹을 식별할 mem_id 열 값을 조회 ! -> 'BLK'
select mem_id from member
where mem_name = '블랙핑크';  -- >>>>>>>>> mem_id --->  BLK
*/

-- ----------------------------------------------------------------
-- 03-2절 조금 더 깊게 알아보는 SELECT 문
-- ---------------------------------------------------------------
/*
	 ORDER BY 절 
		- 최종 조회 시 특정 열의 값을 기준으로 해서 내림 차순 또는 오름 차순 정렬해서 
          조회 하는 예약어
		- 문법
				SELECT  * FROM 조회할테이블명
                WHERE 조건식
                ORDER BY 정렬할_데이터가_저장된_열명  ASC 또는 DESC;
        - 참고.
				ASC -> Ascending의 약자로 오름차순 정렬을 의미.
                DESC -> Descending의 약자로 내림차순 정렬을 의미.
*/
select * from member;
-- 실습1. 그룹 회원의 데뷔일자(debut_date열에 저장된 날짜들)를 기준으로
--       오름 차순 정렬(데뷔일자가 빠른 날짜순) 하여 조회시 ORDER BY 절을 사용합니다.
select * from member
order by debut_date asc;

-- 실습2. 그룹 회원의 데뷔일자(debut_date열에 저장된 날짜들)를 기준으로
--       내림 차순 정렬(데뷔일자 늦은 날짜순)하여 조회시 ORDER BY 절을 사용합니다.
select * from member
order by debut_date desc; 

-- 실습3. ORDER BY절과 WHERE조건절 함께 사용하기
-- 그룹 평균키(height열에 저장된 데이터들)가 164이상인 그룹회원들의 키가 큰 순서대로(내림차순)정렬해서
-- 그룹명(mem_name열에 저장된 데이터들),
-- 그룹아이디(mem_id열에 저장된 데이터들),
-- 그룹평균키(height열에 저장된 데이터들)
-- 데뷔날짜(debut_date열에 저장된 데이터들) 조회!
select mem_name, mem_id, height, debut_date from member
where  height >= 164
order by height desc;

-- 실습4. ORDER BY절과 WHERE조건절 함께 사용하기2
--       (정렬 조건 하나이상 설정가능)
-- 그룹 평균키(height열에 저장된 데이터들)가  큰(내림차순) 순서대로 조회하되,
--  같은 평균키를 가진 그룹들이 있으면, 데뷔일자가 빠른순서(오름차순)로 최종!! 정렬해서 조회 
select mem_name, mem_id, height, debut_date
from member
where height >= 164
order by height desc, debut_date asc;

-- -----------------------------------------------------------------------------
-- LIMIT 예약어 : 테이블 저장된 전체 행(row,레코드)중에서
--               원하는 행의 갯수를 정해서 조회할때 사용하는 예약어.
/*
	문법	
		SELECT * FROM 조회할_테이블명
        WHERE 조건식
        ORDER BY 정렬_기준_데이터가_저장된_열명  ASC 또는 DESC
        LIMIT 조회할_행의_갯수를_숫자로_작성;
*/
-- 실습5. member테이블에서 전체 행 데이터(레코드)들 중에서 3개의 행만 잘라서 조회 
select * from member
LIMIT 3; --     0, 3  같은 의미로 
		 -- index, 행갯수
         -- 0 index행 번호 위치의 조회될 행부터 시작해서 3개의 행을 잘라서 최종 조회해옴
-- LIMIT  조회할행의 index위치번호, 몇개의행을 조회할건지 행 갯수;

-- 실습6. member테이블에서 회원그룹평균키가 큰 순(desc)으로 정렬해서 조회하되,
--       정렬해서 조회한 결과 데이터들 중에서
--       3 index위치 행의 레코드 부터 2개의 행(레코드)만 잘라서 조회!
select * from member
order by height desc
limit 3, 2;
-- --------------------------------------------------------------------------
-- DISTINCT 예약어  : 조회할 열의 데이터들이 중복되서 같은이름의 데이터로 조회되면?
--                   중복된 데이터를 1개만 남기고 1개로만 조회시키는 예약어.
--                   요약 :  중복된 열의 데이터가 저장되어 있으면 하나로 조회하는 예약어.
/*
	문법 
		 SELECT DISTINCT 조회할열명
         FROM 조회할테이블명
         WHERE 조건식
         ORDER BY 정렬기준데이터의_열명  정렬방식
         LIMIT 숫자;
*/
-- 실습8. 모든 그룹회원의 사는 지역 조회 
select addr, mem_name
from member;

-- 실습8-1. ORDER BY절을 사용해 같은 지역에 사는 주소들을 기준으로 오름차순 정렬해 조회
select addr, mem_name
from member
order by addr ASC;

-- 실습8-2. DISITNCT 사용해서 열에 중복된 데이터를 하나로 통일해서 하나의 데이터만 조회
select distinct addr
from member
order by addr ASC;
-- -------------------------------------------------------------------------------
/*
	GROUP BY 절
    - GROUP BY절은 데이터베이스에서 데이터를 그룹으로 묶어서 조회하는데 사용되는 예약어.
    - 예를 들어, 같은 날짜에 해당하는 데이터들을 하나의 그룹으로 묶어 관리 할수 있다.
    - GROUP BY절은 보통  SUM, COUNT, AVG 같은 집계함수와 함께 작성해서 사용 해야 합니다.
    - 예를 들어, 각 카테고리별로 판매량의 합계를 구할때 사용합니다.
    - 문법
			SELECT 열명1, 집계함수명(열명2)
            FROM  조회할테이블명 
            GROUP BY 그룹으로묶을_같은데이터가_저장된_열명
            HAVING 조건식 
            ORDER BY 정렬기준열명 정렬방식
            LIMIT 숫자;
	
    -- 제공해 주는 집계함수들
	-- SUM() : 열명을 SUM(열명)로 지정하면 열에 저장된 데이터들을 합계를 하여 반환해 줍니다.
    -- AVG() : 열명을 AVG(열명)로 지정하면 열에 저장된 데이터들을 평균을 구하여 반환해 줍니다.
    -- MIN() : 열명을 MIN(열명)로 지정하면 열에 저장된 데이터들 중에서 최소 작은데이터를 반환해 줍니다.
	-- MAX() : 열명을 MAX(열명)로 지정하면 열에 저장된 데이터들 중에서 가장 큰 최대 데이터를 반환해 줍니다.
    -- COUNT(*) :  모든 열에 관한 행 갯수 반환 해 줍니다.
    -- COUNT(DISTINCT) : 햇의 갯수를 셉니다.(중복된 데이터 1개만 인정)
*/

select * from buy;
-- 실습9.
-- 'buy' 테이블에서 각 mem_id(구매한 그룹회원 아이디)별로 총 구매 수량을 계산해서 
--  계산한 총구매 수량과 각회원 그룹아이디 같이 조회

-- 순서1. 각 회원 그룹단위로 한번 상품 구매시 구매한 수량 조회 
select mem_id as '그룹아이디', amount as '한번 구매시 구매한 수량'
from buy;
-- 순서2. 각 회원 그룹 아이디 단위로 묶어서 한번만 조회된 그룹아이디로 표시 하되
--       (group by 그룹으로묶을_같은데이터가_저장된_열명) 을 이용해서 
--       그룹아이디 단위로 조회되게 묶어서 조회 시키자
/* 
select mem_id as '그룹아이디'
from buy;

로  조회 하면 아래와 같이 조회 결과 가 나온다.  
그런데 그룹 아이디가 중복 조회되어 나온다.
이유는 각 회원 그룹들은 상품 구매를 한번만 한것이 아니기 때문에 
여러 행의 정보중 그룹아이디 만 각각 조회되서 나온것이기때문에
만약  회원그룹 아이디 단위로  구매한 상품 가격들을 합쳐서  
구매한 총상품 구매 수량 구해서  회원 그룹 아이디별로 ~ 총구매 수량만 조회돼서 나오게 해야 한다면? 
group by mem_id; 를 끝에 작성해  
mem_id열에 세로 방향으로 저장된 아이디들을 하나의 회원그룹아이디 단위로 묶어서 하나만 조회되게 시켜야 
각 행의 각각 구매한 상품 수량을 합계한 총상품 구매수량 또한 같이 조회되서 나오게 할수 있을 것이다.
   
그룹아이디
APN
APN
APN
APN
BLK
BLK
BLK
GRL
MMU
MMU
MMU
MMU
*/
-- 순서3. group by mem_id; 를 끝에 작성해
--       mem_id열에 세로 방향으로 저장된 아이디를 하나의 그룹으로 묶어서 하나만 조회되게 시켜보자
select mem_id as '그룹아이디'
from buy
group by mem_id;   --   <------- 이 한줄을 추가 하니 아래의 조회 결과가 달라졌다.

-- 순서4. 'buy'테이블에서 각 mem_id(그룹 회원아이디)별로 총 구매 수량을 계산해서
--        계산한 총 구매 수량과 같이 조회하기 위해 추가! 
--        이때 SUM이라는 집계함수를 작성하여 amount열에 조회되는 모든 행 위치의 열값들을 추출해
--        +  모두 합계 한 회원 그룹 아이디 별 총 구매 수량을 조회하면 같이 보여줄수 있음
select mem_id as '그룹아이디', SUM(amount) as '총_구매수량'
from buy
group by mem_id; 

-- 실습11. 전체 회원그룹이 구매한 총 구매 수량의 평균을 구해서 조회된 결과를 보여주자.
select AVG(amount) as '전체 회원 그룹들이 구매한 상품 수량의 평균' from buy;

-- 실습12. 각~ 회원그룹들이 한번 구매시 몇개의 상품을 각각 구매했는지 평균 구매 갯수 조회
-- 참고. 각~ 회원그룹들을 식별할 유일한 고유값은 mem_id열에 저장된 그룹id를 그룹으로 묶어 주자
select mem_id as '회원그룹아이디',  AVG(amount) as '평균 구매 갯수'
from buy
group by mem_id;

-- 실습13. member테이블에 저장된 그룹회원의 전체 행(레코드, row)의 갯수 조회
select count(*) as '전체 행 갯수' from member;

-- 실습13-1. member테이블에서 연락처(phone1, phone2열에 저장된 데이터들)가 
--          저장되어 있는 그룹의 그룹회원의 레코드(행) 갯수만 조회!
 select count(phone1) '연락처가 저장되어 있는 그룹 행의 수' from member;
 
-- ------------------------------------------------------------------------------
-- HAVING 조건절 
--   		WHERE 조건절 대신 그룹으로 묶어준 데이터의 조건검사하는 구문 

-- 문법
--      SELECT 열명1, 집계함수(열명2) FROM 테이블명
--      GROUP BY 그룹으로묶을_같은데이터가_저장된_열명 
--      HAVING 조건식 
--      ORDER BY 정렬기준데이터가저장된_열명  정렬방식;

-- 실습14. buy테이블에서 조회합니다.
--        회원 그룹 아이디를 그룹으로 묶어서 
--        회원 그룹 아이디 별로 각각 총 구매금액과 그룹아이디열의 데이터 조회 
select mem_id as '회원 그룹아이디', SUM(price * amount) as '총 구매 금액'
from buy
group by mem_id;


-- 실습 14-1. 
-- 위 실습14.는 그룹아이디별로 총구매한 금액을 조회해서 보여줍니다
-- 만약 그룹아이디별로 총구매한 금액이 1000이상이면 사은품을 증정하려고한다면
-- 그룹 아이디별로 총구매한 금액이 1000이상인 그룹의 총구매금액, 그룹아이디를 조회합니다 
select mem_id as '회원 그룹 아이디', SUM(price * amount) as '총 구매 금액' 
from buy
group by mem_id
having  SUM(price * amount)   >=  1000;

-- 실습 14-2. 
-- 위 실습14는 그룹아이디별로 총구매한금액을 조회해서 보여줍니다. 
-- 만약 그룹아이디별로 총구매한 금액이 1000이상이면 사은품을 증정하려고 한다면
-- 그룹아이디별로 총구매한 금액이 1000이상인 그룹을 조회 해야 합니다.
-- 또한 총구매한 금액에 따라 사은품이 다를수 있기떄문에 
-- 총 구매 금액이 큰 순서대로(내림차순정렬) 하여 최종 조회해서 보여줌 
select mem_id as '회원 그룹 아이디', SUM(price * amount) as '총 구매 금액' 
from buy
group by mem_id
having  SUM(price * amount)   >=  1000
order by SUM(price * amount) desc;
-- ---------------------------------------------------------------------------------
-- 연습 **********************************************************************************
-- 1.  회원그룹수 (count)
--     회원그룹 테이블의 총 그룹회원(행,레코드) 수를 계산해서 조회    
SELECT COUNT(*) AS total_members FROM member;

-- 2. 평균 인원수(avg)
--    회원 그룹테이블의 그룹 평균 인원수 계산해서 조회
SELECT AVG(mem_number) AS arverage_members FROM member;

-- 3. 최대 평균키(max)
--    회원그룹 테이블에서 가장 키가 큰 그룹회원의 평균키 조회
SELECT MAX(height) AS tallest_member FROM member;

-- 4. 최소 평균키(min)
--    회원그룹 테이블에서 가장 키가 작은 회원그룹의 평균키 조회
SELECT MIN(height) AS shortest_member FROM member;

-- 5. 구매 수량의 총합(sum)
--    구매 테이블에서 모든 구매 수량의 총합 조회 
SELECT SUM(amount) AS total_amount FROM buy;

-- 6. 각 회원별 구매 수량의 총합
-- 각 회원별로 구매한 총 수량을 계산합니다. mem_id로 그룹화하여 각 회원의 총 구매 수량 조회 
SELECT mem_id, SUM(amount) AS total_amount
FROM buy
GROUP BY mem_id;

-- 7. 각 제품의 평균 가격(avg)
-- 구매한 각 제품별 단가(가격)의 평균을 계산해서 계산한 평균값 조회되게 하기.
-- 참고. 제품 이름으로 그룹화하여 평균 가격을 구합니다.
-- 		구매한 각 제품의 단가(가격)의 평균을 구하는 것입니다. 
--  	즉, 특정 제품이 여러 번 구매되었을 때, 
--  	그 제품의 가격을 모두 더한 후 구매 횟수로 나누어 평균 가격을 계산합니다.
SELECT prod_name,  AVG(price) AS average_price
FROM buy
GROUP BY prod_name;


-- 8. 특정 지역의 그룹 회원 수(count)
-- 각 사는 지역별 그룹명, 그룹회원 수 조회.         
 -- 참고. 지역 주소로 그룹화하여 각 지역의 회원그룹 수를 구합니다.
 SELECT addr,  mem_name, COUNT(*) AS total_members
 FROM member
 GROUP BY addr;
 
-- 9. 구매한 제품의 종류 수(count distinct)
-- 구매 테이블에서 구매한 제품의 종류 수를 계산합니다.
-- 구매 제품 이름에 중복을 제거하여 고유한 제품 수를 구합니다.
/*
전체적인 흐름  참고.
1.구매 데이터 조회: buy 테이블에서 모든 구매 정보를 가져옵니다.
2.중복 제거: prod_name 열에서 중복된 제품 이름을 제거하여 고유한 제품 이름만 남깁니다.
3. 고유 제품 수 계산: 남은 고유한 제품 이름의 수를 세어 unique_products라는 이름으로 결과를 반환합니다.
*/
select COUNT(distinct prod_name) AS unique_products  from buy;
/*
핵심 
					WHERE  : 그룹으로 묶기 전에 행을 먼저 걸러낸다.
					GROUP BY : 같은 값끼리 묶는다.
					HAVING : GROUP BY로 묶은 조회 결과에 조건을 건다.
	예를 들어 
			-- 일반 열 데이터 조건은 where 사용 
				where mem_number >= 5;
                
            -- SUM(), AVG(), COUNT() 같은 집계 함수 조회결과 조건이므로 HAVING 사용     
                HAVING SUM(amount) >= 2;
*/

-- 10. 구매 테이블에서 상품 분류별 총 구매 수량을 조회 하시오.
--    예 : 디지털 분류 전체 구매 수량,  패션 분류 전체 구매 수량 
/*
    풀이 설명
    1. buy 테이블에서 데이터를 조회한다.
    2. 상품 분류는 group_name 컬럼(열)에 들어 있다.
    3. 같은 상품 분류끼리 묶기 위해 GROUP BY group_name을 사용한다.
    4. 각 상품 분류별 구매 수량의 합계를 구하기 위해 SUM(amount)를 사용한다.
*/
SELECT 
	group_name,                  -- 상품 분류 
    SUM(amount) AS total_amount  -- 분류별 총 구매 수량 
FROM buy
GROUP BY group_name;


-- 11. 구매 테이블에서 상품 분류별 평균가격을 조회 하시오.
--     단, 상품 분류가 NULL인 데이터는 제외하시오.
/*
    풀이 설명
    1. 상품 분류는 group_name 컬럼이다.
    2. group_name이 NULL인 경우는 분류가 없는 데이터이므로 제외한다.
    3. WHERE group_name IS NOT NULL 조건으로 NULL을 제외한다.
    4. GROUP BY group_name으로 상품 분류별로 묶는다.
    5. AVG(price)로 각 분류별 평균 가격을 구한다.
*/
SELECT 
	 group_name,  			   -- 상품 분류 
     AVG(price) AS avg_price   -- 분류별 상품 가격
FROM buy
WHERE group_name IS NOT NULL
GROUP BY group_name;


-- 12. 구매 테이블에서 회원별 구매 건수를 조회 하시오.
--     구매 건수란 buy테이블에 저장된 구매 기록의 갯수를 의미 한다. 
/*
    풀이 설명
    1. 회원 아이디는 mem_id 컬럼(열)이다.
    2. 같은 회원끼리 묶기 위해 GROUP BY mem_id를 사용한다.
    3. COUNT(*)는 각 회원별 구매 기록 개수를 센다.
    4. SUM(amount)는 총 구매 수량이고, COUNT(*)는 구매한 기록의 개수이다.
       둘은 서로 다르다.
*/
SELECT
	mem_id,                 -- 회원그룹 아이디
    COUNT(*) AS order_count -- 회원별 구매 기록 수 
FROM buy
GROUP BY mem_id;


-- 13. 구매 테이블에서 회원별 총 구매 금액을 조회 하시오.
--     총 구매 금액은 가격(price) * 수량(amount)으로 계산하시오.
SELECT
	mem_id,        						-- 회원 그룹 아이디별 
    SUM(price * amount) as total_price  -- 회원 그룹 아이디별 총 구매 금액 
FROM buy
GROUP BY mem_id;


-- 14. 구매 테이블에서 상품별 총 판매 금액을 조회 하시오.
--     총 판매 금액은 가격(price) * 수량(amount)으로 계산하시오.
SELECT
	 prod_name,      					  -- 상품 이름 
     SUM(price * amount)  as total_price  -- 상품 이름 별 총 판매 금액
FROM buy
GROUP BY prod_name;

-- ----------------------------------------------------------------------------------

-- -----------------------------------------
-- 03-3절. 데이터 변경을 위한 SQL문
-- -----------------------------------------
/*
	주제 : 데이터베이스 내부에 만든 특정 테이블에 데이터를 추가(입력)/ 수정 / 삭제 하는 SQL문을 배우자 
    
		INSERT 문 : 테이블에 새로운 행 데이터를 추가(입력)해서 저장할 때 사용되는 SQL문 종류 중 하나 
        
        INSERT 문 작성 기본 문법
			
			   insert into 테이블명(추가할값이저장될_열명1,           열명2,           열명3)
						   values(   열명1에 추가할_값1, 열명2에 추가할값2, 열명3에 추가할값3);
                           
			   insert into 테이블명(열명1, 열명2, 열명3) 
						   values(값1,   값2,  값3);
*/
-- market_db 데이터베이스 사용하기 위해 선택
USE market_db;
/*
	테이블 생성 문법
    
		create table 생성할테이블명(
        
			생성할열명1   열1에저장할데이터유형,
            생성할열명2   열2에저장할데이터유형,
            .......
        );

*/
-- hongong1 이라는 이름의 테이블 생성
create table hongong1(	
	toy_id       INT,  -- 장난감 아이디 
	toy_name CHAR(4),  -- 장난감 이름 
    age          INT   -- 장난감 나이 
);
-- hongong1 테이블에 저장된 모든 열의 데이터 조회 
select * from hongong1;

-- hongong1 테이블에 하나의 행(row,레코드) 을 추가하여 저장 
insert into hongong1(toy_id, toy_name, age)
			  values(     1,    '우디',  25);

-- hongong1 테이블에 toy_id열과 toy_name열에만 데이터를 추가하여 저장할 값 넣어보자
insert into hongong1(toy_id, toy_name) values(2,  '버즈');

-- hongong1 테이블에 열명의 순서를 바꿔서 추가로 행을 저장
-- 주의 할점은 테이블명()사이에 작성한 열명의 순서에 맞게 values()사이에 저장할값 넣어서 추가해야 합니다. 
insert into hongong1(toy_name, age, toy_id) 
              values(   '제시',  20,      3);

-- hongong1 테이블에 (열명1, 열명2, 열명3) 을 생략하고 
-- values(열_추가값1, 열_추가값2, 열_추가값3) 구문만 작성해 새로운 행 데이터를 추가 할수 있다. 
-- 단! 주의 할점 은 테이블 생성시 작성한 열명 순서에 맞게 추가할값 들을 작성 해야 합니다. 
--                         toy_id, toy_name,  age
insert into hongong1 values(4    ,    '영구',  30);

select * from hongong1;

/*
  AUTO_INCREMENT 예약어
	- 테이블을 새로 생성할때 열이름  뒤에 설정하는 예약어로 
      열 에 대한 값을 INSERT문장으로 추가하지 않아도 
      자동으로 1씩 증가되면서 추가가 되게 하는 예약어.
*/
-- hongong2 테이블 새로 생성 
create table hongong2(
	toy_id    int     auto_increment primary key,
    toy_name  char(4),
	age       int
);
-- hongong2 테이블에 자동으로 toy_id열에 대한값을 1증가해서 들어가는 데이터를 null값으로 채워 놓고 데이터 추가 
insert into hongong2(toy_id, toy_name, age) values(null, '보핍', 25);

-- hogong2 테이블에 자동으로 toy_id열에 대한값을 1증가해서 들어가는 데이터를 null값으로 채워 놓고 데이터 추가
insert into hongong2(toy_id, toy_name, age)
			  values(null,     '슬링키',  22);

insert into hongong2(toy_id, toy_name, age)
		      values(null,    '렉스',   21 );


/*
	toy_id 열에 추가할 값을 작성하지 않고,  다른 열의 값만 추가 시키면 
    auto_increment 제약조건 예약어를 설정 해 놓은 toy_id 열의 값은 자동으로 1증가하면서 값이 추가된다.
*/
insert into hongong2(toy_name, age)
			  values('맹구',    100);

/*
  hongong2테이블의 toy_id열에는 auto_increment 제약조건 예약어를 설정 해 놓았기떄문에 
  자동 증가값이 4까지 설정되어 있다는 것을 확인 할수 있지만
  자동으로 증가된 값이 얼마만큼 되었는지 확인하는 조회 구문 
*/
select last_insert_id() as 'toy_id열에 추가된 최근 값';

/*
	auto_increment 제약조건을 지정한 열은 1부터 insert(추가)가 되기떄문에
    특정 값 부터 insert(추가)되게 하기 위해  auto_increment 제약조건의 속성의 값을 설정 해야 한다.
*/
alter table hongong2 auto_increment = 100;
					-- 초깃값은 100으로 설정
					-- 초기 100부터 1씩 증가 되어 추가되도록 설정 
                    
insert into hongong2(toy_name, age) values('재남', 35);
/*
   auto_increment 제약조건을 지정한 열은  100부터 1씩 증가되면서 insert가 됩니다.
   하지만 3씩 증가 즉! 103, 106, 109 형태로 증가 시킬수 있게 
   @@auto_increment_increment 변수의 값을 변경 시키면 된다.
*/
-- hongong3 테이블 새로 만들기 
create table hongong3(
	toy_id     int     auto_increment primary key,  -- 장난감 아이디 저장할 toy_id열을 만들고  숫자아이디로 저장 
    toy_name   char(4), -- 장난감 이름을 저장할 toy_name열을 만들고 최대 4글자 까지 저장
    age        int     -- 장난감 나이를 저장할 age열을 만들고 숫자로 나이를 저장 
);
-- auto_increment 의 자동 증가 시작되는 값을 1000으로 설정
alter table hongong3 auto_increment = 1000;

-- auto_increment는  1000부터 열의 데이터가 추가되어 1씩 증가 되어 추가되지만
-- 만약 3씩 증가 하여 추가를 시키려면? 다음과 같이 시스템변수의 값을 설정 하면 됨
set @@auto_increment_increment = 3; -- 자동으로 증가되는 값을 3으로 설정 

insert into hongong3 values(null, '토마스', 20);
insert into hongong3 values(null, '제임스', 23);
insert into hongong3 values(null, '고든',  25);

insert into hongong3(toy_name, age) values('개똥이', 100);
insert into hongong3(toy_name, age) values('똘똘이', 5);

/*
	insert into  ~ select 전체 구문 
    - 특정 테이블 select구문을 이용해 조회한  표 형태의 결과 데이터들을
      insert into 문장을 이용해 테이블에 행의 데이터들을 한번에 추가시키는 구문 
	- 문법
			insert into 테이블명(열명1, 열명2, 열명3)
            select 열명1, 열명2, 열명3 from 테이블명;
*/
-- world 데이터베이스 사용을 위한 선택
use world;

-- world 데이터베이스 내부에 만들어져 있는 테이블 목록 조회
show tables;

-- world 데이터베이스 내부에 만들어져 있는 city테이블 레코드(행)의 총 갯수 조회
select count(*) as '총 햇 갯수' from city;  -- 4079 행 데이터들 

-- city 테이블에 저장된 전체 레코드(행) 조회 
select * from city;

-- city 테이블에 어떤 열이 어떤구조로 설정되어 만들어져 있는지 열의 구성을 확인 하는 구문
-- 문법  desc 테이블명;
desc city;

-- city 테이블에 저장된 전체 4079행 데이터 중에서 
-- 5개의 행데이터만 조회 
select * from city
limit 0, 5;
/*
  테이블 생성 문법
		create  table  생성할_테이블명(
			생성할_열명1   열명1에_저장할_데이터유형,
            생성할_열명2   열명2에_저장할_데이터유형,
            생성할_열명3   열명3에_저장할_데이터유형
        );
*/
-- city테이블에 저장된 도시명과 인구수를 조회해서 저장할 city_pouple 테이블 생성하기 
create table city_popul(
	city_name  char(35),  -- 도시명 
    population int        -- 각 도시에 사는 인구수 	
);
/*
	insert into  ~ select 전체 구문 
    - 특정 테이블 select구문을 이용해 조회한  표 형태의 결과 데이터들을
      insert into 문장을 이용해 테이블에 행의 데이터들을 한번에 추가시키는 구문 
	- 문법
			insert into 테이블명(열명1, 열명2, 열명3)
            select 열명1, 열명2, 열명3 from 테이블명;
*/
insert into city_popul(city_name, population)
select name, population from city;

commit;

-- city_popul테이블에 city테이블에서 조회한 4079행의 정보가 제대로 
-- city_name열과 population열에 추가되어 저장되는지 나중에 확인
select *         from city_popul;

select count(*)  from city_popul;
/*
insert 문 보충    
    1. 단일 행 삽입 
		-  단일 행 삽입은 한 번에 하나의 행을 테이블에 추가하는 방법.
        - 예시.  INSERT INTO 테이블명(열1, 열2, 열3) VALUES(값1, 값2, 값3);
    
    2. 다중 행 삽입 
		-  다중 행 삽입은 한번에 여러개의 행을 테이블에 추가하는 방법.
        - 예시. INSERT INTO 테이블명(열1, 열2, 열3) VALUES(값1, 값2, 값3),(값4, 값5, 값6),(값7,값8,값9);
    
    3. SELECT문을 활용한 삽입
		- SELECT문을 사용하여 다른 테이블의 데이터를 기반으로 데이터를 삽입하는 방법
        - INSERT INTO 문과 SELECT문을 함께 사용하여 SELECT문의 결과를 기반으로 테이블에 삽입합니다.
        - 예시. INSERT INTO 테이블명(열1, 열2, 열3)
               SELECT 열1, 열2, 열3 FROM 다른테이블명 WHERE 조건;
        
    4. ON DUPLICATE KEY UPDATE 사용 
        - MySQL 8버전에서 도입된 기능으로, 데이터 삽입시 중복된 키가 발생할 경우 업데이트 작업을 수행하는 방법
        - INSERT INTO문 뒤에 ON DUPLICATE KEY UPDATE 절을 추가고, 업데이트할 열과 값을 지정합니다.
        - 예시.  INSERT INTO 테이블명(열1, 열2, 열3) VALUES(값1, 값2, 값3)
                ON DUPLICATE KEY UPDATE 열1=값1, 열2=값2;

*/
-- 1. 테이블 생성
create table users( 
	id     int  auto_increment   primary key,  -- 고유한 ID
    name   varchar(50),                        -- 사용자 이름 
	age    int                                 -- 사용자 나이 
);

-- 2. 단일 행 삽입 예제
--   users 테이블에 한 명의 행 데이터 삽입
insert into users(name, age) values('Alice', 25);

-- 3. 다중 행 삽입 예제 
--  users테이블에 여러 명의 행 데이터를 동시에 삽입합니다.
INSERT INTO users(  name,    age) 
			VALUES('Bob',     30),
				  ('Charlie', 35),
                  ('Diana',   28);

-- 4. SELECT를 사용한 데이터 삽입
--    다른 테이블에서 데이터를 조회해서  users테이블에 삽입하는 예제
--    예를 들어 new_users테이블이 있다고 가정하자.
create table new_users(
	name  varchar(50),    -- 사용자 이름 
	age   int             -- 사용자 나이 
);
-- 일단 new_users 테이블에 데이터가 하나도 없으므로 다중 행 추가 해 놓자.
insert into new_users(name, age) values('Eve', 26), ('Frank', 29);

-- new_users 테이블에서 select구문을 이용해서 조회한 name열의 값과 age열에 대한 값을
-- users 테이블에 insert구문을 이용해서 삽입.
insert into users(name, age)
select name, age from new_users
where age > 25;

-- 5. ON DUPLCATE KEY UPDATE 예제. <--- MySQL8 이상부터 적용되는 문법
--    id열에 저장된 값이 중복되는 경우는 같은 1을 넣으면  insert되지 않는다.
--    그럴 경우 name열과 age열의 값만 변경하고 싶을때 ON DUPLCATE KEY UPDATE 구문을 사용하면 된다.
insert into users(id, name, age) values(1, 'Alice', 27)
on duplicate key update name = 'Alice Updated', age = 27;

select * from users;
/*
테이블 조회 해서 가져온다.  select 구문
테이블 새 행 데이터 추가.   insert 구문
테이블 열에 저장된 값만 수정. update 구문 <-------------이거 할차례 
테이블에 행 데이터 삭제.     delete 구문 
*/
/*
  UPDATE 구문?
  -  테이블에 이미 저장되어 있는 열의 데이터를 수정(변경)하는 SQL문 중 하나 
  -  문법
			UPDATE 수정할_데이터가_저장된_테이블명
            SET   수정할_데이터가_저장된_열명1 = 수정할값1,  열명2 = 수정할값2, .........
            WHERE 조건식;
            
            UPDATE 테이블명 
            SET 열명 = 수정될_값
            WHERE 조건식;
*/
-- city_popul 테이블에 저장된 도시이름이 'Seoul'인 모든 열의 데이터 조회
select * from city_popul
where city_name = 'Seoul';

-- city_popul테이블의 도시 이름중에서 
-- 영문 'Seoul' 데이터를  한글 '서울' 로 수정 하자 
update city_popul 
set city_name = '서울'
where city_name = 'Seoul';

-- city_popul 테이블에 저장된 도시이름이 '서울' 인 모든 열의 데이터 조회 
select * from city_popul
where city_name = '서울';

-- city_popul 테이블의 city_name열에 저장된 데이터가 'New York'을 '뉴욕'으로 수정하고 동시에~~~
--                   population열에 저장된 인구수를 0으로 수정
-- 조건 -> city_name열에 저장된 데이터가 'New York'인 열의 값이면  위 2가지 정보를 수정해야 합니다.

-- 순서1. 수정할 데이터 조회 해 볼것 같다
select city_name, population
from city_popul
where city_name = 'New York';

-- 순서2. city_popul테이블의 city_name열에 저장된 데이터가
--       영문 'New York'을 한글 '뉴욕'으로 수정하는 동시에
--       population열에 저장된 인구수를 0으로 수정 하자 
update city_popul 
set city_name = '뉴욕',  population = 0
where city_name = 'New York';

-- 순서3. 수정된 열의 데이터 확인을 위해 조회
select city_name, population
from city_popul
where city_name = '뉴욕';
--  ******************************** 이영역은 눈으로 만 보고  이해하자 ***************
/*
 city_popul테이블에 city_name열에 저장된 도시이름들을 모두~ '서울'로 수정
 아래 구문은 눈으로만 보고 실행하지 말자~~~
 WHERE절이 없는 UPDATE문은 전체 행의 열데이터를 모두 수정하기 떄문에 주의하자.

UPDATE city_popul
SET city_name = '서울';
*/
select * from city_popul;

-- city_popul테이블에 저장된 모든 행의  열 인구수를 10000으로 나눈 계산된 값들을
-- population열의 값들로 수정
update city_popul
set population = population / 10000;

-- 영구반영(commit)인한 update구문 취소(되돌리기)하는 구문 
rollback;

--  population열의 값들 수정되기 전상태 조회 
select * from city_popul;

-- ---------------------------------------------------------------
/*
  DELETE 문
	- 테이블에 저장된 행 단위로 데이터를 삭제하는 SQL문 중 하나 
    - 문법
			DELETE FROM 삭제할_행이_저장된_테이블명
            WHERE 조건식;
*/
-- 도시 이름(city_name열의 데이터들)이 New라는 단어로 시작하는 도시이름이 존재하는 행을 삭제

-- 순서1. 먼저 도시이름이 New라는 단어로 시작하는 도시이름이 저장되어 있는지 SELECT 조회해 보자
select * from city_popul
where city_name like 'New%';

-- 순서2. city_name테이블에 city_name열에 저장된 데이터들 중에서 
--       'New'단어로 시작하는 도시이름의 행 11개를 삭제
delete from city_popul
where city_name like 'New%';

-- 순서3.city_popul테이블에 저장된 총 행의 갯수는 4079개 중에서 
--     4068행의 갯수로 조회 되게 전체 행의 갯수 조회
select count(*) from city_popul;
-- ------------------------------------------------------------------
/*
	대용량의 데이터가 저장된 테이블을 삭제 하기 위해 먼저 실습 준비
    
    대용량 데이터를 저장하기 위해 일단 테이블 3개 준비
    방법 : 대용량의 데이터들이 저장된 테이블을 SELECT구문으로 조회해 와서
          CREATE구문을 이용하여 총 3개의 테이블을 생성 
*/
--      외부데이터베이스명.외부데이터베이스에_생성할_테이블명();
create table market_db.big_table1(
	select * from world.city, sakila.country
);
-- market_db 외부 데이터베이스 안에 새로 생성된 big_table1테이블 행의 갯수 조회
select count(*) from market_db.big_table1; -- 444611 행데이터 저장되어 있음  

desc market_db.big_table1;

--      외부데이터베이스명.외부데이터베이스에_생성할_테이블명();
create table market_db.big_table2(
	select * from world.city, sakila.country
);

--      외부데이터베이스명.외부데이터베이스에_생성할_테이블명();
create table market_db.big_table3(
	select * from world.city, sakila.country
);

-- DELETE :  테이블에 저장된 행 단위 데이터 삭제하는 SQL문 
delete from market_db.big_table1; -- 2.485초 

-- DROP : 테이블 자체를 삭제하는 SQL문
-- 문법
--     DROP TABLE 삭제할테이블명;
drop table market_db.big_table2;  -- 0.015초 

-- TRUNCATE : 테이블에 저장된 행 단위 데이터 삭제하는 SQL문
--            단, where 조건식; 과 같이 작성할수 없습니다.
--            조건식 없이 전체 행을 삭제 해야 할때만 truncate 문 사용!!!!!
-- 문법  truncate table 삭제할테이블명;
truncate table market_db.big_table3; -- 0.032초 

-- 모든 행이 삭제 되었는지 확인을 위해 조회 
select * from market_db.big_table3;

-- ------------------------------------------------------------
-- 04-1절 MySQL의 데이터 형식
-- ------------------------------------------------------------
-- 주제 :  데이터 형식(유형)

use market_db; -- 사용할 데이터베이스 선택

create table hongong4(
	tinyint_col  tinyint,  -- 정수 127 까지 열에 저장할수 있다.
	smallint_col smallint, -- 정수 32767 까지 열에 저장할수 있다.
    int_col		 int,      -- 정수 2147483647 까지 열에 저장할 수 있다.
    bigint_col   bigint    -- 정수 약 900 경 까지 열에 저장할 수 있다.
);

-- insert 구문을 이용하여 hongong4테이블에 새로운 행(데이터) 추가 
insert into hongong4(tinyint_col, smallint_col, int_col,   bigint_col)
			  values(       127,        32767,  2147483647, 90000000000000000);
-- 조회 확인 
select * from hongong4;

-- 각 숫자에 1을 더해서 추가 해 봅시다.
insert into hongong4(tinyint_col, smallint_col, int_col,   bigint_col)
			  values(       128,        32768,  2147483648, 900000000000000000);
 
-- netflix_db 데이터베이스 생성 
-- 데이터베이스 생성 문법
--        CREATE DATABASE 생성할데이터베이스명;
CREATE DATABASE netflix_db;

-- netflix_db 데이터베이스 선택
USE netflix_db;

-- netflix_db 데이터베이스 내부에 영화정보 저장하기 위한 movie테이블 생성
CREATE TABLE movie(
	movie_id       int,         -- 영화 구분 아이디를 정수로 저장
    movie_title    varchar(30), -- 영화 제목을 문자형태로 저장 
    movie_director varchar(20), -- 감독명 문자형태로 저장
    movie_str      varchar(20), -- 별점수 문자형태로 저장
    movie_srciper  longtext,    -- 영화자막 텍스트파일의 내용 저장 최대 4GB
    movie_film     longblob     -- 영화 동영상 파일 최대 4GB
);
-- 1. 영화 '기생충' 데이터 삽입 
insert into movie(movie_id, movie_title, movie_director, movie_str, movie_srciper, movie_film)
values(
	1, 
    '기생충',
    '봉준호',
    '★★★★★',
    '제시카 외동딸 일리노이 시카고, 과 선배는 김진모 그는 네사촌...',
    'binary_movie_data_1'
);
-- 2. 영화 '부산행' 데이터 삽입 
insert into movie(movie_id, movie_title, movie_director, movie_str, movie_srciper, movie_film)
values(
	2, 
    '부산행',
    '연상호',
    '★★★★☆',
    '아빠, 가지마....(좀비 울음소리) 으아아악!',
    'binary_movie_data_2'
);

-- 3. 영화 '올드보이' 데이터 삽입 
insert into movie(movie_id, movie_title, movie_director, movie_str, movie_srciper, movie_film)
values(
	3, 
    '올드보이',
    '박찬욱',
    '★★★★★',
    '웃어라, 온 세상이 너와 함께 웃을 것이다. 울어라, 너 혼만 울 것이다.',
    'binary_movie_data_3'
);

-- 4. 영화 '오징어 게임' 데이터 삽입 
insert into movie(movie_id, movie_title, movie_director, movie_str, movie_srciper, movie_film)
values(
	4, 
    '오징어 게임',
    '황동혁',
    '★★★★★',
	LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/squid_game_sub.txt'), -- 실제 자막 파일 경로 작성해서 자막 내용 불러와 추가 
    LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/squid_game.mp4')      -- 실제 동영상 파일 경로 작성해서 영상 내용 불러와 추가 
);
-- (참고: LOAD_FILE()을 사용하려면 DB 서버의 secure_file_priv 설정이 허용된 경로에 파일이 위치해 있어야 합니다.)
/*

MySQL 8에서 제공하는 날짜형 데이터 타입은 총 5가지로,
각각의 용도와 저장 형식이 다릅니다. 
아래는 MySQL 8에서 사용할 수 있는 날짜 및 시간 관련 데이터 타입입니다:

1. DATE
   - 형식: `YYYY-MM-DD`
   - 설명: 날짜만 저장할 수 있으며, 시간 정보는 포함되지 않습니다. 
          예를 들어, `2024-10-02`와 같은 값을 저장할 수 있습니다.

2. TIME
   - 형식: `HH:MM:SS`
   - 설명: 시간만 저장할 수 있으며, 날짜 정보는 포함되지 않습니다. 
          예를 들어, `12:30:45`와 같은 값을 저장할 수 있습니다.

3. DATETIME
   - 형식: `YYYY-MM-DD HH:MM:SS`
   - 설명: 날짜와 시간을 함께 저장할 수 있습니다. 
          예를 들어, `2024-10-02 12:30:45`와 같은 값을 저장할 수 있습니다.

4. TIMESTAMP
   - 형식: `YYYY-MM-DD HH:MM:SS`
   - 설명: `DATETIME`과 비슷하지만, 
           `TIMESTAMP`는 UTC 기준으로 저장된 후, 
            조회할 때 서버의 타임존에 맞게 변환됩니다. 
            서버의 시간대에 의존하는 데이터를 처리할 때 유용합니다.

5. YEAR
   - 형식: `YYYY`
   - 설명: 연도만 저장할 수 있습니다. 
          예를 들어, `2024`와 같은 값을 저장할 수 있습니다.


------------------------------------------------------------------------------------------------------------------------
참고.

    TIMESTAMP 데이터 타입을 쉽게 설명하자면, MySQL에서 시간을 저장할 때 
    'UTC(세계 표준시)'라는 기준 시간을 사용해 저장하고, 
    나중에 데이터를 조회할 때는 서버가 위치한 곳의 시간대에 맞게 변환해주는 타입입니다.

    UTC(세계 표준시): 전 세계가 동일하게 사용하는 기준 시간이 있습니다. 
                      예를 들어, 한국은 이 UTC 시간보다 9시간 빠릅니다. 
                      그래서 만약 UTC 기준으로 2024-10-02 12:00:00가 있으면, 
                      한국 시간으로는 2024-10-02 21:00:00이 됩니다.

    TIMESTAMP 작동 방식:
        저장할 때: 데이터베이스는 시간을 UTC 기준으로 저장합니다. 
                   예를 들어, 한국에서 2024-10-02 21:00:00이라는 시간을 저장하면, 
                   데이터베이스에는 UTC 기준으로 2024-10-02 12:00:00으로 저장됩니다.
        조회할 때: 나중에 이 데이터를 조회하면, 
                   데이터베이스는 저장된 UTC 시간을 다시 한국 시간대로 변환해 2024-10-02 21:00:00으로 보여줍니다.


즉, TIMESTAMP는 언제나 동일한 기준(UTC)으로 시간을 저장하고, 
이를 각 나라나 서버의 시간대에 맞춰 보여주기 때문에, 
여러 나라에서 동시에 사용하는 시스템에서는 아주 유용합니다.

*/
-- ------------------------------------------------------------------------------
/*
	주제 : 사용자 변수를 생성해서 사용할 수 있다.
    
    변수? 컴퓨터의 특정 RAM메모리에 잠시 데이터(값)를 기억할 공간
    
    1. 변수를 생성하고 값을 저장시키는 문법
		   SET @변수명 = 변수에 저장할값;
      예)  SET @num = 100;

	2. 변수에 저장된 값을 조회하는 문법
		   SELECT @변수명;
      예)  SELECT @num;
*/
use market_db;

-- 변수 생성 후 정수 하나 저장
SET @myVar1 = 5;

-- 변수 생성 후 실수 하나 저장
SET @myVar2 = 4.25;

-- 변수 생성하고 문자열과 정수 저장 
SET @txt = '가수 이름=>';
SET @height = 166;

-- market_db 데이터베이스의 member테이블을 조회합니다.
-- 그룹의 평균키(height열에 저장된 데이터들)가 166보다 큰 그룹의 이름 조회 
select @txt as "가수이름", mem_name as "그룹이름"
from member
where height  > @height;

/*
  SELECT문에 전체 행 중에서 특정 행의 갯수를 제한해서 조회할때 LIMIT을 사용했습니다
  제한 할 행의 갯수도 변수를 선언하여 저장해 놓고 
  변수명을 이용해서 값을 불러와서 사용할수 있다.

SET @count = 3;

select mem_name, height
from member
order by height asc
limit @count;  -- <---- 문법상  limt 뒤에는 변수명이 올수 없다.
*/
-- 위 SET으로 생성한 @count변수 메모리에 저장된 값은 limit구문의 값으로 사용하지 못하였다.
-- 그러나 사용할 수 있는 해결 방법은  prepare 와 execute 예약어 구문을 사용하면 됩니다.
SET @count = 3;

-- prepare 프리페어 구문에  mySQL이름에 'select'구문을 미리 준비 해 놓고 대기 합니다.
-- 여기서 ? 기호는  ?기호 대신 아직 값이 정해져 있지 않아 나중에 결정해서 넣겠다는 의미의 기호 입니다.
prepare mySQL FROM 'select mem_name, height from member order by height asc limit ?';

-- execute 구문으로 mySQL이름으로 미리 준비 해 놓은 select전체문장을 실행하기 전에
-- using 구믄을 이용해 아직 결정되지 않은 ? 기호 자리에 들어갈값을 @count변수에 저장된 값으로 설정하고
-- select 문장을  'select mem_name, height from member order by height asc limit 3' 완성하고
-- 실행한 후 조회 하게 됩니다.
execute mySQL  using @count;

-- ----------------------------------------------------------------------------------
/*
	데이터 형변환 이란?
     - 정수를 실수로 변환 한다거나, 문자를 정수로 변환 시키는 것을 데이터의 형태를 변환한다고 해서 
	   데이터 형 변환 이라 한다.
	
    데이터 형변환 하는 방법 2가지 
    1. 개발자가 직접 제공되는 함수를 이용해 강제로 형변환 (명시적 형변환)
    2. 자동형변환  (암시적 형변환)
    
    1. 명시적 형변환
		CAST() 함수 
			문법
				SELECT  CAST(형변환할값 AS 변환할데이터유형) "열별칭명"
                FROM 조회할_테이블명;

		CONVERT() 함수
			문법
				SELECT CONVERT(형변환할값, 변환할데이터유형) "열별칭명"
                FROM 조회할_테이블명;
*/
-- 실습1. market_db 데이터베이스 내부에 만들어져 있는 구매(buy)테이블에서 
--       가수 그룹들이 구매한 평균가격 조회해서 가져오자
--       조회한 평균 가격은 142.9167 즉! 실수값으로 조회되어 나옵니다. 이게 문제입니다. 
select avg(price) as "평균가격"
from buy;

-- 실습2. 실수값을 정수 데이터로 형변환을 하여 조회된 결과로 보여주자
-- 참고. CAST함수 내부에 작성할 데이터 유형은 
--       CHAR, SIGNED, UNSIGNED,  DATE, TIME,  DATETIME 등입니다.
--      여기서 SIGNED는 부호가 있는 정수,  UNSIGNED는 부호가 없는 정수 
select  cast( avg(price) as signed   ) as "평균 구매 가격"
from buy;

-- CAST 함수는? 데이터를 특정 데이터 형으로 형변환을 해주는 함수 

-- 실습2-1. 숫자를 문자열로 변환 
select CAST(123  as  CHAR); --  123 -> '123'로 변환되어 조회됨 

-- 실습2-2. 문자열을 정수 숫자로 변환
select CAST('456' as unsigned);  -- '456'  -> 456로 변환되어 조회됨

-- 실습2-3. 숫자를 문자열로 변환 
select CONVERT(123 , CHAR);    -- 123 -> '123'로 변환되어 조회됨 

-- 실습2-4. 문자열을 숫자로 변환 
select CONVERT('456', unsigned); -- '456' -> 456로 변환되어 조회됨

-- 실습2-5. 문자처리방식(인코딩방식) 변환 
select CONVERT('테스트' using utf8mb4);

-- 실습3. 날짜 데이터를 YYYY-MM-DD 날짜형식을 만들기 위해 데이터 유형을 DATE 사용해 데이터 형변환해보자
-- CAST(형변환할값 AS 형변환할_데이터유형);

-- '2026$06$17' 문자열을 2026-06-17  DATE유형의 데이터로 형변환 
select CAST('2026$06$17'   AS  DATE);

-- '2026/06/17' 문자열을 2026-06-17  DATE유형의 데이터로 형변환   
select CAST('2026/06/17'  AS  DATE);

-- 실습4. 조회결과를 원하는 날짜형으로 형변환해서 조회된 결과를 출력해서 보여줄수 있다
/*
 참고.  CONCAT()함수 : 여러개의 문자열이나 열의 값을 하나로 이어 붙일때 사용하는 문자열 함수 입니다.
	   기본 사용 방법
					CONCAT(문자열1, 문자열2, 문자열3);
                            문자열1 + 문자열2 + 문자열3  -> 하나의 문자열로 합쳐서 반환 해줍니다.
*/
select * from buy;
select num,
	   concat( cast(price as char), 'X', cast(amount as char), "=") as '가격 X 수량',
       price * amount  as '구매액'    
from buy;
/*
	2. 자동 형변환(암시적 형변환) 실습
*/
-- 실습1. '100' + '200'
-- 설명 :  + 연산을 할때 문자열이 정수로 각각 자동변환된 후 
--        + 연산자 기호를 이용해 계산합니다. 계산결과 300이 조회됨
   select '100' + '200';
-- select  100  +  200 ;
-- select   300;

-- 실습2. 문자열 '100'과  문자열 '200'을 하나로 합친 '100200'하나의 문자열로 만들어서 조회되게 하려면?
--       CONCAT() 함수를 사용하자
   select concat('100','200');
-- select        '100200';

-- 실습3. 숫자와 문자열을 CONCAT()함수를 호출할때 인수로 전달하면
--       숫자는 문자열 '100'으로 자동 형변환되고, 문자열 '200'과 합쳐진 '100200'로 조회됩니다.
   select concat(100, '200');
-- select 		'100200';

-- 실습4.  + 연산자 기호를 사용해 숫자 + '문자열' 계산하면?
--        앞 숫자를 기준으로 뒤 '문자열'이 숫자로 자동형변환되어서 200숫자로 자동형변환 된 다음에 100과 더합니다.
--        100  +  200  = 300
   select 100  + '200';

--         200  +  100 = 300 
   select '200' + 100;
-- -------------------------------------------------------------------------------
/*
	조인 (join) : 하나 이상의 테이블의 열에 저장된 행 데이터들을 묶어서 하나의 표형태의 결과 조회하는 구문
    
    조인 종류
    1. 내부조인 (Inner Join)  === 조인 
	2. 외부조인 (Outer Join)
    3. 상호조인 
    4. 자체조인 
    
    1. 내부 조인 (Inner Join)
    - 두 테이블 양쪽 열에 저장된 데이터가 저장되어 있을때 사용되는 조인 종류 중 하나
    - 두 테이블의 교집합의 값을 조회해서 보여 줍니다. 즉, 조인 조건을 충족하는 열들의 행 데이터만 조회해서 반환함
    - 두 테이블에서 공통된 값이 같은 종류의 열에 저장되어 있는 행만 조회.
      즉, 조인 조건을 만족하는 열의 행 데이터만 조회 결과에 포함시키는 조인 
	- 문법
			select 하나이상의_테이블에서 조회할 열명들 나열 
            from   첫번째_테이블명  inner join  두번째_테이블명
            on  첫번째_테이블명.key = 두번째_테이블명.key      <------ 두테이블을 연결해서 조회할 조건식 작성 자리
			where 검색조건식;
            
			select 첫번째테이블명.첫번째테이블에서조회할열명,  두번째테이블명.두번째테이블에서조회할열명
            from   첫번째테이블명  inner join  두번째테이블명
            on     첫번째테이블명.열명 = 두번째테이블명.열명     <------- 두테이블을 연결해서 조회할 조건식 작성 자리 
            where 검색조건식;
*/
use market_db;

select * from buy;    -- 각 회원그룹들이 한번 구매한 상품의 행 정보가 저장되어 있는 테이블
select * from member; -- 가입한 회원그룹 정보가 행단위로 저장되어 있는 테이블 

/*
	실습1. 구매(buy)테이블과 , 회원(member)테이블을 사용하자.
		  구매 테이블에는 구매한 상품 정보만 저장되어 있고,
          회원 테이블에는 가입한그룹의 회원정보만 저장되어 있습니다.
          회원에게 구매한 상품정보를 배송하려면 회원의 주소, 연락처가 있는 member테이블과 
          구매 상품정보 (buy테이블)를 결합해서 조회해서 가져 와야 합니다.

구매(buy)테이블에서 GRL이라는 그룹아이디를 가진 회원그룹이 구매한 물건을 배송하기 위해 
inner join을 통해  회원그룹이름   /회원그룹주소/연락처                /구매한상품명 등을 조회할수 있습니다.
				  mem_name열값/addr열값  /phone1열값 + phon2열값/ prod_name열값
*/
select member.mem_name, member.addr, member.phone1, member.phone2, buy.prod_name
from   buy  Inner join member  
on     buy.mem_id  =  member.mem_id
where  buy.mem_id = 'GRL';
/*
  buy테이블과 member테이블을 inner join 하여 
  전체 그룹회원의 아이디, 이름, 구매한 제품명, 주소정보 조회 하는데
  전체 그룹회원 아이디를 기준으로 오름차순 정렬 해서 최종 조회 !!!!!!!!!
*/
select M.mem_id,  M.mem_name,  B.prod_name,  M.addr
from  buy  B  join  member  M
on    B.mem_id  =  M.mem_id
order by  M.mem_id asc;

/*
	우리 사이트에서 한번이라도 구매한 기록이 있는 회원그룹들에게 감사의 안내문을 발송해야 한다면
    회원 그룹 아이디, 회원 그룹이름, 주소 를 중복없이
    buy테이블과 member테이블의 inner join을 하여 열을 조회
*/
select distinct M.mem_id,  M.mem_name,  M.addr
from buy B  inner join  member M
on  B.mem_id = M.mem_id
order by M.mem_id desc;
/*
	외부 조인 (OUTER JOIN)
    - 두 테이블 중에 한쪽 기준이 되는 테이블의 열에만 데이터가 저장되어 있어도 
      두 테이블의 행에 관 비어있는 열값도 같이 조회 하기 위한 조인 
      
    외부 조인 종류
    - 1. LEFT OUTER JOIN ( LEFT JOIN  )
	- 2. RIGHT OUTER JOIN ( RIGHT JOIN )
    - 3. FULL OUTER JOIN  (FULL JOIN )
    
	1. LEFT OUTER JOIN
       기준이 되는 왼쪽 테이블의 열 데이터를 모두 조회 하되,
       오른쪽 테이블의 열값이 NULL로 비어있는값이 있더라도 같이 조회 결과로 보여주는 조인.
*/
-- 실습 1. 전체 그룹 회원 중에서 구매기록이 없는 그룹회원의 정보도 함께 모두 조회 하기 위해 
--        LEFT OUTER JOIN 사용 
select M.mem_id, M.mem_name, M.addr,  B.prod_name
from   member M  left outer join  buy B
on  M.mem_id = B.mem_id
order by M.mem_id ASC;
/*
2.  RIGHT OUTER JOIN
    - 오른쪽에 작성한 테이블을 기준으로 열에 모든데이터가 저장되어 있으면
	  왼쪽 테이블에 열의 데이터가 저장되어 있지 않아도 모든 열값을 NUll로 채워서 같이 조회 
*/
-- 실습2. 전체  그룹 회원 중에서 구매기록이 없는 그룹회원의 열 정보도 함께 모두 조회 하기위해 
--       RIGHT OUTER JOIN 사용

-- member테이블의 mem_id열데이터(그룹회원아이디들)가 
-- buy테이블의 mem_id열데이터(구매한기록이있는 그룹회원아이디들)가 일치하는 행이 있으면 
-- member테이블을 기준으로 모든 열(mem_id, mem_name, addr)의 값이 조회되고
-- buy테이블을의 열의 값이 존재하지 않아도 빈공 백(NULL)으로 조회
select M.mem_id, M.mem_name, M.addr, B.prod_name
from buy B RIGHT OUTER JOIN member M
on M.mem_id =  B.mem_id;

-- 실습3. 전체 회원 그룹중에서 한번도 구매한 기록이 없는 그룹회원 목록을 조회 하기 위해
--       LEFT OUTER JOIN사용
--       단! 열의 데이터가 중복되면 하나로 합쳐서 하나의 데이터로 조회!
select distinct member.mem_id,  buy.prod_name, member.mem_name, member.addr
from member left outer join buy
on member.mem_id = buy.mem_id
where buy.prod_name is null;
-- ------------------------------------------------------------------------
-- 주제 : LEFT OUTER JOIN,  RIGHT OUTER JOIN 예

-- A테이블 생성
create table A(
	id     int primary key,  -- 회원 id
    name   varchar(50)      -- 회원 이름 
);
-- A 테이블에 새로운 3개 행 데이터 다중 삽입 해서 저장 
insert into A(id, name) values(1, 'Alice'),(2,  'Bob'),(3, 'Charlie');

-- A 테이블 모든 열 조회
select * from A;

-- B 테이블(A테이블에 저장된 회원이 주문한 상품 정보가 행 단위로 저장 되는 테이블) 생성 
create table B (
	id          int primary key,  -- 주문 id
    order_item  varchar(50)       -- 주문한 상품이름 
); 

-- B 테이블에 3개 행 데이터(주문한 상품 정보 3쌍) 삽입 해서 저장
insert into B (id, order_item) values (2, 'Laptop'), (3, 'Smartphone'), (4, 'Tablet');

-- B 테이블 조회 
select * from B;
/*
		A테이블 <- 회원정보		B테이블 <- 회원이 구매한 제품 정보 
		id  name			  id  order_item
		1	Alice             2		Laptop
        2   Bob				  3		Smartphone
		3	Charlie			  4		Tablet														
*/
-- LEFT OUTER JOIN
select A.id,  A.name, B.order_item
from  A LEFT OUTER JOIN B
on    A.id  =  B.id;
-- id 1은 A테이블에만 있으므로 order_item 값이 NULL로 조회되어 표시 됩니다
-- id 2와 id 3은 양쪽테이블에 모두 있으므로 name과 order_item이 모두 조회되어 표시됩니다.
/*
id  name     order_item
1	Alice		    NULL
2	Bob			   Laptop
3	Charlie		Smartphone
*/
/*
		A테이블 <- 회원정보		B테이블 <- 회원이 구매한 제품 정보 
		id  name			  id  order_item
		1	Alice             2		Laptop
        2   Bob				  3		Smartphone
		3	Charlie			  4		Tablet														
*/
-- RIGHT OUTER JOIN
select A.id,  A.name,  B.order_item
from A RIGHT OUTER JOIN B
on A.id = B.id;
-- 설명 : 
-- id 2와 id3은 양쪽 테이블에 모두 있으므로 name과 order_item열의값이
-- 모두 조회됩니다.
-- 하지만 id 4는  B테이블에만 있으므로 A테이블의 name열값은 NULL값으로 조회되고
-- B테이블의 order_item열값은 Tablet으로 조회됩니다.    
/*
id   name 	   order_item
2	 Bob	   Laptop
3	 Charlie   Smartphone
NULL  NULL	   Tablet

 LEFT OUTER JOIN 
 - 왼쪽에 작성한 테이블의 모든 행을 기준으로 데이터를 조회하며,
   오른쪽에 작성한 테이블에 대응되는 데이터가 없으면 그열은 NULL로 채워져 조회하는 구문 

 RIGHT OUTER JOIN
 - 오른쪽에 작성한 테이블의 모든 행을 조회 결과로 포함하며,
   왼쪽에 작성한 테이블의 열에 일치하는 데이터가 없더라도 오른쪽 테이블의 열 데이터를 모두 조회함
   만약 왼쪽 테이블에 일치하는 행에 관한 열의 데이터가 없다면 
   해당 열값은 NULL로 표시되어 조회하는 구문

*/
-- ------------------------------------------------------------------------
/*
	상호 조인(CROSS JOIN)?
		한쪽 테이블의 모든 행과  다른쪽 테이블의 모든 행을 랜덤으로 조인해서 조회 하는 구문 
		그래서 상호 조인 조회 결과의 전체 행 개수는 
        두 테이블의 각행의 개수를 곱한 개수 됩니다.
        대용량 데이터를 조회 해서 만들어  테이블을 새로 생성할때 사용됨
        
	상호 조인 특징
		- ON 구문을 사용할 수 없습니다.
        - 조회 결과 행의 열데이터들에 의미가 없습니다. 랜덤으로 조인하기 떄문입니다.
        - 상호 조인의 주용도는 대용량 데이터를 테스트하기 위해 데이터를 생성할때 조회하게 됩니다.
*/
-- buy 테이블과 member테이블 상호(cross) 조인 해서 조회 
select * from buy cross join member;

-- 120개 행이 랜덤으로 연결되어 조회됨
select count(*) from buy cross join member;

-- 샘플 데이터베이스인 sakila데이터베이스의 inventory테이블 표에 저장된 
-- 전체 행의 갯수 조회 
select count(*) from sakila.inventory; -- 4581행 

-- 샘플 데이터 베이스인 world데이터베이스의 city테이블에 
-- 저장된 행의 갯수 조회
select count(*) from world.city; -- 4079행 

-- 위 두 inventory 테이블의 행 데이터와 
--      city 테이블의 행 데이터를 상호 조인 한 전체 행갯수 조회해서 출력
--      4581 X 4079 = 18685899 조회된 행의 갯수
select count(*) as '행(데이터)의 갯수'
from sakila.inventory  cross join  world.city;
-- ----------------------------------------------------------
/*
	대용량 데이터가 저장되는 테이블을 만들고 싶으면?
    방법 : create table ~ select * 테이블명1 cross join 테이블명2;
*/
create table cross_table
	select * from sakila.actor   -- 200 행데이터 
				  cross join
                  world.country; -- 239 행데이터  

-- cross_table테이블에 저장된 총 행(레코드) 갯수 조회 
select count(*) from cross_table; -- 47800 행(레코드) 조회 
-- ----------------------------------------------------------------------
/*
	자체 조인 (self join)
    - 자신의 테이블의 두개의 열 데이터를 이용해 조회 하기 위한 조인 구문.
      자체 조인은 하나의 테이블에 서로 다른 별칭을 설정해서 조인하는 구문.
	
    자체 조인 문법
				SELECT 조회할열명
                FROM   테이블명1 별칭A  INNER JOIN 테이블명1 별칭B
                ON  조인이 될 조건식
                WHERE 검색 조건식;
*/
-- 실습1. market_db 데이터베이스 내부에 emp_table라는 이름의 테이블 생성 후 각 데이터 저장
create table emp_table (
	emp       char(4),   -- 회사 직급 정보 저장 ('대표', '영업이사', '인사부장' 등등)
    manager   char(4),   -- 직속상관의 직급 정보 저장 ('대표', '영업이사', '정보이사' 등등)
    phone     varchar(8)  -- 사내 연락처 저장 ('1111-1', '2222-1' 등)
);

insert into emp_table values('대표', NULL, '0000');

insert into emp_table values('영업이사', '대표', '1111');
insert into emp_table values('관리이사', '대표', '2222');
insert into emp_table values('정보이사', '대표', '3333');

insert into emp_table values('영업과장', '영업이사','1111-1');
insert into emp_table values('경리부장', '관리이사','2222-1');
insert into emp_table values('인사부장', '관리이사','2222-2');
insert into emp_table values('개발팀장', '정보이사','3333-1');

insert into emp_table values('개발주임', '정보이사','3333-1-1');

select * from emp_table;

-- 실습2. 경리부장 직속상관(관리이사)의 연락처 정보와 함께 조회 하기 위해 자체 조인 사용!
SELECT 
    A.emp AS '직원직급정보',
    B.emp AS '직속상관의 직급정보',
    B.phone AS '직속상관 연락처'
FROM
    emp_table AS A
        INNER JOIN
    emp_table AS B ON A.manager = B.emp
WHERE
    A.emp = '경리부장';
/*
조회 결과 

열명   	직원직급정보  직속상관의 직급정보      직속상관 연락처 
        경리부장	     관리이사				2222
*/

-- --------------------------------------------
-- 04-3절 SQL 프로그래밍 
-- ---------------------------------------------

/*
	스토어드 프로시저란?
		데이터베이스 서버에 저장되어 있는 일련 SQL문장들로 구성된 프로그램(개체)
        
	스토어드 프로시저 개체 작성 문법
    
		-- 여러 줄의 SQL구문을 작성 해 놓을 스토어드 프로시저를 생성하기 위해
        --  MySQL의 기본 구분자(문장의 끝을 나타내는 기호 ;)를 변경하기 위해 $$로 변경 시키는 구문 
		DELIMITER $$
        
        CREATE procedure 스토어드_프로시저_이름()
        begin
				이 영역에 SQL 프로그래밍을 위해 코딩 합니다.
        
		end $$
        
        -- 기본 구분자 기호 $$를  ;세미콜론 기호로 변경 시키는 구문 
        DELIMITER ;
        
	
    -- 위 생성한 스토어드 프로시저 개체를 호출하여 실행시키는 문법!
	CALL  스토어드_프로시저_이름();
				
	--------------------------------------------------------------------------------
    
     IF 문  :  10  > 100 조건식의 결과 참이면 SQL문을 실행하고, 거짓이면 빠져나가는 조건문 

	 IF 문 작성 문법
					IF 조건식 THEN
						
                        조건식의 결과가 참일 때 실행될 SQL문의 코드 작성
                    
                    END IF;
*/
-- 실습1.  만약 ifProc1이라는 이름의 스토어드 프로시저 개체가 이미 만들어져 있으면 삭제 시키자
DROP procedure if exists ifProc1;

DELIMITER $$

CREATE procedure ifProc1()
begin
	-- 이 영역에 SQL 프로그래밍을 코딩 합니다.
    IF 100 = 100 THEN
		select '100은 100과 같습니다.' as '조회결과';
	END IF;
end $$

DELIMITER ;

-- 바로 위에서 만든 ifProc1라는 이름의 스토어드 프로시저 개체를 호출하여 안쪽에 작성된 IF 문을 실행 시킵니다.
CALL ifProc1();

/*
	IF ~ ELSE 조건문
		- IF 조건식이 참이면 SQL문장1을 수행하고 IF 조건식이 거짓이면 SQL문장2를 수행하는 조건문
        - 문법
				IF 조건식 THEN
					SQL문장1;
                ELSE
					SQL문장2;
                END IF;
*/
-- 실습2. 만약 ifProc2라는 이름의 스토어드프로시저 개체가 이미 만들어져 있으면 삭제 시키자 
DROP procedure if exists ifProc2;

DELIMITER $$

CREATE procedure ifProc2()
begin
	declare myNum int; -- declare예약어를 사용해 myNum 라는 이름의 변수 메모리 선언 
	set myNum = 200;   -- set예약어를 사용해 myNum이라는 이름의 변수 메모리에 200을 대입해서 저장 
		
	-- myNum변수 메모리에 저장되어 있는 값이 100과 같으냐? 라고 묻는 조건식
    IF myNum = 100 THEN
		select '100입니다.';
    ELSE -- myNum변수 메모리에 저장되어 있느 값이 100이 아니라면? (IF 조건식의 결과가 거짓이면?)
		select '100이 아닙니다.';
    END IF;
   
end $$

DELIMITER ;

-- ifProc2라는 이름의 스토어드 프로시저 개체를 호출하여 SQL코드 실행!
CALL ifProc2();

-- ---------------------------------------
/*
	market_db 데이터베이스 내부에 만들어져 있는 member테이블의 정보를 활용해서 
    스토어드 프로시저 개체 생성 후 사용 

	실습. 회원그룹 아이디가 APN(에이핑크)인 회원그룹의 데뷔일자가 5년이 넘었는지 확인해보고 
         5년이 넘었으면 축하 메세지를 만들어서 출력 해 보자.
*/
-- 만약 이미 ~  ifProc3 스토어드 프로시저 개체가 만들어져 있으면? 삭제 시키자
DROP procedure if exists ifProc3;

DELIMITER $$

CREATE procedure ifProc3()
begin
	declare debutDate DATE; -- 데뷔일을 저장할 변수 메모리 선언             예) 2011-02-10
    declare curDate   DATE; -- 오늘 현재 날짜 정보를 저장할 변수 메모리 선언  예) 2026-06-19
	declare days      INT; -- 데뷔일로 부터 오늘 현재 날짜까지 활동한 일수를 저장할 변수 메모리 선언 
    
    -- 에이핑크그룹의 데뷔일을 조회 해서 debutDate변수에 저장하기 위해 into 절을 작성
    --  문법  select 조회할열명 into 저장할변수명 
    select debut_date into debutDate
    from market_db.member
    where mem_id = 'APN';
    
    -- 참고. MySQL서버 컴퓨터의 시스템 날짜 정보를 반환하는 함수 -> current_date() 함수
    set curDate = current_date(); -- 2026-06-19 현재 날짜 정보를 curDate변수 메모리에 저장 
    
    -- 참고. datediff(날짜2, 날짜1) 함수 
    --      : 날짜2부터 날짜1까지 일수를 계산해서 우리 개발자한테 반환 하는 함수 
    -- 에이핑크 데뷔날짜로 부터 현재 날까지 활동한 일수를 일단위로 구해서 days벼수에 저장
    set days = datediff(curDate, debutDate);
    
    -- 에이핑크 데뷔년도가 5년이 지났다면? (조건식)
    if (days/365) >= 5 then
        select concat('데뷔한지',days,'몇일이 지났습니다. 핑순이들 축하합니다.');        
    else -- 에이핑크 데뷔년도가 5년이 지나지 않았다면?
		select concat('데뷔한지',days,'일 밖에 안되었네요. 핑순이들 화이팅!');
    end if;
   
end $$

DELIMITER ;

-- 스토어드 프로시저 호출 
CALL ifProc3();

-- 참고. 현재 오늘날짜 정보와 시간정보를 함께 얻고 싶을때
--      ->  current_tiemstamp() 함수를 호출하면  2026-06-19 16:27:59 반환 받을수 있다.

/* 
  CASE 문
		- 2가지 이상의 조건식 중 선택해서 실행해야 할 경우 사용하는 선택문 
        
        - 문법
					CASE                    
						WHEN 조건식1 THEN
							SQL문장들1;
                            
						WHEN 조건식2 THEN
							SQL문장들2;
                            
						WHEN 조건식3 THEN
							SQL문장들3;
                            
						ELSE
							조건식1, 조건식2, 조건식3이 모두 거짓일 경우 실행할 SQL문장들;
                    END CASE;
*/
-- 실습1. 시험점수와 학점을 생각 해 봅시다.
-- 90점이상은 A학점, 
-- 80점이상은 B학점, 
-- 70점이상은 C학점, 
-- 60점이상은 D학점, 
-- 60점 미만은 F학점 

-- 만약 이미 ~  ifProc4 스토어드 프로시저 개체가 만들어져 있으면? 삭제 시키자
DROP procedure if exists ifProc4;

delimiter $$	
    create procedure caseProc()
    begin
		declare point int; -- 시험 점수를 저장할 point라는 이름의 지역변수 선언 
        declare credit char(1); -- A 또는 B 또는 C등의 학점을 저장할 credit라는 이름의 지역변수 선언 
        set point = 88;  -- 시험점수 88을 point지역변수 저장 
        
        case
			when point >= 90 then -- 시험 점수가 90점 이상이  point변수에 저장되어 있습니까?
				set credit = 'A'; -- A 학점 저장 
                
			when point >= 80 then -- 시험 점수가 80점 이상이  point변수에 저장되어 있습니까?
				set credit = 'B'; -- B 학점 저장 
                
			when point >= 70 then -- 시험 점수가 70점 이상이  point변수에 저장되어 있습니까?
				set credit = 'C'; -- C 학점 저장                 

			when point >= 60 then -- 시험 점수가 60점 이상이  point변수에 저장되어 있습니까?
				set credit = 'D'; -- D 학점 저장 
                
            else  -- 60점 미만이면?    
				set credit = 'F'; -- F학점 저장 
        end case;
        
        select concat('취득점수->', point) as '취득점수', concat('학점->',credit) as '학점';
        
	end $$
delimiter ;

-- 위 만들어진 스토어드프로시저 caseProc 호출해서 안쪽 구문 모두 실행하자 
call caseProc();

-- -----------------------------------------------------------
/*
	실습2. market_db에서 buy테이블에는 회원그룹이 구매한 상품정보가 한줄 단위로 저장되어 있습니다.
	      회원그룹 아이디 별로  총 구매액을 계산해서 
          회원등급을 4단계(최우수고객, 우수고객, 일반고객, 유령고객)로 나누어서 조회 하자.
*/
-- 순서1. 회원 그룹 아이디 별로 묶어서 총 구매액을 조회 
select  mem_id,  SUM(price * amount) as "총구매액"
from buy
group by mem_id;

-- 순서2. 총 구매액이 큰순에서 작은순으로 내려가면서 정렬해서 (내림 차순 정렬)해서 조회 
select  mem_id,  SUM(price * amount) as "총구매액"
from buy
group by mem_id
order by SUM(price * amount)  DESC;

-- 순서3. 총 구매액과 함께 회원그룹의 정보(회원 이름)도 같이 조회
--       member테이블(mem_name열)과 buy테이블(mem_id)과 총구매액 을 같이 연결(join)해서 조회 
select B.mem_id, M.mem_name, SUM(price * amount) as "총구매액"
from buy B join member M
on B.mem_id = M.mem_id
group by mem_id
order by SUM(price * amount) DESC;

-- 순서4. 주의 할점은 구매테이블에는 4개의 그룹회원만 구매한 정보가 있으므로,
--       나머지 6그룹에 대한 아이디 정보가 없으므로
--       구매 하지 않은 회원그룹의 이름도 같이 연결해서 조회 
select M.mem_id, M.mem_name,  SUM(price * amount) as "총구매액"
from buy B right outer join member M
on B.mem_id = M.mem_id
group by M.mem_id
order by SUM(price * amount) desc;

-- 순서5. 회원 등급별로 나누자 
select M.mem_id, M.mem_name,  SUM(price * amount) as "총구매액",
	   case
			when ( SUM(price * amount)  >= 1500 )   then '최우수 고객' 
            when ( SUM(price * amount)  >= 1000 )   then '우수 고객'
			when ( SUM(price * amount)  >= 1    )   then '일반 고객'
			else '유령고객'				
       end '회원등급'
from buy B right outer join member M
on B.mem_id = M.mem_id
group by M.mem_id
order by SUM(price * amount) desc;

-- ----------------------------------------------------------
-- 이미 만들어져 있는 totalLevel이라는 이름의 스토어드 프로시저 개체가 있으면 삭제 
DROP procedure if exists totalLevel;

DELIMITER $$

CREATE procedure totalLevel() -- 회원 그룹 아이디 별로 총 구매한 구매액에 따라 회원등급을 조회 해서 보여주는 프로시저 
begin
	select M.mem_id, M.mem_name,  SUM(price * amount) as "총구매액",
		   case
				when ( SUM(price * amount)  >= 1500 )   then '최우수 고객' 
				when ( SUM(price * amount)  >= 1000 )   then '우수 고객'
				when ( SUM(price * amount)  >= 1    )   then '일반 고객'
				else '유령고객'				
		   end '회원등급'
	from buy B right outer join member M
	on B.mem_id = M.mem_id
	group by M.mem_id
	order by SUM(price * amount) desc;
   
end $$

DELIMITER ;

-- 회원 그룹 아이디 별로 총 구매한 구매액에 따라
-- 회원등급을 보여주는 프로시저 호출
call totalLevel();
call totalLevel();
/*
WHILE 반복문 
	조건식이 참일 경우 반복실행할 SQL문을 작성하는 구문
    
WHILE 반복문 작성 문법

	WHILE (조건식) DO
		반복실행할 SQL문장들
    END WHILE;
*/
-- 이미 만들어져 있는 whileProc라는 스토어드프로시저가 만들어져 있으면 삭제
DROP PROCEDURE IF EXISTS whileProc;

-- 실습1.  1에서 100까지의 값을 모두 더하는 간단한 기능의 WHILE구문 구현
DELIMITER $$

CREATE PROCEDURE whileProc()
BEGIN
	-- 1에서 100까지 1씩 증가 된 값이 저장될 지역변수 선언
    declare i int;   -- 1    2    3   ~~~~~   99   100
    -- 1부터 100까지 누적한 값 저장될 지역변수 선언
    declare hap int;  --  1 + 2 한 3저장.   또는  3 + 4 한 7 저장. 
    
    set i = 1;        -- i 지역변수에 처음 저장되는 값(초깃값) 1로 저장 
    set hap = 0;      -- hap 지역변수에 초깃값으로 0 저장 
    
    WHILE(i <= 100) DO  -- i지역변수에 저장되는 값이 100보다 작거나 같을 동안~ 반복해서 수행 		
        set hap = hap + i; -- hap지역변수에 i변수값 누적 
        set i = i + 1;     -- i지역변수에 저장된 값에~ 1증가해서 다시 i지역변수에 저장
    END WHILE;
    
    select '1부터 100까지의 합==>', hap;

END $$

-- 기본 구분자 기호를 ;세미콜론 기호로 변경하기 위한 설정 구문
DELIMITER ;


-- 바로 위에서 만든 whileProc스토어드 프로시저 개체 호출!
CALL whileProc();

-- 실습2. 1에서 100까지 합계에서 4의 배수를 제외한 숫자들의 합을 계산하고,
--       숫자들의 합이 1000이 넘으면 더이상 합치지 않고 while반복문을 종료 하라!

-- 이미 만들어져 있는 whileProc2라는 스토어드프로시저 개체가 만들어져 있으면 중복생성되므로 삭제
drop procedure if exists whileProc2;

delimiter //
	
    create procedure whileProc2()
    begin
		declare i int;  -- 1에서 100까지 1씩 증가되는 값을 각각 저장할 변수 선언 
        declare hap int; -- 1부터 1000까지 숫자들을 계속 누적한값 저장 용도의 변수 선언 
		set i = 1;
        set hap = 0;
        
        -- myWhile이라는 이름으로 레이블명 지정
        myWhile:
        while(i <= 100) do
			-- 현재 i변수에 저장되어 있는 값이 4의 배수와 같다면?
            -- (i변수 값을 4로 나누었을때 나머지가 0과 같다면?)
            -- (i변수 값이 4로 나누어 떨어진다면?)
            if(i % 4 = 0) then
				-- i변수에 저장되는 값을 1증가해서 저장 
                set  i = i + 1;
                -- 위 지정한 myWhile 레이블 위치로 올라가서 
                -- 다시 while반복문의 조건식을 검사해~ 라고 명령하는 iterate 예약어 구문 작성
                iterate myWhile;
            end if;
            
            -- 1부터 100사이의 4의 배수가 아닌 숫자를 hap변수에 누적
            set hap = hap + i;

			-- hap변수에 i변수들을 계속 더해서 저장한 누적값이 1000을 초과 하는 순간 while반복문을 빠져나가 종료
            -- 방법 : leave 예약서 구문 사용 
            if(hap > 1000) then
                leave myWhile;  -- myWhile이라는 레이블 명이 작성된 바깥 위치로 빠져나감
			end if;
            
            -- i변수값 1씩 더해서 다시 저장(i변수 값 1증가)
            set i = i + 1;

		end while;
        
        select '1~100까지의 숫자중에서 4의배수를 제외한 숫자들의 누적합계를 그리고 합계가 1000이 넘으면 while반복문 종료',
                hap AS "합계";
	end //

delimiter ;

-- whileProc2 스토어드프로시저 개체 호출 해서  조회 결과 출력
call whileProc2();

-- -------------------------------------------------------------------------------------------
/*
	동적 SQL문 이란?
		- SQL문이 고정된 것이 아니라 상황에 따라 where 조건열의 값을 변경해서 
          필요할때 마다 추가해서 완성되는 SQL구문 
    
		- 참고.  prepare 프리페어 예약어를 사용한 SQL구문은  SQL문을 미리 준비 해 놓는 구문.
		- 참고.  execute 익스큐트 예약어를 사용한 SQL구문은  prepare 예약어를 사용해 준비 해 놓은 
                SQL문을 실행하는 구문.


	market_db 데이터베이스의 테이블 이용
*/
USE market_db;
-- 실습1. member테이블에 저장된 "BLK"라는 그룹 아이디를 가진 그룹회원의 정보를 조회 하기 위해
--       미리 prepare 예약어를 사용한 구문에 준비 해 두고 
--       execute 예약어를 사용해 준비 해 놓은 SQL을 실행 해서 조회 하자.

-- 미리 준비 해 놓을 SQL문을 작성해서 실행할 이름을 prepare예약어로 설정
prepare myQuery FROM 'select * from member where mem_id = "BLK"';

-- prepare 예약어로 미리 준비해서 만들어 놓은 myQuery라는 이름으로 불러와 execute예악어로 실행!
execute myQuery;

-- 실습2. 출입한 날짜와 시간정보를 저장해 두는 테이블을 생성하고
-- 		 출입한 날짜와 시간정보를 동적으로 바뀌는 데이터이므로 INSEDRT문장을 만들어 놓고 실행!

-- 출입한 날짜와 시간정보를 저장 해 두고 관리하는 gate_table테이블 생성
CREATE TABLE gate_table(
	id          int auto_increment primary key, -- 출입한 회원 아이디가 저장될 열 
	entry_time  datetime -- 출입한 날짜와 시간 정보가 함께 저장될 열 
					     -- 'YYYY-MM-DD hh:mm:ss'
                         -- '2026-06-22 15:02:59'
);
-- 현재 출입한 현재 날짜와 시간 정보를 얻어서 변수에 저장
set @curDate = current_timestamp(); -- '2026-06-22 15:02:59'

select @curDate;

-- prepare 구문을 이용해 출입한 현재 날짜와 시간정보를 동적으로 gate_table테이블에 추가 하기 위해
-- ? 기호를 insert문장에 포함해  향후 추가될값(현재 출입한 현재 날짜와 시간정보)을 아직 결정하지 않는 것입니다.
prepare mySQL FROM 'insert into gate_table(id, entry_time) values(null, ?)';

-- execute 구문 내부에 using 예약어를 사용해 @curDate변수에 저장된 현재 날짜와 시간정보를
-- ? 기호 대신 투입해서 insert문을 실행하게 됩니다.
-- execute 예약어 구문을 실행하는 시점이 insert문장이 실행해서 그시점의 날짜와 시간 정보가 테이블에 추가 저장되게 된다.
execute mySQL using @curDate;
/*
순서1.
execute 'insert into gate_table(id, entry_time) values(null, ?)' using '2026-06-22 15:02:59';
순서2. 
execute 'insert into gate_table(id, entry_time) values(nulll,'2026-06-22 15:02:59');		
*/
select * from gate_table;  --  <---- 조회 해서 insert 됬는지 확인 

-- ------------------------------
-- 05-1절 테이블 만들기
-- ------------------------------
/*
 주제 : 실무 기준 데이터베이스 설계와 테이블 만들기

  ============================================================
  1. 데이터베이스 설계란?
  ============================================================

    데이터베이스 설계는 업무에서 발생하는 데이터를
    안전하게 저장하고, 정확하게 조회하고, 쉽게 수정할 수 있도록
    테이블 구조와 데이터 규칙을 정하는 작업입니다.

    실무에서 데이터베이스 설계를 잘못하면 다음 문제가 생깁니다.

      - 같은 데이터가 여러 곳에 중복 저장됩니다.
      - 한 곳만 수정하고 다른 곳은 수정하지 않아 데이터가 서로 달라집니다.
      - 없는 고객의 주문처럼 잘못된 데이터가 저장됩니다.
      - 데이터를 조회할 때 SQL이 복잡해집니다.
      - 데이터가 많아질수록 조회 속도가 느려집니다.
      - 나중에 기능을 추가할 때 테이블을 크게 고쳐야 합니다.

    따라서 테이블을 만들기 전에 반드시 다음을 정해야 합니다.

      1. 어떤 업무 데이터를 저장할 것인가?
      2. 데이터는 어떤 단위로 나눌 것인가?
      3. 각 테이블은 어떤 컬럼을 가져야 하는가?
      4. 각 테이블에서 한 행을 구분하는 기준은 무엇인가?
      5. 테이블끼리는 어떤 관계인가?
      6. 어떤 값은 반드시 입력되어야 하는가?
      7. 어떤 값은 중복되면 안 되는가?
      8. 어떤 값은 특정 범위를 벗어나면 안 되는가?
      9. 데이터를 삭제할 때 연결된 데이터는 어떻게 처리할 것인가?
      10. 자주 조회하는 조건에는 인덱스가 필요한가?


  ============================================================
  2. 실무에서 테이블 설계하는 순서
  ============================================================

    1단계. 업무 기능을 확인합니다.

      예:
        회원가입
        로그인
        상품 등록
        상품 조회
        주문 생성
        주문 취소
        결제
        배송 조회

      기능을 먼저 확인해야 어떤 데이터가 필요한지 알 수 있습니다.


    2단계. 저장해야 할 데이터를 찾습니다.

      예:
        회원가입 기능에는 회원 데이터가 필요합니다.
        상품 등록 기능에는 상품 데이터가 필요합니다.
        주문 생성 기능에는 주문 데이터와 주문 상품 데이터가 필요합니다.

      이 단계에서는 아직 SQL을 작성하지 않습니다.
      먼저 업무에서 필요한 데이터를 빠짐없이 찾습니다.


    3단계. 데이터를 테이블 단위로 나눕니다.

      한 테이블에는 하나의 주제에 대한 데이터만 저장하는 것이 원칙입니다.

      예:
        고객 정보는 Customers 테이블
        상품 정보는 Products 테이블
        주문 정보는 Orders 테이블
        주문에 포함된 상품 정보는 OrderItems 테이블

      고객 정보와 주문 정보를 한 테이블에 섞으면 안 됩니다.
      고객과 주문은 저장 목적, 생성 시점, 수정 시점이 다르기 때문입니다.


    4단계. 각 테이블의 컬럼을 정합니다.

      컬럼은 해당 테이블에서 반드시 관리해야 하는 정보만 넣습니다.

      Customers 테이블 예:
        customer_id
        name
        email
        phone
        address
        created_at

      Products 테이블 예:
        product_id
        product_name
        price
        stock_quantity
        created_at

      Orders 테이블 예:
        order_id
        customer_id
        order_date
        order_status
        total_price

      OrderItems 테이블 예:
        order_item_id
        order_id
        product_id
        quantity
        order_price


    5단계. 기본키를 정합니다.

      기본키는 테이블에서 한 행을 정확히 구분하는 값입니다.

      기본키는 반드시 다음 조건을 만족해야 합니다.

        - 중복되면 안 됩니다.
        - NULL이면 안 됩니다.
        - 시간이 지나도 바뀌지 않는 값이 좋습니다.
        - 한 행을 찾을 때 기준으로 사용할 수 있어야 합니다.

      실무에서는 보통 다음처럼 ID 컬럼을 기본키로 많이 사용합니다.

        customer_id
        product_id
        order_id
        order_item_id

      이름, 전화번호, 주소처럼 바뀔 수 있는 값은 기본키로 적합하지 않습니다.


    6단계. 외래키를 정합니다.

      외래키는 다른 테이블의 기본키를 참조하는 컬럼입니다.
      외래키는 테이블 간 연결 관계를 만듭니다.

      예:
        Orders 테이블의 customer_id는
        Customers 테이블의 customer_id를 참조합니다.

      의미:
        주문 데이터는 반드시 실제 존재하는 고객과 연결되어야 합니다.

      예:
        OrderItems 테이블의 order_id는
        Orders 테이블의 order_id를 참조합니다.

      의미:
        주문상세 데이터는 반드시 실제 존재하는 주문과 연결되어야 합니다.


  ============================================================
  3. 관계 설계
  ============================================================

    1:1 관계

      한 행이 다른 테이블의 한 행과만 연결되는 관계입니다.
      실무에서는 자주 사용하지 않습니다.
      보안 정보, 추가 정보처럼 분리할 이유가 있을 때 사용합니다.


    1:N 관계

      한 테이블의 한 행이 다른 테이블의 여러 행과 연결되는 관계입니다.
      실무에서 가장 많이 사용합니다.

      예:
        고객 1명은 주문을 여러 번 할 수 있습니다.

      설계 방법:
        N쪽 테이블에 1쪽 테이블의 기본키를 외래키로 넣습니다.

      결과:
        Customers.customer_id
        Orders.customer_id


    N:M 관계

      양쪽 데이터가 서로 여러 개씩 연결되는 관계입니다.
      N:M 관계는 직접 연결하지 않고 중간 테이블을 만듭니다.

      예:
        주문 하나에는 여러 상품이 포함될 수 있습니다.
        상품 하나는 여러 주문에 포함될 수 있습니다.

      설계 방법:
        Orders와 Products 사이에 OrderItems 테이블을 만듭니다.

      결과:
        Orders
        Products
        OrderItems


  ============================================================
  4. 제약조건 설계
  ============================================================

    제약조건은 잘못된 데이터가 저장되지 않도록 막는 규칙입니다.

    PRIMARY KEY:
      기본키를 지정합니다.
      중복과 NULL을 허용하지 않습니다.

    FOREIGN KEY:
      다른 테이블과의 연결을 강제합니다.
      존재하지 않는 고객의 주문이 저장되는 것을 막습니다.

    NOT NULL:
      반드시 입력해야 하는 컬럼에 사용합니다.
      예: 이름, 상품명, 주문일자

    UNIQUE:
      중복되면 안 되는 값에 사용합니다.
      예: 이메일, 로그인 아이디

    CHECK:
      값의 조건을 검사합니다.
      예: 가격은 0보다 커야 함, 수량은 1 이상이어야 함

    DEFAULT:
      값을 입력하지 않았을 때 자동으로 들어갈 기본값을 정합니다.
      예: 주문상태 기본값을 '주문완료'로 설정


  ============================================================
  5. 실무형 CREATE TABLE 예시
  ============================================================

    CREATE TABLE Customers (
      customer_id INT PRIMARY KEY,
      name VARCHAR(50) NOT NULL,
      email VARCHAR(100) NOT NULL UNIQUE,
      phone VARCHAR(20),
      address VARCHAR(200),
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE Products (
      product_id INT PRIMARY KEY,
      product_name VARCHAR(100) NOT NULL,
      price INT NOT NULL CHECK (price > 0),
      stock_quantity INT NOT NULL DEFAULT 0,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE Orders (
      order_id INT PRIMARY KEY,
      customer_id INT NOT NULL,
      order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
      order_status VARCHAR(20) NOT NULL DEFAULT '주문완료',
      total_price INT NOT NULL CHECK (total_price >= 0),
      FOREIGN KEY (customer_id)
      REFERENCES Customers(customer_id)
    );

    CREATE TABLE OrderItems (
      order_item_id INT PRIMARY KEY,
      order_id INT NOT NULL,
      product_id INT NOT NULL,
      quantity INT NOT NULL CHECK (quantity > 0),
      order_price INT NOT NULL CHECK (order_price > 0),
      FOREIGN KEY (order_id)
      REFERENCES Orders(order_id),
      FOREIGN KEY (product_id)
      REFERENCES Products(product_id)
    );


  ============================================================
  6. 위 테이블 구조를 실무적으로 해석
  ============================================================

    Customers 테이블:
      고객 기본 정보를 저장합니다.
      email은 로그인이나 고객 식별에 사용될 수 있으므로 UNIQUE를 설정했습니다.
      name과 email은 필수 정보이므로 NOT NULL을 설정했습니다.

    Products 테이블:
      판매할 상품 정보를 저장합니다.
      price는 0보다 커야 하므로 CHECK 조건을 설정했습니다.
      stock_quantity는 입력하지 않으면 0으로 저장되도록 DEFAULT를 설정했습니다.

    Orders 테이블:
      주문의 대표 정보를 저장합니다.
      customer_id를 통해 어떤 고객의 주문인지 연결합니다.
      customer_id는 Customers 테이블에 실제 존재하는 값이어야 합니다.

    OrderItems 테이블:
      주문 안에 포함된 상품 목록을 저장합니다.
      order_id를 통해 어떤 주문에 포함된 상품인지 연결합니다.
      product_id를 통해 어떤 상품이 주문되었는지 연결합니다.
      quantity는 반드시 1 이상이어야 합니다.
      order_price는 주문 당시의 상품 가격을 저장합니다.


  ============================================================
  7. 정보처리기사 실기 문제 풀이 기준
  ============================================================

    문제에서 명사를 찾습니다.
      고객, 상품, 주문, 주문상세처럼 관리 대상이 되는 단어를 찾습니다.
      이 단어들은 테이블 후보입니다.

    각 명사의 정보를 찾습니다.
      고객명, 전화번호, 상품명, 가격, 주문일자처럼 세부 정보가 되는 단어를 찾습니다.
      이 단어들은 컬럼 후보입니다.

    각 테이블의 대표 번호를 정합니다.
      고객번호, 상품번호, 주문번호처럼 한 행을 구분할 수 있는 컬럼을 기본키로 정합니다.

    테이블 간 관계를 찾습니다.
      고객은 주문을 한다.
      주문은 상품을 포함한다.
      이런 문장에서 외래키가 필요한 위치를 찾습니다.

    1:N 관계이면 N쪽에 외래키를 둡니다.
      고객 1명은 주문 여러 개를 가질 수 있으므로
      Orders 테이블에 customer_id를 둡니다.

    N:M 관계이면 중간 테이블을 만듭니다.
      주문과 상품은 N:M 관계이므로
      OrderItems 테이블을 만듭니다.


  ============================================================
  8. 실무에서 반드시 확인하는 항목
  ============================================================

    컬럼명은 의미가 명확해야 합니다.
      name보다 customer_name처럼 쓰면 더 명확한 경우가 있습니다.

    금액 컬럼은 음수가 들어가지 않도록 해야 합니다.
      CHECK 조건을 사용합니다.

    필수 입력값은 NOT NULL로 막아야 합니다.

    중복되면 안 되는 값은 UNIQUE로 막아야 합니다.

    다른 테이블과 연결되는 값은 FOREIGN KEY로 관리해야 합니다.

    상태값은 가능한 값의 범위를 정해야 합니다.
      예: 주문완료, 결제완료, 배송중, 배송완료, 취소

    생성일, 수정일 컬럼을 두면 데이터 추적이 쉬워집니다.
      created_at
      updated_at

    자주 검색하는 컬럼에는 인덱스를 검토합니다.
      예: email, customer_id, order_date

    삭제 정책을 미리 정해야 합니다.
      고객을 삭제할 때 주문도 삭제할지,
      주문은 남기고 고객만 비활성 처리할지 결정해야 합니다.


  ============================================================
  9. 핵심 정리
  ============================================================

    데이터베이스 설계는 업무 데이터를 테이블과 컬럼으로 바꾸는 작업입니다.

    테이블은 하나의 관리 대상을 저장합니다.

    컬럼은 그 대상의 세부 정보를 저장합니다.

    기본키는 한 행을 구분합니다.

    외래키는 테이블과 테이블을 연결합니다.

    제약조건은 잘못된 데이터 입력을 막습니다.

    1:N 관계에서는 N쪽에 외래키를 둡니다.

    N:M 관계에서는 중간 테이블을 만듭니다.

    실무에서는 테이블을 만들기 전에
    기능, 데이터, 관계, 제약조건, 조회 방식, 삭제 정책을 먼저 확인합니다.
======================================================================
======================================================================

	테이블 생성 기본 문법
    
		CREATE TABLE 생성할_테이블명(
        
			열명1  데이터_형식  [하나 이상의 제약조건들을 설정하는 자리],
            열명2  데이터_형식  [하나 이상의 제약조건들을 설정하는 자리]
            ....
			
            [테이블 제약조건 설정하는 자리]
        );
		-------------------------------------
		테이블 주요 구성 요소 
        1. 데이터_형식
			MYSQL에서 사용할수 있는 데이터 형식 종류
            숫자형  : INT, FLOAT, DOUBLE, DECIMAL 등
            문자열형 : VARCHAR, CHAR, TEXT, BLOB 등
            날짜/시간형  : DATE, TIME, DATETIME, TIMESTAMP 등 
            논리형      : BOOLEAN
        
        2. 열 제약 조건 
			열에 추가하여 데이터의 유효성을 보장하는 제약조건들입니다.
            종류
				PRIMARY KEY : 테이블 내에서 고유하고 NULL이 될수 없는 기본키 제약조건 설정 
                FORENING KEY : 다른 테이블의 기본키 제약조건이 설정된 열의 데이터를 참조하여 테이블간의 관계 설정 
                UNIQUE :   열의 모든 값이 고유해야 함 
                DEFALUT :  데이터가 INSERT 하지 않을 경우 INSERT될 기본값 설정하는 제약조건 
                CHECK   : 열의 값이 특정 조건을 만족해야 열에 값을 저장할 제약조건(MySQL 8이상 지원)
                AUTO_INCREMENT :  열의 값을 자동으로 증가 해서 열에 추가 시키는 제약조건 (주로 INT형 열에 사용)
		
        3.테이블 제약조건 
			테이블 수준에서 정의할수 잇는 제약 조건 
            
            PRIMARY KEY : 하나 이상의 열을 기본키로 설정
            FOREING KEY : 다른 테이블과의 관계를 설정 
            UNIQUE (열목록) : 여러 열의 조합이 고유해야 함
            CHECK :  특정 조건을 만족해야 함 
*/
-- 실습 순서1. 인터넷 마켓(InternetMarket) 데이터베이스 만들기 
-- 데이터베이스 만들기 
-- 방법   			CREATE DATABASE 데이터베이스명;
CREATE DATABASE InternetMarket;

-- 사용할 데이터베이스 선택
-- 방법              USE 데이터베이스명;
USE InternetMarket;
/*
	고객 정보 저장 		     -> Customers 테이블 
    제품 정보 저장 		     -> Products 테이블 
    고객이 주문한 주문정보 저장    -> Orders 테이블 
    각 주문에 포함된 제품 정보 저장 -> OrderItems 테이블 
*/
-- 실습 순서2. Customers 테이블 : 고객 정보를 저장 
CREATE TABLE Customers( --                  <-- membedr테이블과 같다.

	-- 고객 ID를 저장할 열 
    -- int 타입으로 설정하고 자동으로(AUTO_INCREMENT)기능을 사용하여 
    -- 새로운 고객이 추가될때 마다 이전 고객 ID보다 1씩 증가되어 추가되도록 제약조건 설정
    -- 기본 키(primary key)로 설정하여 고객 ID가 유일하게 저장될수 있도록 제약조건 설정 
    customer_id int auto_increment primary key,
    
    -- 고객 이름을 저장할 열 
    -- varchar타입으로 최대 100자까지 저장할 수 있게 제약조건 설정 
    -- not null 제약조건을 통해  이 열은 필수로 값을 추가(INSERT)해서 저장 해야 한다는 제약조건 설정 
    name       varchar(100) not null,
    
    -- 고객의 이메일 주소 저장할 열
    -- varchar타입으로 최대 100자까지 저장할 수 있게 제약조건 설정
    -- unique 제약조건을 통해 모든 고객의 이메일 주소가 유일해야 함을 보장할수 있음 
    -- not null 제약조건을 통해 이열은 필수로 값을 추가(INSERT)해서 저장 해야 한다는 열에 설정 
    email      varchar(100)  unique not null,
    
    -- 고객의 전화번호 저장할 열
    -- varchar타입으로 최대 20자까지 열에 저장할수 있게 설정,
    -- 이 열의 값은 필수로 추가해서 저장하지 않아도 되기떄문에 null값을 허용하게 not null제약조건을 지정하지 않았음 
    phone     varchar(20),
    
    -- 고객의 주소를 저장하는 열 
    -- varchar타입으로 최대 255자까지 열에 저장할수 있게 설정,
    -- 이 열은 필수로 저장되야 하는 열의 칸이 아니므로 null값을 허용 합니다.
	address   varchar(255),
    
    -- 고객 등록날짜와 시간을 함께 저장할 열 
    -- timestamp 데이터유형 (YYYY-MM-DD hh:mm:ss) 으로 열에 저장되게 데이터 유형 설정하고,
    -- default current_timestamp 를 통해 고객이 등록된 날짜와 시간이 자동으로 현재 시스템 날짜와 시간이 저장되게 
    -- default 제약 조건을 열에 설정 함.
    created_at timestamp  default current_timestamp
				
);
-- 실습 순서 2.1. Customers 고객 테이블 열 구조 보기
-- 방법   desc 테이블명;
desc Customers;

-- 실습 순서 2-2. Products 테이블 : 제품 정보를 저장 
CREATE TABLE Products (
	/*
		제품 아이디 저장 -> product_id열 생성 
        저장할 데이터 유형 -> int
        자동으로 1증가 하면서 추가 되게 제약조건 설정 -> auto_increment 
        제품 아이디가 유일하게 유지 되도록 설정 -> primary key
    */
    product_id int auto_increment primary key,
	
    /*
		제품의 이름 저장 -> name열 생성
        저장할 데이터 유형  -> varchar(100)
		이 열의 값은 필수로 값을 추가해서 저장 할 제약 조건 -> not null
    */
	name varchar(100) not null,
    
    /*
		제품에 대한 설명내용을 저장 -> description열 생성 
        긴 텍스트를 저장할 데이터 유형 -> text
        이 열의 값은 필수는 아니므로 null 값을 허용 합니다.
    */
    description text,
    
    /*
		제품의 가격을 저장 -> price 열 생성
        최대 10자리 숫자 중~ 소수점 아래 2자리까지 저장할수 있게 데이터 유형 -> decimal(10,2)
        이 열의 값은 필수로 추가해서 저장 -> not null 제약조건 설정 
    */
    price decimal(10,2) not null,
	
    /*
		제품의 재고 수량 저장하는 -> stock열 생성 
        정수 숫자로 저장할 데이터 유형 -> int
        이 열 값은 필수로 추가해서 저장 해야 하는 제약조건  -> not null
    */
	stock int not null,
    
    /*
		제품의 등록 날짜와 시간을 함께 저장하는 -> create_at 열 생성 
		timestamp 데이터 유형으로 설정하고, default current_timestamp  디폴트 제약조건의 current_timestamp값을 통해
        제품이 등록된 날짜와 시간을 시스템의 현재 날짜와 시간으로 추가 하게 설정 
    */
	create_at timestamp  default  current_timestamp

);

-- 실습 순서2-3. 고객이 주문한 주문정보가 저장되는 주문(Orders)테이블 생성
CREATE TABLE Orders( 

	-- 주문 ID를 저장하는 order_id열 생성
    order_id int auto_increment primary key,
    
    -- 주문을 한 고객의 ID를 저장하는 customer_id열 생성 
    customer_id int not null,
    
    -- 주문 날짜와 시간정보를 함께 저장하는 order_date열 생성
    order_date timestamp default current_timestamp,
    
    -- 주문 상태를 저장하는 status 열 생성
    -- enum 타입 (열거형 타입)으로 설정하여 'Pending', 'Shipped',   'Delivered',  'Cancelled' 중에서...
    -- 하나의 값만 status열에 저장할 수 있도록 타입을 열거형 타입으로 설정 
    -- 기본값은 'Pending'으로 설정되어, 주문 생성시 상태를 자동으로 'Pending'으로 열에 지정 했음 
    status enum('Pending', 'Shipped',   'Delivered',  'Cancelled') default 'Pending',
			     -- 보류중,     발송됨,     배송완료,      취소됨   
	/*
		참고. 외래 키(Foreign key)란?
			 외래 키는 한 테이블의 열의 데이터가 
             다른 테이블의 기본키로 설정된 특정 열의 데이터를 참조하기 위해 
             이를 통해 두 테이블 간의 관계를 설정하고, 데이터를 연결할수 있게 하는 열에 설정하는 제약조건 
    */
    -- 현재 Orders테이블의 customer_id열에 외래 키 제약조건을 설정한다
    --  Orders테이블의 customer_id열의 값은 Customers테이블의 customer_id열의 값을 참조합니다.
    --  이를 통해 Oreders테이블과 Customers테이블간의 다대 1 관계를 설정 할수 있습니다.
     foreign key(customer_id) references Customers(customer_id)
/*
FOREIGN KEY 제약조건을 열에 설정 하면? 어떤 일이 일어 나는가?

1. 고객(Customers)테이블의 customer_id열과  주문(Orders)테이블의 customer_id열의 관계 이해하기
Customers테이블에 각 고객에게는 고유한 customer_id열의 아이디가 있습니다. 
이 customer_id열의 아이디는 고객을 유일하게 식별하는 데 사용됩니다. 
이 customer_id열에는 **기본 키(Primary Key)** 제약 조건을 설정 했으며,
현재 생성하고 있는 주문(Orders)테이블에서는 customer_id라는 열에 고객의 아이디가 저장되게 하여
주문(Orders)테이블에서는 customer_id열은 **외래 키(Foreign Key)** 제약 조건을 설정 했습니다.

2. 연결고리
주문(Orders)테이블에서도 고객(Customers)테이블에 저장된 고객 정보를 참조하고 싶습니다. 
예를 들어, 어떤 주문이 어떤 고객에 의해 이루어졌는지를 알기 위해, 
주문(Orders)테이블에서도 customer_id라는 열을 만들 수 있습니다.
여기서 주문(Orders)테이블의 customer_id열의 아이디는 
고객(Customers) 테이블의 customer_id열의 아이디 데이터를 참조하는 역할을 하게 됩니다. 
이때 주문 테이블의 customer_id를 **외래 키(Foreign Key)**라고 부릅니다.

3. 어떻게 동작하나요?
외래 키로 설정된 주문(Orders)테이블의 customer_id라는 열에 저장된 아이디는 
"이 주문은 고객(Customers)테이블의 customer_id열의 아이디 3이 만든 주문입니다"라는 정보를 제공합니다.
즉, 외래 키는 주문정보과 고객정보 간의 연결을 만들어 줍니다.
주문 테이블의 customer_id가 고객 테이블에 있는 customer_id와 일치해야만 
해당 주문이 유효하다고 볼 수 있습니다. 이렇게 함으로써 두 테이블 간의 관계가 형성됩니다.

4. 데이터 무결성 유지
외래 키를 사용하면 데이터의 일관성을 유지할 수 있습니다. 
예를 들어, 고객(Customers)테이블에 고객 정보(하나의 행 데이터)가 삭제되면, 
그 고객의 모든 주문(Orders테이블에 저장된 모든 주문정보 행들)도 함께 자동으로 삭제 처리할 수 있습니다. 
이처럼 외래 키는 데이터베이스에서 정보를 안전하고 정확하게 관리하는 데 중요한 역할을 합니다.
*/    	

);
-- 실습 순서2-4. 각 주문에 포함된 제품 정보를 저장할 OrderItems테이블 생성 
CREATE TABLE OrderItems(

	-- 주문 항목 ID를 저장할 열 
    order_item_id int auto_increment primary key,
    
    -- 관련된 주문의 ID를 저장할 열 
    order_id      int not null, -- 이 열은 FOREIGN KEY로 설정되어
								-- Orders테이블의 order_id열 값을 참조합니다.
    
    -- 주문 항목에 해당하는 제품의 ID를 저장하는 열 
    product_id    int  not null, -- 이 열은 FOREIGN KEY로 설정되어
								 -- Products테이블의 product_id열 값을 참조합니다. 
    
    -- 주문 한 제품의 수량을 저장하는 열 
    quantity     int   not null,
    
    -- 주문 한 제품의 가격을 저장하는 열
    price  decimal(10,2) not null,
    
    /*
		order_id열에 대한 외래키 제약조건 설정 
        OrderItems테이블(주문 항목)의 order_id열값은 Orders테이블(주문)의 order_id열값을 참조 합니다.
        이는 주문 항목이 어떤 주문정보에 속하는지를 나타내는 중요한 연결 고리 입니다. 
        즉, OrderItem테이블의 oreder_id열값은 반드시 Orders테이블에 존재하는 유요한 order_id열값과 같아야 합니다.
        이렇게 함으로써 데이터베이스에서 잘못된 정보가 저장되는 것을 미리 방지 할수 있습니다.
        만약 Oreders테이블에서 특정 주문정보가 삭제 된다면, 그 주문정보에 관련된 모든 주문항목도 함께 
        삭제처리 할수 있도록 설정되어 있어 데이터의 일관성을 유지할수 있습니다.
    */
    foreign key(order_id) references Orders(order_id),
    
	/*
	   OrderItems테이블에 만들어져 있는 product_id열에 외래키(foreign key)제약조건 설정 
       이렇게 설정하면  OrderItems테이블에 만들어져 있는 product_id열에 대한 값은 
					Products테이블에 만들어져 PK 제약으로 설정된 product_id열에 대한 값을 참조합니다.
        이렇게 함으로써 잘못된 제품정보가 입력되는 것을 방지 할수 있습니다.
        그리고 만약 Procucts테이블에서 특정 제품이 삭제된다면, 그제품에 관련된 모든 주문항목 정보도 
        OrderItems테이블에서 행단위로 함께 삭제 되어 데이터의 일관성을 유지할 수 있습니다.
    */
	foreign key(product_id) references Products(product_id)

);

-- 실습 순서3. 더미 데이터 추가 

-- 실습 순서3-1. Customers(고객)테이블에 더미 데이터 추가 
-- 고객정보 (이름, 이메일, 전화번호, 주소)를 포함하여 5명의 고객 추가 
INSERT INTO Customers (name, email, phone, address) VALUES
('홍길동', 'hong@example.com', '010-1234-5678', '서울시 강남구'),
('김철수', 'kim@example.com', '010-2345-6789',  '서울시 송파구'),
('이영희', 'lee@example.com', '010-3456-7890',  '부산시 해운대구'),
('박준형', 'park@example.com', '010-4567-8901', '대구시 중구'),
('최지우', 'choi@example.com', '010-5678-9012', '인천시 남구');

-- 실습 순서3-2. Products(제품) 테이블에 더미 데이터 추가
-- Products (제품): 5가지 제품의 이름, 설명, 가격 및 재고 수량을 추가했습니다.
INSERT INTO Products (name, description, price, stock) VALUES
('스마트폰', '최신형 스마트폰, 128GB', 799000.00, 50),
('노트북', '고성능 게이밍 노트북, 16GB RAM', 1999000.00, 30),
('무선 이어폰', '액티브 노이즈 캔슬링 기능', 150000.00, 100),
('스마트워치', '건강 모니터링 기능이 탑재된 스마트워치', 299000.00, 70),
('태블릿', '10인치 태블릿, 64GB', 450000.00, 40);

-- 실습 순서3-3. Orders(주문)테이블에 더미 데이터 추가 
-- Order(주문) : 각 주문에 대해 고객ID, 주문 날짜, 상태를 포함하여 주문정보 추가
INSERT INTO Orders(customer_id, order_date, status) VALUES
(1, '2024-10-01 10:30:00','Pending'),
(2, '2024-10-02 11:00:00', 'Shipped'),
(1, '2024-10-03 12:15:00', 'Delivered'),
(3, '2024-10-04 14:45:00',  'Cancelled'),
(2, '2024-10-05 16:00:00',  'Pending');



-- 실습 순서3-4. OrderItems(주문 항목) 테이블에 더미 데이터 추가
-- OrderItems (주문 항목): 각 주문에 포함된 제품 정보를 입력했습니다. 
-- 각 주문과 관련된 제품 ID, 수량, 가격을 설정했습니다. 
-- 주문 order_id는 Orders 테이블에서의 order_id열의 값과 연결되도록 설정했습니다.
INSERT INTO OrderItems (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 799000.00),  -- 홍길동이 스마트폰 1개 주문
(1, 3, 2, 150000.00),  -- 홍길동이 무선 이어폰 2개 주문
(2, 2, 1, 1999000.00), -- 김철수가 노트북 1개 주문
(3, 4, 1, 299000.00),  -- 홍길동이 스마트워치 1개 주문
(4, 5, 1, 450000.00),  -- 이영희가 태블릿 1개 주문
(5, 2, 2, 1999000.00); -- 김철수가 노트북 2개 주문

-- ----------------------------------------------------------------------------------

-- 실습4. `InternetMarket` 데이터베이스의 테이블에서 사용할 수 있는 `SELECT` 문제 10개

-- 문제1. 모든 고객 정보 조회 
-- 고객(Customers) 테이블에서 고객의 정보를 조회 하는 SQL 쿼리를 작성하시오.
	select * from Customers;
	select * from products;
	select * from orders;
	select * from orderitems;
	
-- 문제2. 특정 제품 가격 조회
-- Products 테이블에서 '스마트폰'의 가격을 조회하는 SQL 쿼리를 작성하시오.
	select * from products where name='스마트폰';
-- 문제3. 고객 이름과 이메일 조회
-- 고객(Customers) 테이블에서 고객의 이름과 이메일 주소정보만 조회하는 SQL 쿼리를 작성하시오.
	select name, email from customers;
-- 문제4. 주문 상태가 'Pending'인 주문 조회
-- Orders 테이블에서 주문 상태가 'Pending'인 주문의 정보(모든열값) 조회 하는 SQL쿼리를 작성하시오.
	select * from Orders where status = 'Pending';
-- 문제5. 특정 고객이 주문한 모든 주문 정보 조회
-- 고객 ID가 1인 고객이 주문한 모든 주문의 정보를 조회하는 SQL쿼리를 작성하시오.
	select * from customers where customer_id =1; 
-- 문제6. 제품 재고가 50개 이상인 제품 정보 조회
-- Products테이블에서 재고 수량이 50개 이상인 제품의 이름과 재고 수량을 조회하는 SQL쿼리를 작성하시오.
	select name, stock from products where stock > 50;
    
-- 문제7. 주문 항목의 총 가격 조회
-- OrderItems테이블에서 각 주문 항목의 총 가격(수량 X 가격)을 계산하여 조회하는 SQL쿼리를 작성하시오.
	select(price * quantity) as '총 가격' from orderitems;
    
-- 문제8. 주문 날짜로 정렬하여 조회
-- Orders 테이블에서 모든 주문 정보를 주문 날짜 기준으로 내림차순 정렬하여 조회하는 SQL쿼리를 작성하시오. 
	select * from orders
    order by order_date desc;

 -- 문제9. 주문과 고객정보 함께 조회
 -- Orders테이블과 Customers 테이블의 열을 조인하여 각 주문의 고객이름 과 주문상태를 조회하는 SQL 쿼리를 작성하시오.
	select o.status, c.name
    from Orders o join Customers c
    on o.order_id = c.customer_id;

 -- 문제10. 특정 제품이 포함된 모든 주문정보 조회
 -- OrderItems테이블에서 '스마트폰'이 포함된 모든 주문정보를 조회하는 SQL쿼리를 작성하시오.
	select * 
    from products p join orderitems o
    on p.product_id = o.product_id
    where p.name = '스마트폰';
-- ----------------------------------------------------------------------------------
-- 실습5. `InternetMarket` 데이터베이스의 테이블에서 사용할 수 있는 `UPDATE` 문제 5개

### 문제 1: 고객 이메일 수정
-- 고객 ID가 1인 고객의 이메일 주소를 "newemail@example.com"으로 수정하는 SQL 쿼리를 작성하시오
update Customers
set email = 'newemail@example.com'
where customer_id = 1;

### 문제 2: 제품 가격 인상
-- "스마트폰"의 가격을 50,000원 인상하는 SQL 쿼리를 작성하시오. (예: 현재 가격이 300,000원이면 350,000원으로 수정)
update products
set price = price + 50000
where name = '스마트폰';

### 문제 3: 주문 상태 변경
-- 주문 ID가 2인 주문의 상태를 'Shipped'로 변경하는 SQL 쿼리를 작성하시오.
	select * from Customers;
	select * from products;
	select * from orders;
	select * from orderitems;
    
    update orders
    set status = 'Shipped'
    where order_id =2;
    
### 문제 4: 고객 전화번호 업데이트
-- 고객 ID가 3인 고객의 전화번호를 "010-1234-5678"로 수정하는 SQL 쿼리를 작성하시오.
update Customers
set phone = 010-1234-5678
where customer_id = 2;

### 문제 5: 제품 재고 수량 수정
-- "노트북" 제품의 재고 수량을 100으로 업데이트하는 SQL 쿼리를 작성하시오.
update products
set stock = 100
where name = '노트북';

 -- --------------------------------------------------------------------------------------------------------------
-- 실습6. `InternetMarket` 데이터베이스의 테이블에서 사용할 수 있는 `DELETE` 문제 5개
-- 참고. 외래 키 제약 조건으로 인해 삭제가 불가능한 상황을 다루고 있습니다.

### 문제 1: 고객 삭제
-- 고객 ID가 4인 고객을 삭제하는 SQL 쿼리를 작성하시오.
	select * from Customers;
	select * from products;
	select * from orders;
	select * from orderitems;
    
	delete from customers
    where customer_id = 4;
### 문제 2: 제품 삭제
-- 제품 ID가 2인 제품을 삭제하는 SQL 쿼리를 작성하시오.
	delete from products
    where product_id=2;

### 문제 3: 주문 삭제
-- 주문 ID가 1인 주문을 삭제하는 SQL 쿼리를 작성하시오.
	delete from orders
    where order_id = 1;

### 문제 4: 주문 항목 삭제
-- 주문 항목 ID가 3인 주문 항목을 삭제하는 SQL 쿼리를 작성하시오.
	delete from orders 
    where order_id = 1;

### 문제 5: 외래 키 제약 조건으로 인한 삭제 실패
 -- 고객 ID가 1인 고객을 삭제하려고 시도하는 SQL 쿼리를 작성하시오. 
 -- 이 고객이 주문을 한 경우, 삭제가 실패하는 이유와 해결 방법을 설명하시오.
	delete from customers
    where customer_id = 1;
 

/*
foreign key(order_id) references Orders(order_id),
foreign key(product_id) references Products(product_id)
*/