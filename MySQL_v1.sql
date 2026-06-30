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
    
