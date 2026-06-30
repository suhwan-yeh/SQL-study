-- 한줄 주석
# 한줄 주석 
/*
여러줄 주석
여러줄 주석
여러줄 주석
여러줄 주석*/

# 현재 MySQL DBMS 서버에 만들어져 있는 데이터베이스 목록 보기 명령
show databases;

-- 사용할 데이터베이스 선택 명령
-- 작성 문법 :   use 사용할 데이터베이스명;
use world;

create table member (meber_id varchar(20) primary key, member_addr varchar(20));


/*
	특정 테이블에 저장된 모든 열의 데이터들을 조회(검색)
    문법
    - select * : 조회할데이터가_저장된_열명1, 열명2, 열명3
		+ from : 조회할_테이블명
		+ where : 조건값이_저장된_열명 = 조건값;

	요약 : member 테이블(표)에 저장된 member_id, member_addr 열 세로 방향의 각칸에 저장된 값 조회
*/
	select * from member;
    desc member;
    select meber_id, member_addr from member;
    
    -- 실습6. 관계(비교) 연산자 기호(<= >= < >)
    --  memeber테이블에서 회원 그룹 평균키들 중에서
    -- 데이터가 162 이상인 회원그룹의 아이디들 회원그릅명들 조회
    
    select * from member;
select mem_id, mem_name from member where height >= 162;

# 실습 7
-- member table에서 회원그룹 평균키 165
-- 그룹 인원(mem_number)


select * from member where height>=165 and mem_number>6;
select * from member where mem_number >6;
select * from member where height;
select * from member where mem_number; 
select * from member;

select * from member where height>=165 or mem_number > 6;
select mem_name, height, mem_number from member where height>=165 or mem_number>6;

select mem_name, height, mem_number from member where height between 163 and 165;

select mem_name, height, mem_number from member where height >= 165 or mem_number > 6; 

select mem_name, addr from member where addr ="전남" or addr= "경남" or addr="경기";

select mem_name, addr from member where addr in('경기','전남','경남');

select * from member;

select * from member where mem_name like'여%';

select * from member where addr like'전%';


select * from member where mem_name like'%이%'; 

select * from member where mem_name like'%친구';

/*
	select * from 테이블명 where 조건열명 > (select * from 테이블명 where 조건열명 = 조건열값들과 비교할값)
    
*/
# 서브쿼리 사용하지 않고 두개의 select 문장 사용 ㄱㄱ
# 문제 회원 그룹명이 에이핑크인 회원그룹의 평균키보다 ~ 큰 ~ 그룹 회원의 그룹이름과 그룹평균키 조회하고싶음
	# 순서 에이핑크 그룹의 평균키 164 조회 ㄱㄱ
    # 에이핑크 그룹의 평균키는 순서1. 에서 조회 했으므로 164
    # where 조건절의 조건값 자리에 164를 대입해서 164보다 큰~ 그룹의 이름과 평균키 조회 ㄱㄱ
select height from member where mem_name='에이핑크';

select mem_name, height from member where height > 164;

# 이제 서브쿼리 사용 ㄱㄱ
# 문제. 회원 그룹명이 에이핑크인 회원그룹의 평균키보다 큰 그룹회원의 그룹이름과 그룹평균키 조회 ㄱㄱ
select mem_name, height from member 
where height > (select height from member 
				where mem_name='에이핑크');
                
# --------------------------------------------------------------------------
# 연습문제
# 1번. 회원테이블에서 모든 회원의 id와 그룹이름 조회 ㄱㄱ
select mem_id, mem_name from member;

# 2번. 회원테이블에서 그룹회원의 평균키가 167이상인 그룹회원의 모든 열의 정보 조회
select * from member where height >=167;

# 3번. 회원테이블에서 그룹인원수가 5명 이하인 그룹의 이름과 인원수 조회
select mem_name, mem_number from member where mem_number <= 5;

# 4번. 구매테이블에서 상품 가격이 100이상인 구매한 상품의 이름과 가격을 조회
select * from buy;
select prod_name, price from buy where price>100;

# 5번. 회원테이블에서 주소가 '경기'인 회원그룹의 모든 열정보를 조회 
select * from member;
select * from member where addr='경기';

# 6번. 구매테이블에서 '패션' 분류의 상품 이름과 구매수량 조회
select * from buy;
select prod_name, amount from buy where group_name='패션';

# 7번. 회원테이블에서 '서울'에 사는 그룹회원 이름과 전화번호(국번, 뒷번호 모두 포함) 조회
select * from member;
select mem_name, phone1, phone2 from member where addr='서울';

# 8번. 회원 테이블에서 그룹명이 '트와이스'인 그룹 회원의 모든 열정보 조회
select * from member where mem_name='트와이스';

# 9번. '블랙핑크'라는 이름을 가진 그룹회원이 구매한 모든 제품의 정보(모든열값)을 조회 -----    (서브쿼리사용)
select * from buy;
select * from member;
select mem_id from member where mem_name = '블랙핑크';
select * from buy where mem_id =(select mem_id from member 
								 where mem_name='블랙핑크');

# 10번. 회원 테이블에서 그룹 인원수가 8명인 그룹의 모든 열정보를 조회
select * from member;
select * from member where mem_number=8;

# 11번. 구매 테이블에서 구매한 상품이름에 '지갑' 단어가 포함된 상품의 모든 열정보를 조회
select * from buy;
select * from buy where prod_name='지갑';

# 12번. 회원 테이블에서 평균키가 165cm 이하인 그룹의 이름과 평균키 조회 
select * from member;
select mem_name, height from member where height <165;

# 13번. 회원 테이블에서 '여자친구' 또는 '트와이스' 그룹이름가진 모든 열정보 조회
select * from member;
select * from member where mem_name in('여자친구','트와이스');

# 14번. 구매 테이블에서 구매한 제품 수량이 3이상인 상품의 이름과 가격을 조회
select * from buy;
select prod_name, price from buy where amount>=3;

# 15번. 회원 테이블에서 사는지역이 '강남'인 회원의 이름과 주소 조회
select * from member;
select mem_name, addr from member where addr='강남';

# 16번. 구매 테이블에서 '디지털' 분류의 상품 중 가격이 200이하인 구매한 상품의 이름 조회
select * from buy;
select prod_name from buy where price<200 and group_name='디지털';

# 17번. 회원 테이블에서 그룹 평균키가 162cm 이상인 그룹의 이름 조회
select * from member;
select mem_name from member where height>162;

# 18번. 구매 테이블에서 특정그룹('블랙핑크')의 구매 내역에서 가격이 50이상인 구매한 상품의 모든열 정보 조회 서브쿼리 사용
select * from buy;
select * from buy where price >= 50 and mem_id =(select mem_id from member 
											    where mem_name ='블랙핑크');

select * from member;
# 1번 답
select max(height) from member where height;
select * from member;
# 2번 답
select * from member where addr=(select addr from member where mem_name='에이핑크');
# 3번 답
#?
# 4번 답

# -----------------------------------------------------------------------
-- 03-2절 조금 더 깊게 알아보는 select 문
-- -----------------------------------------------------------------------
/*
	order by 절
		- 최종 조회 시 특정 열의 값을 기준으로 내림 차순 또는 오름 차순 정렬해서
		   조회 하는 예약어
		- 문법
				select * from 조회할 테이블명
                where 조건식
                order by 정렬할 데이터가 저장된 열명 asc 또는 DESC;
		- asc란?
			Ascending의 약자로 오름차순 정렬 의미
		- Desc란?
			Descending의 약자로 내림차순 정렬 의미
*/
select * from member;
# 실습1. 그룹 회원의 데뷔일자(debut_date열에 저장된 날짜)를 기준으로
# 		오름 차순 정렬(데뷔일자가 빠른순)하여 조회시 order by 절을 사용
select * from member order by debut_date asc;

# 실습2. 그룹 회원의 데뷔일자를 기준으로
#  		오름 차순 정렬(데뷔일자가 빠른순)하여 조회시 order by 절을 사용
select * from member order by debut_date desc;

# 실습3. order by 절과 where조건절 함께 사용 ㄱㄱ
# 그룹 평균키 (height열에 저장된 데이터)가 164 이상인 그룹회원들의 키가 큰 순서대로 내림차순정렬
# 그룹명(mem_name열에 저장된 데이터), 그룹아이디(mem_id열에 저장된 데이터들), 그룹평균키(height열에 저장된 데이터)
# 데뷔날짜(debut_date열에 저장된 데이터) 조회 ㄱㄱ
select mem_name, mem_id, height, debut_date from member where height>=164 order by height desc;

# 실습4. order by절과 where조건절 함께 사용 ㄱㄱ
# 			(정렬 조건 하나 이상 설정가능)
# 그룹 평균키가 큰 순서대로 조회
# 같은 평균키를 가진 그룹들이 있으면, 데뷔일자가 빠른순서대로 정렬
select mem_name, mem_id, height, debut_date from member where height >= 164 
order by height desc, debut_date asc;

# ---------------------------------------
-- limit 예약어 : 테이블 전체 행(row, 레코드) 중에서
-- 				원하는 행의 갯수를 정해서 조회할때 사용하는 예약어
/*
	문법
		select * from 조회할 테이블명 
        where 조건식
        order by 정렬할 데이터가 저장된 열명 asc or desc 
        limit 조회할 행의 갯수 숫자로 작성;
*/
select * from member limit 3; # 0,3 같은 의미로
							  # 0 index 부터 시작해서 index 3개 가꼬와라 이말임 

# 실습5. member테이블에서 전채 행 데이터들 중에서 3개의 행만 조회
select * from member limit 3;

#실습6. member 테이블에서 회원그룹평균키가 큰 순(desc)로 정렬해서 조회하되,
# 	   정렬해서 조회한 결과 데이터들 중에서 
#	   3 index위치 행의 레코드부터 2개의 행만 잘라서 조회
select * from member order by height desc limit 3,2;
select * from member;

# distinct 예약어 : 조회할 열의 데이터들이 중복되서 같은 이름의 데이터로 조회되면?
-- 				  중복된 데이터를 1개만 남기고 1개로만 조회시키는 예약어.
-- 				  중복된 열의 데이터가 저장되어 있으면 하나로 조회하는 예약어.
/*
	문법
		select distinct 조회할 열명
        from 조회할 테이블명
        where 조건식
        order by 정렬기준데이터의 열명 정렬방식 
        limit 숫자;
*/

# 실습8, 모든 그룹회원의 사는 지역 조회
select addr, mem_name from member;

# 실습8-1 order by절을 사용해 같은 지역에 사는 주소들 기준으로 오름차순 정렬 조회
select addr, mem_name from member order by addr asc;

# 실습 8-2 distinct 사용해서 열에 중복된 데이터를 하나로 통일해서 하나의 데이터만 조회
select distinct addr from member order by addr asc;
-- ---------------------------------------------------------------------------
/*
		group by절
			group by절은 데이터 베이스에서 데이터를 그룹으로 묶어서 조회하는데 사용되는 예약어.
			-예를들어, 같은 날짜에 해당하는 데이터들을 하나의 그룹으로 묶어 관리 가능
			-group by절은 보통 sum,count,avg 같은 집계함수와 함께 작성해서 사용
        
        문법
			-select 열명1, 집계함수명(열명2)
            from 조회할데이터명
            group by 그룹으로 묶을 같은 데이터가 저장된 열명
            having 조건식 
            order by 정렬기준열명 정렬방식
            limit 숫자;
            
		제공 해주는 집계함수들
			-sum() : 열명을 sum(열명)으로 지정하면 열에 저장된 데이터들을 합계하여 반환해준다
            -avg() : 열명을 avg(열명)으로 지정하면 열에 저장된 데이터들을 평균을 구해서 반환해준다
            -min() : 열명을 min(열명)으로 지정하면 열에 저장된 데이터들 중에서 최소 작은데이터로 반환해줌
            -max() : 열명을 max(열명)으로 지정하면 열에 저장된 데이터들 중에서 가장 큰 데이터로 반환해줌
		 -count(*) : 모든 열에 관한 행 갯수 반환 해줌
  -count(distinct) : 행의 갯수를 센다. (중복 데이터 1개만 인정)
*/


select * from buy;
#실습9 'buy' 테이블에서 각mem_id(구매한 그룹회원 아이디)별로 총 구매 수량을 
#      계산해서 계산한 총 구매 수량과 각회원 그룹아이디 조회

#순서1. 각 회원 그룹단위로 한번 상품 구매시 구매한 수량 조회
select mem_id as '그룹 아이디', amount as '구매한 수량' from buy;

#순서2. 각 회원 그룹 아이디 단위로 묶어서 한번만 조회된 그룹아이디로 표시하되 
#      (group by 그룹으로 묶을 같은데이터가 저장된 열명)을 이용해서 
#	    그룹 아이디 단위로 조회되게 묶어서 조회 시키자
 select mem_id as'그룹아이디' from buy;

#순서3. group by mem_id; 를 끝에 작성해 mem_id 열에 
#	   세로 뱡향으로 저장된 아이디를 하나의 그룹으로 묶어서 하남나 조회되게 시켜보자
select mem_id as'그룹아이디' from buy group by mem_id;

#순서4. 'buy' 테이블에서 각 mem_id(그룹 회원아이디)별로 총 구매 수량을 계산해서
#	   계산한 총 구매 수량과 같이 조회하기 위해 추가! 
#	   이때 sum이라는 집계함수 작성하여 amount열에 조회되는 모든 행 위치의 열값들을 추출해
#	   + 모든 합계 한 회원 그룹 아이디 별 총 구매 수량을 조회하면 같이 볼 수 있음.
select mem_id as'그룹아이디', sum(amount) as '총_구매수량' from buy group by mem_id;
select * from buy;

#실습11. 전체 회원그룹이 구매한 총 구매 수량과 평균을 구해서 조회된 결과를 보여주자.
select * from buy;
select avg(amount) as '전체 회원 그룹의 구매한 평균 상품 수량' from buy;

#실습12. 각~ 회원그룹들이 한번 구매시 몇개의 상품을 각각 구매했는지 평균 구매 갯수 조회
#참고. 각~ 회원그룹들을 식별한 유일한 고유값은 mem_id열에 저장된 그룹id를 그룹으로 묶어 주자
select mem_id as '회원그룹 아이디', avg(amount) as '평균 구매 횟수' from buy group by mem_id;

#실습13. member 테이블에 저자오딘 그룹회원의 전체의 행의(레코드, row)의 갯수 조회
select count(*) as '전체 행 갯수' from member;

#실습13-1. member테이블에서 연락처(phone1, phone2열에 저장된 데이터들)가
#         저장되어 있는 그룹의 그룹회원의 레코드(행) 갯수만 조회
select count(phone1) '연락처가 저장되어 있는 그룹 행의 수' from member;

-- -----------------------------------------------------------------
-- having 조건절
-- 		where 조건절 대신 그룹으로 묶어준 데이터의 조건검사하는 구문

#문법 
#	select 열명1, 집계함수(열명2) from 테이블명
#	group by 그룹으로 묶을 같은 데이터가 저장된 열명
#	having 조건식
#	order by 정렬기준 데이터가 저장된 열명 정렬방식

#실습 14. buy테이블에서 조회.
#		회원 그룹 아이디를 그룹으로 묶어서
#		회원 그룹 아이디 별로 총 구매금액과 그룹아이디열의 데이터 조회
select mem_id as'회원 그룹아이디', sum(price * amount) as '총 구매금액'
from buy
group by mem_id;

#실습 14-1. 만약 그룹아이디별로 총 구매한 금액이 1000이상이면 사은품 증정 계획
#그룹 아이디별로 총 구매한 금액이 1000이상인 그룹의 총구매금액, 그룹아이디를 조회함.
select mem_id as '회원그룹 아이디', sum(price * amount) as '총 구매금액'
from buy
group by mem_id
having sum(price * amount) >= 1000;

select * from buy;


#실습 14-2.만약 그룹아이디별로 총 구매한 금액이 1000이상이면 사은품 증정 계획
#그룹 아이디별로 총 구매한 금액이 1000이상인 그룹의 총구매금액, 그룹아이디를 조회함.
#총 구매 금액이 다 다를 수도 있으니 사은품이 다를 수 있기때문에
#총 구매 금액이 큰 순서대로 내림차순정렬 하여 최종조회
select mem_id as '회원그룹 아이디', sum(price * amount) as '총 구매금액'
from buy
group by mem_id
having sum(price * amount) >= 1000 
order by sum(price * amount) desc;

-- -----------------------------------------------------------------
-- 연습-----------------------------------------------------------------
-- 1. 회원 그룹수 (count)
-- 	  회원 그룹 테이블의 총 그룹회원(행,레코드) 수를 계산해서 조회
select count(*) from member;

-- 2. 평균 인원수(avg)
-- 	  회원 그룹테이블의 그룹 평균 인원수 계산해서 조회
select * from member;
select avg(height) from member;

-- 3. 최대 평균키(max)
--    회원그룹 테이블에서 가장 키가 큰 그룹회원의 평균키 조회
select max(height) from member;

-- 4. 최소 평균키(min)
-- 	  회원그룹 테이블에서 가장 키가 작은 회원그룹의 평균키 조회
select min(height) from member;

-- 5. 구매 수량의 총합(sum)
-- 	  구매 테이블에서 모든 구매 수량의 총합 조회
select sum(amount) from buy;

-- 6. 각 회원별 구매 수량의 총합
-- 각 회원별로 구매한 총 수량을 계산합니다. mem_id로 그룹화하여 각 회원의 총 구매 수량 조회
select mem_id, sum(amount) 
from buy
group by mem_id;

-- 7. 각 제품의 평균 가격(avg)
--    구매한 각 제품별 단가(가격)의 평균을 계산해서 계산한 평균값 조회되게 하기.
-- 참고. 제품 이름으로 그룹화하여 평균 가격을 구한다.
-- 즉, 특정 제품이 여러번 구매되었을때,
-- 그 제품의 가격을 모두 더한 후 구매 횟수로 나누어 평균 가격을 계산한다.
select prod_name, avg(price)
from buy
group by prod_name;
; \\


-- 8. 특정 지역의 그룹 회원 수(count)
-- 각 사는 지역별 그룹명, 그룹회원 수 조회.
-- 참고. 지역 주소로 그룹화하여 각 지역의 회원그룹 수를 구합니다.
select addr, count(*) 
from member
group by addr;

-- 9. 구매한 제품의 종류 수(count distinct)
-- 구매 테이블에서 구매한 제품의 종류 수를 계산합니다. 구매 제품 이름에 중복을 제거하여 고유한 제품수 구한다.
/*
	흐르미야
    1.구매 데이터 조회 : buy 테이블에서 다 가져온다
    2.중복 제거 : prod_name 열에서 중복된 제품 이름 제거하여 고유한 제품 이름만 남긴다
    3. 고유 제품 수 계산: 남은 고유한 제품 이름의 수를 세어  unique_products라는 이름으로 결과 반환
*/
select count(distinct prod_name) as unique_products 
from buy;
select * from buy;

-- 10. 구매 테이블에서 상품 분류별 총 구매 수량을 조회.
-- ex) 디지털 분류 전체 구매 수량, 패션 분류 전체 구매수량.
select group_name, sum(amount) as 'total_price'
from buy
group by group_name;

-- 11. 구매 테이블에서 상품 분류별 평균가격을 조회 하시오.
-- 	   단, 상품 분류가 null인 데이터는 제외
select group_name ,avg(price)
from buy
where group_name is not null
group by group_name ;


-- 12. 구매 테이블에서 회원별 구매 건수를 조회 하시오.
-- 	   구매 건수란 buy 테이블에 저장된 구매 기록의 갯수를 의미한다.
select * from buy;
select mem_id,count(amount)
from buy
group by mem_id;

-- 13. 구매 테이블에서 회원별 총 구매 금액을 조회하시오
-- 		총 구매 금액은 (가격 * 수량)으로 계산하시오.
select mem_id, sum(price * amount)
from buy
group by mem_id;

-- 14. 구매 테이블에서 상품별 총 판매 금액을 조회 하시오
-- 	   총 판매 금액은 가격 * 수량 으로 계산 
select prod_name, sum(price * amount)
from buy
group by prod_name;
-- ----------------------------------------------------------------------------------
-- 03-3절. 데이터 변경을 위한 sql문
-- -----------------------------------------------------------------------------------
/*
	주제 :
     데이터베이스 내부에 만든 특정 테이블에 데이터르 추가(입력) / 수정 / 삭제 하는 sql문 ㄱㄱ
		- insert 문 : 테이블에 새로운 행 데이터를 추가(입력)해서 저장할때 사용되는 sql문 중 하나
			insert 작성방법
			insert into 테이블명(추가할값이 저장될 열명1,      열명2           ,      열명3)
						values(열명1에 추가할 값1,    열명2에 추가할 값2,      열명3에 추가할 값3);
			insert into 테이블명(열명1, 열명2, 열명3) values(값1, 값2, 값3)
*/
use market_db;
# hongon1 이라는 이름의 테이블 생성
/*
	테이블 생성문법
    create table 생성할 테이블명(
    
		생성할 열명1 	열1에 저장할 데이터 유형,
        생성할 열명2 	열2에 저장할 데이터 유형,
        .....
*/
create table hongon1(

toy_id int, 
toy_name char(4),
age int

);
select * from hongon1;
# hongon1 테이블에 하나의 행(row,레코드)을 추가하여 저장
insert into hongon1 values(1, '우디', 25);

# hongong1 테이블에 toy_id 열과 toy_name 열에만 데이터를 추가하여 저장할 값 넣자
insert into hongon1(toy_id, toy_name) values(2,'버즈');

-- hongon1 테이블에 열명의 순서를 바꿔서 추가로 행을 저장
-- 주의할점은 테이블명()사이에 작성한 열명의 순서에 맞게 values()사이에 저장할값 넣어서 추가 ㄱㄱ
insert into hongon1(toy_name,age,toy_id) values('제시', 20, 3);

-- hongon1 테이블에 (열명~ 열명~ 열명~) 생략가능
-- values(열 추가값1, 열 추가값2, 열 추가값3) 구문만 작성해 새로운 행 데이터 추가 가능
-- 단! 주의 할점은 테이블 생성시 작성한 열명 순서에 맞게 추가할값들을 작성해야한다.
insert into hongon1 values(4, '영구', 30);

select * from hongon1;
delete from hongon1 where toy_id= 4;

/*
	auto_increment 예약어
    - 테이블을 새로 생성할때 열이름 뒤에 설정하는 예약어로
	  열에 대한 값을 insert문장으로 추가하지 않아도
      자동으로 1씩 증가되면서 추가가 되게하는 예약어.


*/

create table hongon2(
	toy_id int auto_increment primary key, 
    toy_name char(4),
    age int

);
# hongon2 테이블에 자동으로 toy_id 열에 대한 값을 자동으로 1증가해서 들어가는 데이터를
# null 값으로 채워놓고 데이터 추가함

insert into hongon2 values(null, '보핍', 25);
select*from hongon2;

insert into hongon2 values(null,'슬링키',22);
insert into hongon2 values(null,'렉스',21);

/*
	toy_id열에 추가할 값을 작성하지 않고, 다른 열의 값만 추가 시키면
    auto_increment 제약조건 예약어를 설정 해 놓은 toy_id 열의 값은 자동으로 증가

*/
insert into hongon2(toy_name, age) values('맹구','100');

/*
자동으로 증가된 값이 얼마인지 확인하는 구문
*/

-- select last _insert_id() as 'toy_id열에 추가된 최근값';

/*
auto_incremet 제약조건을 지정한 열은 1부터 추가가 되기때문에
특정 값 부터 추가되게 하기 위해 auto_increment 제약조건의 속성의 값을 설정
*/
alter table hongon2 auto_increment = 100; -- 초깃값 100으로 설정
										  -- 초기 100부터 1씩 증가되어 추가되도록 설정
insert into hongon1(toy_name, age) values('재남',35);

/*
auto_increment 제약조건을 지정한 열은 100부터 1씩 증가되어 추가
하지만 3씩증가는 103, 106, 109 형태로 증가 시킬 수 있게
@@auto_increment_increment 변수 값을 변경 ㄱㄱ
*/
create table hongon3(
	toy_id   int auto_increment primary key,
    toy_name char(4),
	age      int
);
-- auto_increment 의 자동 증가 시작되는 값을 1000으로 설정
alter table hongon3 auto_increment = 1000;

-- auto_increment 는 1000부터 1씩 증가함
-- 3씩증가하게 만들고 싶으면?
set @@auto_increment_increment = 3; -- 추가할때마다 자동으로 3증가식 
insert into hongon3 values(null,'토마스',20);
insert into hongon3 values(null,'제임스',23);
insert into hongon3 values(null,'고든',25);

insert into hongon3(toy_name, age) values('개똥이',100);
insert into hongon3(toy_name, age) values('똘똘이',5);

/*
	insert into ~ select
    - 특정 테이블 select구문을 이용해 조회한 표 형태의 결과 데이터들을 
	  insert into 문장을 이용해 테이블에 행의 데이터들을 한번에 추가시키는 구문
	- 문법
	  insert into 테이블명(열명1, 열명2, 열명3) select 열명1, 열명2, 열명3 from 테이블명;
*/
-- world 데이터베이스 사용을 위한 선택 ㄱㄱ
use world;

-- world 데이터베이스 내부에 만들어져 있는 테이블 목록 조회
show tables;

-- world 데이터베이스 내부에 만들어져 있는 city 테이블 행의 총 개수 조회
select count(*) as '총 햇 갯수' from city; -- 4079 행 데이터들
select * from city;

-- city 테이블에 저장된 전체 행(레코드) 조회
select * from city;

-- city 테이블에 어떤 열이 어떤구주로 설정되어 만들어져 있는지 열의 구성을 확인하는 구문
-- 문법 desc 테이블명;
desc city;

-- city 테이블에 저장된 전체 4079행 데이터 중에서
-- 5개의 행데이터만 조회하자 

select * from city limit 0,5;

-- city 테ㅣ블에 저장된 도시명과 인구를 조회해서 저장할 city_pouple 테이블 생성하기
create table city_popul(

	city_name char(35),
    population int
);

select * from city_popul;
insert into city_popul(city_name, population) select name, population from city;

select count(*) from city_popul;

-- 1. 테이블생성
create table users(
	id int auto_increment primary key,
    name varchar(50),
    age int
);

-- 2. 단일 행 삽입 예제
--	  user 테이블에 한 명의 행 데이터 삽임
insert into users(name, age) values('Alice',25);
select * from users;

-- 3. 다중 행 삽입 예제
insert into users(name, age) values('Bob', 30),
								   ('Charlie', 35),
								   ('Diana', 28);
select * from users;

-- 4. select를 사용한 데이터 삽입
-- 	  다른 테이블에서 데이터를 조회해서 users테이블에 삽입하는 예제
-- 	  예를 들어 new_users테이블이 있다고 가정.

create table new_users(
	name varchar(50),
    age int
);
-- 일단 new_users 테이블에 데이터가 하나도 없으므로 다중 행 추가 해놓자
insert into new_users(name, age) values('Eve', 26), ('frank', 29);

-- new_users 테이블에서 select 구문을 이용해서 조회한 name열의 값과 
-- age 열에 대한 값을 users 테이블에 insert 구문을 이용해서 삽입.
insert into users(name, age) 
select name, age from new_users
where age > 25;

select * from users;

-- 5. on duplacate key update 예제.
-- 	  id 열에 저장된 값이 중복되는 경우는 같은 1을 넣으면 insert 되지 않는다.
-- 	  그럴 경우 name 열과 age열의 값만 변경하고 싶을때 on duplcate key update 구문 사용
insert into users(id, name, age) values(1, 'Alice', 27)
 on duplicate key update name = 'Alice Update', age = 27;
 
 /*
	정리
		테이블 조회해서 가져온다. select 구문
        테이블 새 행 데이터 추가. insert 구문
        테이블 열에 저장된 값만 수정. update 구문
        테이블에 행 데이터 삭제. delete 구문
 */
/*
	update 구문
		- 테이블에 이미 저장되어 있는 열의 데이터를 수정하는 sql문
        - 문법
			update 테이블명 set 바꿀 열명 = 수정할 값1, 열명2 = 수정할값2, .......
            where 조건식;
            
            
            update 테이블명 
            set 수정할 열명 = 수정될 값
            where 조건식;
*/
-- city_popul 테이블에 저장된 도시이름이 'Seoul'인 모든 데이터 조회
select * from city_popul where city_name='Seoul';
update city_popul 
set city_name = '서울'
where city_name = 'Seoul';

select * from city_popul where city_name='서울';

-- city_popul 테이블의 city_name 열에 저장된 데이터가 'New York'을 '뉴욕'으로 수정하고 동시에
-- 				     population열에 저장된 인구수를 0으로 수정
-- 조건 : city_name 열에 저장된 데이터가 'New York'인 열의 값이면 위 2가지 정보를 수정

-- 순서1. 수정할 데이터 조회를 해볼것
select * from city_popul where city_name='New York';
update city_popul
set city_name='뉴욕'
where city_name='New York';

update city_popul
set population = 0
where city_name = '뉴욕';

select * from city_popul where city_name='뉴욕';

-- city_popul 테이블에 저장된 모든 행의 열 인구수를 10000으로 나눈 계산된 값들을 
-- population열의 값들로 수정

update city_popul 
set population = population / 10000;

select * from city_popul;

-- 영구반영(commit)인한 update구문 취소(되돌리기)하는 구문
rollback; 

-- population 열의 값들 수정되기 전상태 조회
select * from city_popul; 

-- ----------------------
/*
	delete 문 
		- 테이블에 저장된 행 단위로 데이터를 삭제하는 sql문 중 하나
        - 문법
			delete from 삭제할 행이 저장된 테이블명
            where 조건식;
*/
-- 도시 이름이 new라는 단어로 시작하는 행 삭제 ㄱㄱ
select * from city_popul where city_name like 'NEW%'; 
delete from city_popul
where city_name like 'New%';

select count(*) from city_popul;

-- --------------------------------------------------------
/*
	대용량의 데이터가 저장된 테이블을 삭제하기 위한 실습 준비
    
    대용량 데이터를 저장하기 위해 일단 테이블3개 준비
    방법 : 대용량의 데이터들이 저장된 테이블을 select 구문으로 조회해 와서
		  create구문을 이용하여 총 3개의 테이블을 생성
*/
-- 외부데이터 베이스명
create table market_db.big_table3(

	select*from world.city, sakila.country

);

select *from world.city, sakila.country;
select * from big_table1;
select count(*) from big_table1;
desc big_table1;

-- delete : 테이블에 저장된 행 단위 데이터 삭제하는 sql문
delete from market_db.big_table1;

-- drop : 테이블 자체를 삭제하는 sql문
drop table market_db.big_table2;
-- truncate : 테이블에 저장된 행 단위 데이터 삭제하는 sql문
--            but, where 조건식과 같이 작성 x 
-- 			  조건식 없이 전체 행을 삭제 해야 할때만 truncate 문 사용
-- 문법
-- 	truncate table 삭제할 테이블명;
truncate table market_db.big_table3;

-- 모든 행이 삭제 되었는지 확인을 위해 조회
select * from market_db.big_table3;


-- -----------------------------------------
-- 04-1절 mysql의 데이터 형식
-- -----------------------------------------
-- 주제
-- 	데이터 형식(유형)
use market_db;
create table hongong4(
	tinyint_col tinyint, -- 정수 127까지 열에 저장 가능
    samllint_col smallint, -- 양수 32767까지 열에 저장 가능
    int_col 	int, 	 --  정수 대충 21억까지 저장 가능
    bigint_col 	 bigint   --  정수 약 900 경까지 저장가능
);
-- insert 구문 이용하여 hongong4테이블에 새로운 행 추가
insert into hongong4(tinyint_col, samllint_col, int_col, bigint_col)
			   values(     127,      32767,    2147483647, 90000000000000000);
select * from hongong4;

-- 각 숫자에 1을 더해서 추가 ㄱㄱ
insert into hongong4(tinyint_col, samllint_col, int_col, bigint_col)
			   values(     128,      32768,    2147483648, 90000000000000001);

-- netflix_db 데이터베이스 생성
-- 데이터베이스 생성 문법
-- create database 생성할데이터베이스명
create database netflix_db;

use netflix_db;

-- 데이터베이스 내부에 영화정보 저장하기 위한 movie 테이블생성

create table movie(
	movie_id 		int,
    movie_title 	varchar(30),
    movie_director 	varchar(20),
    movie_str		varchar(20),
    movie_srciper	longtext,	-- 텍스트파일 최대 4gb
    movie_film		longblob	-- 동영상파일 최대 4gb
);
select * from movie;
insert into movie(movie_id, movie_title ,movie_director, movie_str, movie_srciper, movie_film)
values(
1,
'기생충',
'봉준호',
'★★★★★',
'제시카 외동딸 일리노이 시카고, 과선배는 김진모 그는 네사촌..',
'binary_movie_1'
);

insert into movie(movie_id, movie_title ,movie_director, movie_str, movie_srciper, movie_film)
values(
2,
'부산행',
'연상호',
'★★★★☆',
'아빠, 가지마...(좀비)으악',
'binary_movie_data_2'
);

insert into movie(movie_id, movie_title ,movie_director, movie_str, movie_srciper, movie_film)
values(
3,
'올드보이',
'박찬욱',
'★★★★★',
'웃어라, 온 세상이 너와 함께 웃을것이다. 울어라,너 혼자만 울것이다',
'binary_movie_data_3'
);

insert into movie(movie_id, movie_title ,movie_director, movie_str, movie_srciper, movie_film)
values(
4,
'오징어게임',
'황동혁',
'★★★★★',
load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/squid_game_sub.txt'), -- 실제 자막 파일 경로 작성해서 자막 내용 불러오기
load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/squid_game.mp4')
);

-- load_file()을 사용하려면 db서버의 secure_file_priv 설정이 허용된 경로에 파일이 위치해야함
show variables like 'secure_file_priv';






























    