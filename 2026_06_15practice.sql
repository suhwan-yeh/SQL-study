select * from buy;

# 1번답
select count(amount) -- 틀림. 전체 구매 수량 합계를 구해랬는데 count는 갯수를 새는거임. sum(amount)가 정답
from buy;

#2번답
select avg(price)
from buy;

#3번답
select max(price)
from buy;

#4번답
select min(price)
from buy;

#5번답
select count(prod_name) 
from buy;

#6번답 
select prod_name
from buy
group by prod_name;   -- 틀렸다고 봐야함. 상품 종류가 몇종류인지 보여달랬는데 나는 상품 목록을 보여줌
					  --  count(distinct prod_name) from buy; 가 맞음

#7번답 모르겠다
select count(mem_id) 
from buy;		 	  -- 회원이 몇명인지 보여달랬는데 내가 적은건 구매 건수를 세는거임
					  -- select count(distinct mem_id) from buy; 가 맞음
                  
#8번답
select mem_id, sum(amount)
from buy
group by mem_id;

#9번답
select group_name, sum(amount)
from buy
group by group_name;

#10번답
select mem_id, sum(price * amount)
from buy
group by mem_id;

#11번답 (null 없애고 띄우는법 알려줘)
select group_name, avg(price)
from buy
where group_name is not null   -- 
group by group_name;

#12번답
select mem_id, count(amount) as '상품종류수'
from buy
group by mem_id;					-- 회원별 구매한 상품 종류 개수를 구해라 했음 내가 구한건 구매 건수
									-- selet mem_id, count(distinct prod_name) ~~ 임
             
#13번답 
select * from buy;					-- 가장 많은 수량이 구매된 상품명을 구해라임 group_name 필요없음
select group_name, max(amount)		/*
											SELECT prod_name, amount
											FROM buy
											WHERE amount = (
												SELECT MAX(amount)
												FROM buy
											);
									*/  -- 답이거
from buy;



#14번답
select mem_id, count(*) as '구매건수'			-- 틀렸는데
from buy									-- group by를 안씀 ㅋ
group by mem_id;


#15번답
select mem_id, max(price)					-- 문제는 구매 금액이 가장 큰 회원임. 
from buy;									-- 내가 적은건 가장 비싼 상품 가격을 찾는거임
											-- 정답은 회원별 구매금액을 먼저 구해야함.
/*
SELECT mem_id, SUM(price * amount) AS 총구매금액
FROM buy
GROUP BY mem_id
ORDER BY 총구매금액 DESC;
*/                        -- 이게 정답



# 1번답
create table student(
	student_id int primary key,
    student_name char(20),
    age int
);

#2번답
create table product(
	product_id int primary key auto_increment,
    product_name char(30),
    price int
);

#3번답
insert into student values(1, '김철수', 20);

#4번답
insert into student values(2, '이영희', 21),(3, '박민수', 22);

#5번답
create table student_backup(
	select*from student

);                          -- insert into student_backup select * from student; 이게정답

#6번답 ??
#7번답
select*from student;
update student 
set student_name='호날두'
where student_name='김철수';

#8번답
select*from world.city_popul;
use world;
update city_popul
set city_name='Busan', population = 10
where city_name='Kabul';

#9번답 모르겠다
use sys;
select*from student;
delete from student
where student_id = 1;

#10 toy 가 없어



#1번답
select*from student;

create table member_backup(
	student_id int primary key,
    student_name char(20),
    age int
);
insert into member_backup select * from student;
select*from member_backup;

#2번답 
create table users(
	id int primary key,
    name varchar(20),
    age int
);

insert into users(id, name, age) values(10, 'messi', 38);
-- 같은 id가 있으면 수정해라고 했음
-- insert into user(id, name, age)
--             values(10, 'messi', 38)
--  		   on duplicate key update name = 'Lionel Messi' , age=38;
-- 이게 정답임.

#3번답 블랙핑크가 없어
select *from student;
update student 
set age=9
where age='21';

#4번답 
use world;
select city_name from city_popul;
update city_popul
set city_name = '파리', population = 0
where city_name = 'Paris';

#5번답
use sys;
select * from student where student_id = 3;
delete from student
where student_id=3;

select * from users;
insert into users values(1, 'Alice', 27);

insert into users(id, name, age) values(1,'Alice',27)
on duplicate key update name='Alice Update', age=27;










