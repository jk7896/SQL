
-- mY sQL 추석 처리
# 한줄 주석 처리 2번째
/* 다중
 * 주석 처리 방법 
 */



/*
1) DBMS (DataBase Management System)
  - 대용량의 데이터 집합을 체계적으로 구성하는 시스템.
  - 사람이 만들어내는 정보(SNS, 물건 구입내역, 업체의 인사정보 등) 을 데이터화 하여
    저장하고 체계적으로 관리 할 수 있도록 도와주는 시스템. 
 
  - 과일가게 관리 프로그램에서 발생하는 과일의 주문내역 및 거래내역, 금액 등을 데이터화 하여
    별도의 파일 공간에서 관리.
  - 응용 프로그램(Application) 과의 연동 및 네트워크 상의 모든 사용자가 공유함으로서 
    보다 더 유용하게(데이터)를 활용 할 수 있다. 
	대표적인 DBMS 유형으로는 (MSSQL, Oracle, MySql, Excel 등이 있다.)

2) DBeaver ? 
  - MySql 데이터 베이스를 유용하게 관리 할 수 있도록 도와주는 Tool. 


3) SQL ? (Structured Query Language)
  - DBMS 와 사용자가 원하는 데이터를 관리 할 수 있도록 주고받는 DBMS 언어 
    Ex) 프로그래밍 언어로는 JAVA, C#.....
	거의 모든  DBMS 가 표준 SQL 문법을 따른다.  
	각 DBMS 만의 특별한 문법이 존재하지만 차이는 크지 않다. 

4) 데이터 베이스 강의의 목적.
  - DVeaver 툴을 이용해 SQl 언어를 사용하여 MySql DBMS 에서 데이터를 관리할 수 있다.
*/




/* 
- DDL(Data Definition Language - 데이터 정의어)		
  . 데이터베이스를 정의하는 언어. 데이터를 생성, 수정, 삭제하는 등의 데이터의 전체의 골격을 결정하는 역할을 하는 언어이다.		
    > create : 데이터베이스, 테이블등을 생성		
    > alter : 테이블을 수정		
    > drop : 데이터베이스, 테이블을 삭제		
    > truncate : 테이블을 초기(제약조건을 포함한 모든 설정을 초기화) 	
    > SCHEMA(컬럼), DOMAIN(속성), TABLE, VIEW, INDEX를 정의하거나 변경 또는 삭제할 때 사용하는 언어		
      * 데이터 베이스 관리자나 데이터베이스 설계자가 사용		
*/


######################################################################################################
# * 1. 테이블의 생성  
 
 
# 제품 마스터 (취급하는 제품의 종류 를 관리하는 테이블.)
CREATE TABLE T_ItemMaster (
    ITEMCODE VARCHAR(30),
    ITEMNAME VARCHAR(50),
    ITEMTYPE VARCHAR(10),
    WHCODE VARCHAR(10),
    LOCCODE VARCHAR(10),
    MAXSTOCK FLOAT,
    SAFESTOCK FLOAT,
    BASEUNIT VARCHAR(10),
    UNITCOST FLOAT,
    UNITWGT FLOAT,
    SPEC VARCHAR(30),
    INSPFLAG VARCHAR(1),
    MINORDERQTY FLOAT,
    MAKECOMPANY VARCHAR(30), 
    USEFLAG VARCHAR(1),
    REMARK VARCHAR(255),
    MAKEDATE DATETIME,
    MAKER VARCHAR(30),
    EDITDATE DATETIME,
    EDITOR VARCHAR(30)
);


# 재고 현황 (창고에 있는 제품의 재고 현황을 관리)
# 같이 만들어 보기 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
CREATE TABLE T_Stock (
    LOTNO    VARCHAR(30),
    WHCODE   VARCHAR(10),
    LOCCODE  VARCHAR(10),
    ITEMCODE VARCHAR(10),
    STOCKQTY FLOAT,
    INDATE VARCHAR(10),
    CUSTCODE VARCHAR(30),
    REMARK VARCHAR(255),
    MAKER VARCHAR(30),
    MAKEDATE DATETIME
);



# 재고 입 / 출 이력 (제품의 입/출 고 이력을 관리하여 재고 현재 과정을 기록)
CREATE TABLE T_Stockhst (
    INOUTDATE VARCHAR(10),
    INOUTSEQ int,
    ITEMCODE VARCHAR(30),
    LOTNO VARCHAR(30),
    WHCODE VARCHAR(10),
    LOCCODE VARCHAR(10),
    INOUTCODE VARCHAR(10),
    INOUTFLAG VARCHAR(1),
    INOUTQTY FLOAT,
    PONO VARCHAR(255),
    REMARK VARCHAR(255),
    MAKER VARCHAR(30),
    MAKEDATE DATETIME
);

 ######################################################################################################













######################################################################################################
#* 2. 테이블 수정   
 
#테이블의 코맨트 설정
ALTER TABLE t_stockhst COMMENT='재고입출 이력';
 
#not null 속성 지정하기
ALTER TABLE t_stockhst MODIFY COLUMN INOUTSEQ int NOT NULL;

#PK 속성 지정하기
ALTER TABLE t_stockhst ADD CONSTRAINT t_stockhst_pk PRIMARY KEY (INOUTDATE,INOUTSEQ);

#컬럼의 코맨트 설정
ALTER TABLE t_stockhst MODIFY COLUMN INOUTDATE varchar(10) COMMENT '입/출일자'; 

#속성의 기본 데이터 유형 및 크기 변경
ALTER TABLE t_stockhst MODIFY COLUMN MAKER varchar(10)

# 특정 속성에 NULL 입력 시 기본 으로 입력 되는 값 설정 (INOUTQTY 속성에 기본값을 0 으로 등록)
ALTER TABLE mysqldb.t_stockhst MODIFY COLUMN INOUTQTY float DEFAULT 0;
 
#컬럼의 추가  
ALTER TABLE t_stockhst ADD TestColumn varchar(30);

#컬럼의 삭제
ALTER TABLE mysqldb.t_stockhst DROP COLUMN TestColumn;

#품목 마스터와 의 관계 설정 ItemCode
-- 1-1. T_ItemMaster 에 PK 설정
ALTER TABLE t_itemmaster ADD CONSTRAINT t_itemmaster_pk PRIMARY KEY (ITEMCODE);
-- 1-2. 두 테이블 간의 관계 설정
ALTER TABLE t_stockhst ADD CONSTRAINT t_stockhst_t_itemmaster_fk FOREIGN KEY (ITEMCODE) REFERENCES t_itemmaster(ITEMCODE);

 
/************************************실습********************************
# 재고 현황 (T_Stock)  테이블 수정 해 보세요
1. 테이블 코맨트 재고 현황으로 수정
2. ITEMCODE 컬럼 데이터 유형을 가변 문자열 30자리로 설정
3. STOCKQTY 컬럼 코멘트 '재고수량' 변경 및 기본 값 0으로 설정
4. LOTNO, 와 ITEMCODE 는 NOT NULL, PK 설정
5. T_ItemMaster 테이블 과 관계 형성 (FK : ITEMCODE)  
*************************************************************************/ 
ALTER TABLE t_stockhst COMMENT='재고현황';

ALTER TABLE t_stock MODIFY COLUMN ITEMCODE varchar(30)

ALTER TABLE t_stock MODIFY COLUMN STOCKQTY varchar(10) COMMENT '재고수량' DEFAULT 0 

ALTER TABLE t_stock ADD CONSTRAINT t_stock_pk PRIMARY KEY (LOTNO,ITEMCODE)

ALTER TABLE t_stock ADD CONSTRAINT t_stock_t_itemmaster_fk FOREIGN KEY (ITEMCODE) REFERENCES t_itemmaster(ITEMCODE);

 


/********************************************************************************************
 * 2. 테이블 삭제
********************************************************************************************/
drop table t_itemmaster;
drop table t_stockhst;
drop table t_stock;



/********************************************************************************************
 * 
3. 실습에 필요한 테이블 및 데이터 등록하기
  - 스키마와 데이터
   . 강의 테이블 폴더 의 mysqldb_CourseSampleData.sql 실행 (Alt + x) 
   . 스키마 
     > 데이터베이스에서 자료의 구조, 자료의 표현방법, 자료 간의 관계를 형식 언어 로 정의한 구조
     > 위 Sql 문서의 SQL 문은 실습에 필요한 테이블 과 데이터 를 등록 하기 위한
       테이블 스키마의 정의 와 데이터 의 등록 을 SQL 구문으로 구현해 둔 스크립트 라 한다.
********************************************************************************************/







/********************************************************************************************
  DML(Data Manipulation Language - 데이터 조작어)
  . 정의된 데이터베이스에 입력된 레코드를 조회하거나 수정하거나 삭제하는 등의 역할을 하는 언어.
  . 데이터베이스 사용자가 응용 프로그램이나 질의어를 통하여 저장된 데이터를 실질적으로 처리하는데 사용하는 언어

    > insert : 데이터 삽입
    > update : 데이터 수정
    > delete : 데이터 삭제 
    > select : 데이터 조회

********************************************************************************************/
 /* 1. INSERT 
    - 테이블에 데이터를 등록 한다. 
	- INSERT 기본 유형
	  . INSERT INTO <테이블> (열이름1, 열이름2 .... ) VALUES (값1, 값2 .... )
	
	- PK 컬럼에 등록되는 데이터는 테에블에서 가지는 유일한 값으로 설정 
	- NOT NULL 컬럼에는 반드시 데이터가 등록 되어야 한다. 
  */ 

  -- 1-1. T_Cust 테이블에 데이터 등록 (일부 컬럼의 속성만 지정)
  INSERT INTO t_Customer(CUST_ID, NAME, PHONE) VALUES (7,'임창정',5555);
 
  -- 1-2. 모든 데이터를 등록 할 때는 열이름 생략 가능
  INSERT INTO t_Customer VALUES (8,'박효신','1979-03-01','서울', 6666);

  -- 1-3. 테이블의 복사
  /* 기본 형태 
  create table [생성할 테이블명 ] as select * FROM [원본 테이블명] WHERE  1=2   
  WHERE  1=2  거짓 이므로 데이터는 조회 되지 및 복사되지 않는다. */
create table t_Customer_back as select * FROM t_Customer where 1 = 2;  

-- 테이블 생성 확인 t_Customer
SELECT * FROM t_Customer_back; 
  -- ** 복사 쿼리로 테이블의 구조와 레코드는 복사할 수 있으나 Primary Key, Foreign Key, Default, Index등은 복사를 할 수 없다.



  -- 1-5. SELECT 를 통한 선택적 N개 이상의 데이터 복사
  INSERT INTO t_Customer_back (CUST_ID, Name , Birth)
                     SELECT CUST_ID,  Name , Birth    -- SELECT 로 검색할 데이터 외에 임의의 데이터 설정 가능. 
					   FROM t_Customer
					  WHERE CUST_ID = 7; -- 조건절을 추가하여 원하는 데이터만 등록 가능. 

-- 데이터 등록 확인.
SELECT * FROM t_Customer_back; 







/**********************************************************************************************************************************************
  2. UPDATE
    - 테이블의 데이터를 수정. 
	- UPDATE 기본 유형
	  . UPDATE <테이블> 
	       SET  열이름1 = 값1  
			   ,열이름2 = 값2
		 WHERE [조건] ;  
*/

  UPDATE t_Customer_back
     SET Birth  = '1976-12-05'
   WHERE CUST_ID = 7;  -- 조건 절을 통하여 원하는 데이터만 수정이 가능. 



/**  기존의 값에 누적하여 숫자 데이터 더하기 **/
-- SalesSht 테이블 데이터 등록
insert into t_saleshst values(7,'사과',2000,1);

  UPDATE t_saleshst
     SET qty =   qty + 1
   WHERE CUST_ID = 7;  -- 조건 절을 통하여 원하는 데이터만 수정이 가능. 



   
 

/************************************************************************
3. DUPLICATE KEY (Update OR Insert)
  - KEY 의 값에 따른 UPDATE INSERT
  - INSERT 시 KEY 의 컬럼에 동일한 값이 존재 하면 해당 KEY 의 행의 속성이 UPDATE 
    없을 경우 INSERT 
*************************************************************************/        
select * from t_customer tc ;

insert into t_customer (Cust_Id,Name,Phone) values  ('4','이수',4444)
on DUPLICATE key 
update NAME = '박효신',PHONE = 6666;
-- 최초 1회 는 CUSTID 가 4인 이수 가 등록 되지만 이후에는 박효신 으로 UPDATE 된다. 



/************************************************************************
4. JOIN 을 이요한 다중 MULTY UPDATE
  - JOIN 구문 학습 이후 확인.
*************************************************************************/    




 
/**********************************************************************************************************************************************
5. DELETE  
    - 테이블 행의 데이터를 삭제 
	- DELETE 기본 유형
	  . DELETE from <테이블>  
		 WHERE [조건] ;  
*/
  DELETE from t_Customer
   WHERE cust_id = 8 
     and NAME = '박효신';
select * from t_Customer
-- 7 , 임창정 삭제 시 FK 오류를 반환. 




/**********************************************************************************************************************************************
6. Trancate (DDL - 데이터 정의어)
    - 테이블 초기화
      . 테이블 구조 만 남기고 모든 제약 조건 을 초기화함. 
      . 조건절 을 사용하지 않 모든 데이터 를 삭제 
*/
truncate table t_saleshst;

 


/**********************************************************************************************************************************************
        트랜잭션(Transaction)
        . 데이터 갱신 내역 승인 또는 복구 (BEGIN TRAN, COMMIT, ROLLBACK)
            - 데이터의 일관성  
              . 데이터 관리 시 발생하는 오류 사항 (10개 데이터 갱신 실행 시 6번쨰 부터 오류가 발생하였을경우 또는 관리자의 실수.) 
        	    등에 대처 하기 위해 데이터 갱신 후 승인 또는 취소 를 실행 할 필요가 있음. 
            - 트랜잭션의 독립성(격리성) 
              . BEGIN TRAN 선언 후 반드시 COMMIT , ROLLBACK 를 해주어야 한다.
              . 하나의 트랜잭션이 수행되고 있을때 또다른 트랜잭션이 간섭을 할 수 없다. 
        	    ** 트랜잭션 선언시 데이터베이스 의 테이블 을  해당 세션(접속 자) 이 점유 하게 된다. 
        */
 
start transaction;
DELETE from t_Customer_back;
select * from t_Customer_back;
rollback; -- BEGIN TRAN  시작 시점 부터 갱신 내역 복구



start transaction;
DELETE from t_Customer_back;
commit;   -- BEGIN TRAN  시작 시점 부터 갱신 내역 승인
select * from t_Customer_back;








