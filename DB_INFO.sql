/*
	MySQL DMBS 에서
    1. 사용자 계정 만들기
    2. 데이터베이스 만들기
    3. 만든 사용자 계정에 데이터베이스 사용권한 주기
    4. 권한 정보 새로 고침
    5. 권한 정보 확인
    6. 사용자 계정 삭제 해보기
    7. 데이터 베이스 백업 
	8. 데이터 베이스 복구
*/
# 1. 사용자 계정 만들기
create user 'springuser'@'localhost' identified by '1234';

-- user              : 사용자 계정
-- @                 : "어디에서 접속하는 사용자" 구분
-- 'localhost'       : MySQL DBMS 소프트웨어가 설치된 서버(컴퓨터)에서만 접속 가능 
-- IDENTIFIED BY '?' : 비밀번호 만들기 

# 1.1. 외부 접속 가능한 사용자 생성
create user 'springuser2'@'%' identified by '1234';
-- '%' 모든 ip를 사용하는 컴퓨터에서 springuser2 계정으로 MySQL에 접속이 가능하게 한다.

# 2. 데이터 베이스 생성
create DATABASE springdb;

# 3. 만든 사용자 계정에 특정 데이터베이스를 사용할 권한 부여 
/*
localhost에서 접속하는 springuser 사용자에게
springdb 데이터베이스 안의 모든 테이블을 다룰 수 있는 모든 권한(select, insert, delete, update..)를 줌
*/ 
grant all privileges on springdb.* to 'springuser'@'localhost';

-- grant           				 : 권한 줌
-- all privileges			 	 : 모든권한
-- on			 				 : 어느 대상에게
-- springdb.*	  				 : springdb라는 이름 데이터베이스 안의 모든 테이블
-- to			                 : 누구에게
-- to 'springuser'@'localhost'   : localhost에서 접속하는 springuser 사용자 계정에게 권한 부여

# 4. 권한 적용
flush privileges;

# 5. 권한 부여 확인
show grants for 'springuser'@'localhost';

# 6. 사용자 계정 삭제
drop user 'springuser'@'localhost';













