 /* 								
   - VIEW 
     . 자주 사용되는 SELECT 구문을 미리 만들어 두고 테이블 처럼 호출 하여 사용 할수 있도록 만든 기능.
     . 자주 사용되는 기능,조회하고자 하는 데이터 set을 select구문으로 미리 만들어 두고 테이블 처럼 호출하여 사용 할 수 있도록 만든 기능(재사용성)
     -데이터베이스의 테이블에 있는 데이터들의 특정 컬럼만 추출하여 전달하거나, 특정조건에 맞는 행들만 필터링하여 새로운 데이터 set을 만듦으로서 외부에
     원본데이터 구조를 공개하지 않을 수 있다.(보안성)
     -VIEW로 보여지는 데이터가 기본키를 포함하고 있다면 수정,삭제, 등 관리를 할 수 있다.

	 . SQL Server의 View는 하나의 테이블로부터 특정 컬럼들만 보여주거나 특정 조건에 맞는 행을 보여주는데 사용될 수 있으며, 
	   두 개 이상의 테이블을 조인하여 하나의 VIEW로 사용자에게 보여주는데 이용될 수도 있다. 
	   VIEW 자체는 테이블처럼 실제 데이터를 가지고 있지는 않으며, 단지 SELECT문의 정의만을 가지고 있다.
	 
	 . 기본 키 값을 포함한 VIEW 에서삽입, 삭제, 수정 작업이 가능. 

	 . 보안상의 이유로 테이블중 일부 컬럼만 공개 하거나
	   불필요한 갱신 을 미연에 방지 하고자 할때 사용된다. 
 */	
 
 
 -- VIEW 의 작성

  /* 과일 가게 일자별 판매, 발주 리스트를 VIEW 형태로 만들고 (V_FruitbusinessList) VIEW 를 호출하여 데이터를 표현. */
 

  /**************************************************************************************/
 
 # VIEW의 작성
 create view V_fruit_Tran_List as 
 (
select A.title,
	   A.DAte,
	   A.CUSTINFO,
	   A.NAME,
	   A.fruit,
	   A.FRUITNAME,
	   A.amount
	from (  select '판매'         as TITLE,
    		       ts.DATE       as DATE,    -- 판매 일자 
				   ts.Cust_id    as CUSTINFO, -- 고객 ID 
 		TC.Name       as NAME,
 		ts.fruit      as fruit,   -- 과일 
 		TF.FruitName  as FRUITNAME,
 		ts.amount     as amount   -- 수량
   from t_saleshst ts  join t_customer tc 
   						 on TS.Cust_id = TC.Cust_Id 
   					   join t_fruitmaster tf 
   					     on TS.fruit = TF.Fruit 
  union ALL
 select '발주'       							 as TITLE,
        to2.DATE     							 as DATE,     -- 발주일자
        to2.CUSTCODE							 as CUSTINFO, -- 발주처 
        case CUSTCODE when '10' then '삼전물산'    
        		      when '20' then '하나'
        		      when '30' then '농협'
        		      when '40' then '대림'  end  as NAME,
        to2.fruit   							 as fruit,    -- 발주 과일
        TF.FruitName 							 as FRUITNAME,
        to2.amount   							 as amount    -- 발주수량
   from t_orderlist to2 join t_fruitmaster tf 
   					      On to2.fruit = TF.Fruit  ) A
order by date
 ) ;
 
 #VIEW의 호출
 select * from V_fruit_Tran_List;
 
 /*
  * 실습
  * V_fruit_Tran_List를 이용해 
  * 과일가게에서 발주금액이 가장 많았던 업체와 발주 금액을 산출
  */
select case CUSTCODE when '10' then '삼전물산'    
        		      when '20' then '하나'
        		      when '30' then '농협'
        		      when '40' then '대림'  end  as NAME
        		      ,max(ordertotal) as ordertotal
	from(select CUSTCODE
        		      ,sum(tf.ordercost*se.amount) as ordertotal
        		      ,rank() over(order by sum(tf.ordercost*se.amount) desc)as `rank`
				from V_fruit_Tran_List se join t_fruitmaster tf 
						on se.fruit=tf.Fruit
						join t_orderlist to2 
						on se.fruit=to2.fruit 
				where title='발주'
				group by CUSTCODE)A
	group by CUSTCODE
	limit 1;
 
 
 /*T*/

#1)업체별 최대 발주 금액을 구하기
select name,
sum(se.amount*tf.ordercost) as ordercost
from V_fruit_Tran_List se join t_fruitmaster tf 
							on se.fruit=tf.Fruit 
where title='발주'
group by name
having sum(se.amount*tf.ordercost)=(select max(ordercost)
from(select name,sum(se.amount*tf.ordercost) as ordercost
		from V_fruit_Tran_List se join t_fruitmaster tf 
								on se.fruit = tf.Fruit 
		where title='발주'
		group by name)A);


 #view
#테이블의 기본값을 가지고 있는 view는 수정,갱신이 가능하다.
create view V_Test as
(
	select cust_id,name
		from t_customer tc 
	where cust_id >2
);
 
 select * from v_test vt ;
 #VIEW에 데이터 등록
#VIEW가 관리하는 테이블의 key가 명시 되어 있을 경우
#데이터의 추가 / 삭제가 가능하다.
#VIEW에 데이터 등록 
insert into v_test (cust_id,name) values (9,'최형배');

select *from t_customer tc ;
 
delete from v_test where cust_id=9;

 
drop view v_test ;
 
 
 /*
  * 실습
  * 일자별 마진을 계산하는 SQL에서
  * 일자별 총 판매금액 VIEW
  * 일자별 총 발주금액 VIEW
  * 2개를 만들고 
  * 각 VIEW를 통해 일자별 총 마진을 구하는 SQL을 작성해 보세요
  * */
 create view v_cost as
 (
	select  ts.`date`,sum(tf.unitprice*ts.amount) as tunitprice
		from t_saleshst ts join t_fruitmaster tf  
					on ts.fruit =tf.Fruit 
			group by `date`											
	
 );
 
 
 create view v_ordercost as
 (
	select `date`,-sum(tf.ordercost*to2.amount) as tunitprice
from t_orderlist to2  join t_fruitmaster tf  
					on to2.fruit =tf.Fruit 
group by to2.`date`
 );
 

#3) view 통한 union


select `date`
		,sum(tunitprice) as margin
from(select `date`,tunitprice
	from v_cost
	union all
	select `date`,tunitprice
	from v_ordercost )A
group by `date`;

 
 
 
 
 
 
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
CREATE TABLE T_ItemMaster_test (
#[컬럼의 이름] [유형](크기)
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
    MAKEDATE DATETIME, #일시(년월일 시분초)를 DATETIME이라는 형식으로 관리
    MAKER VARCHAR(30),
    EDITDATE DATETIME,
    EDITOR VARCHAR(30)
); 
 
 
 
# 재고 현황 (창고에 있는 제품의 재고 현황을 관리)
 CREATE TABLE T_Stock_test (
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
CREATE TABLE T_Stockhst_test (
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

 
 
 #pkk에 대한 조건, fk에 대한 조건, null 처리여부, 컬럼의 커멘트
#수기로 직접 등록 가능

#테이블 수정
#1. 테이블에 코멘트(테이블의 설명) 작성
alter table T_Stockhst_test comment = '재고입출이력';

#2.not null 속성지정하기
alter table t_stockhst_test modify column inoutseq int not null;

#3.pk 속성 지정하기(기본키로 설정하기)
#key : 중복이 되면 안되는 행을 대표하는 데이터가 있는 컬럼
#후보키 : key가 될 수 있는 컬럼
#기본키(PK) : 후보키중에 실제 사용에 선택 된 키
#복합키가 (2개이상의 컬럼을 하나의 키)설정
alter table t_stockhst_test add constraint t_stockhst_TEST_pk primary key (inoutdate,inoutseq);


#4.컬럼의 코멘트 설정
ALTER TABLE t_stockhst_test MODIFY COLUMN INOUTDATE varchar(10) COMMENT '입/출일자'; 

#5.속성 변경 및 유형 크기 변경
ALTER TABLE t_stockhst_test MODIFY COLUMN MAKER varchar(10)


#6.컬럼의 추가
ALTER TABLE t_stockhst_test ADD TestColumn varchar(30);


#7.컬럼의 삭제
ALTER TABLE t_stockhst_test DROP COLUMN TestColumn;

#8.FK설정
#품목 마스터 테이블의 컬럼 itemcode와 FK
alter table t_stockhst_test add constraint t_stockhst_Test_Itemmaster_FK 
	foreign key (ITEMCODE) references t_itemmaster(itemcode);

/*T_stock_test*/

/*
 * 1.테이블의 코멘트 : 재고현황
 * 2.itemcode 컬럼 데이터 유형을 문자열 30자리로 변경
 * 3.LOTNO컬럼과 ITEMCODE를 not null로 설정
 * 4.LOTNO 컬럼 PK로 설정
 * 5.t_itemmaster 테이블과 itemcode로 FK 관계 설정
 * 
 * */

ALTER TABLE T_stock_test COMMENT='재고현황';

ALTER TABLE T_stock_test MODIFY COLUMN ITEMCODE varchar(30);

ALTER TABLE T_stock_test MODIFY COLUMN STOCKQTY varchar(10) COMMENT '재고수량' DEFAULT 0 

ALTER TABLE T_stock_test ADD CONSTRAINT t_stock_pk PRIMARY KEY (LOTNO,ITEMCODE)

ALTER TABLE T_stock_test ADD CONSTRAINT t_stock_t_itemmaster_fk FOREIGN KEY (ITEMCODE) REFERENCES t_itemmaster(ITEMCODE);


/********************************************************************************************
 * 2. 테이블 삭제
********************************************************************************************/
drop table T_stock_test;
drop table t_stockhst_test;


/********************************************************************************************
  DML(Data Manipulation Language - 데이터 조작어)
  . 정의된 데이터베이스에 입력된 레코드를 조회하거나 수정하거나 삭제하는 등의 역할을 하는 언어.
  . 데이터베이스 사용자가 응용 프로그램이나 질의어를 통하여 저장된 데이터를 실질적으로 처리하는데 사용하는 언어

    > insert : 데이터 삽입
    > update : 데이터 수정
    > delete : 데이터 삭제 특정 cell의 데이터를 삭제x,  
    		********************************행간 삭제 삭제 해야 하는 컬럼의 데이터를 명확히 기술 
    > select : 데이터 조회,가공 표현
    
************************************************************************************************/

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
					  WHERE CUST_ID > 7; -- 조건절을 추가하여 원하는 데이터만 등록 가능. 

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
   WHERE CUST_ID = 7;  # WHERE : 반드시 작성해야 하는 절은 아니다. 원하는 데이터의 수정이 필요한 경우 해당 데이터에 속하는 컬럼의 조건을 명시해주고 일과 UPDATE 
   
select * from t_Customer_back


/**  기존의 값에 누적하여 숫자 데이터 더하기 **/
update t_saleshst 
	set amount =amount +1
	where date = '2023-12-01'

	
# JOIN 문을 병행한 UPDATE
# 5월 재고 현황을 파악후 상태를 일괄 UPDATE하려고한다.
# 품목구분이 ROH인 재고의 상태를 확인 안전재고와 최대재고를 현재고와 비교하여
# 적정,과재고,미달을 평가하고 , 품목마스터에는 5월재고 확인 완료

select * from t_itemmaster ti  where ITEMCODE ='64319-2V000B';

select * from t_stock ts where ITEMCODE ='64319-2V000B';

update t_stock ts join t_itemmaster ti
				on ts.ITEMCODE = ti.ITEMCODE 
set ts.REMARK = case when ts.STOCKQTY >=ti.SAFESTOCK and ts.STOCKQTY <ti.SAFESTOCK  then '적정'
					when ts.STOCKQTY >=ti.MAXSTOCK then '과재고'
					else '미달' end
		,ti.REMARK ='5월재고확인'
	where ti.ITEMTYPE ='ROH';

#****************************************검증*****************************************************
#1.ROH 품목에 해당하는 재고만 평가되었는지 확인
select ts.*
from t_stock ts join t_itemmaster ti 
				on ts.ITEMCODE =ti.ITEMCODE 
where ti.ITEMTYPE ='ROH';

select * from t_itemmaster ti where ti.ITEMTYPE ='ROH';

#개수를 확인해서 검증
select count(*) from t_stock ts join t_itemmaster ti on ts.ITEMCODE =ti.ITEMCODE where ti.ITEMTYPE ='ROH';
#37 32 5개 차이가 난다.
select * from t_itemmaster ti where REMARK='5월재고확인';
#중복이 있는것을 확인
select ts.ITEMCODE  from t_stock ts join t_itemmaster ti on ts.ITEMCODE =ti.ITEMCODE where ti.ITEMTYPE ='ROH'; 
 
#32개 검증 완료
select ti.ITEMCODE 
from t_stock ts join t_itemmaster ti 
				on ts.ITEMCODE =ti.ITEMCODE 
	where ti.ITEMTYPE ='ROH'
group by ti.ITEMCODE ;


/*
 * 3. DUPLICATE key(있으면 update 없으면 insert)
 * KEY의 값에 따른 update insert
 * */
#예제
insert into t_customer(cust_id,name,phone) values(5,'윤하',486486)
on DUPLICATE key 
update name = '윤하',phone=486486;

select * from t_customer tc 



/*
 * delete 현재 테이블의 데이터 행을 삭제
 * */
#지워지지 조심조심조심조심
delete from t_customer 
	where cust_id> 8;
#조심조심조심


#셀의 데이터를 삭제하는것이 아니라 해당 조건을 만족하는 모든 행의데이터를 삭제
delete from t_customer 
#참조가 있어 안지워진다. (참조가 있으면 수정 불가)
select * from t_customer tc 
	where Birth >1985;


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
        	    *
        	    *
        	    * 데이터 갱신 내역을 승인, 복구
        	    * 여러개의 갱신 문법으로 구성되어있는 SQL가 있을때
        	    * 	>일부 테이블에 갱신이 완료 되었으나,
        	    * 	특정시점에 갱신 작업이 불특정 사유로 취소 되었을 경우.
        	    * >앞서 성공했던 갱신 작업을 일괄 복구
        	    * 데이터의 일관성 유지
        	    * 데이터의 독립성 (격리성)
        	    * >하나의 트랜잭션이 수행 될때는 다른 세션(데이터 베이스 접속 경로)이 간섭 할 수 없다.
        	    * 하나의 트랜잭션이 종료 될때는 commit또는 rollback처리를 해주어야한다.
        	    * 해당 세션이 종료 되면 트랜잭션은 자동 rollback된다.
        */
 
start transaction; #트랜잭션을 실행 하겠다.
DELETE from t_customer ; #참조(테이블에 t_customer에 references)를 지우면 가능하다 지금은 안지워 불가능
select * from t_Customer;
rollback; -- BEGIN TRAN  시작 시점 부터 갱신 내역 복구



start transaction;
DELETE from t_Customer_back;
commit;   -- BEGIN TRAN  시작 시점 부터 갱신 내역 승인
select * from t_Customer_back;












 
 
 