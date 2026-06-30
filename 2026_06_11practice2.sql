
create table practice_2(mem_id varchar(45) primary key, mem_name varchar(45) not null, mem_addr varchar(45) not null); 

select * from practice_2;

insert into practice_2 values('iu','아이유','서울강남구');
insert into practice_2 values('jyp', '박진영', '경기 고양시');
select * from practice_2;

select * from practice_2 where mem_name='아이유';

update practice_2 set mem_addr='부산해운대' where mem_id ='iu';

select * from practice_2 where mem_name ='박진영';

delete from practice_2 where mem_id='jyp';
-- 9번 10번 모르겠다
alter table practice_2 add mem_email varchar(45); 

select * from member;