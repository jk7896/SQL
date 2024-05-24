-- 작업 데이터 베이스 확인
USE mySqldb;
-- 실행은 crt + enter
-- 드래그를 통한 블럭 지정 후 실행 가능. 



 /* 								
   - SELECT 								
  . 데이터베이스 내의 테이블에서 원하는 정보를 추출하는 용도 로 활용도 가 가장 높다.						
  . 가장 기본적인 SQL 구문 이지만 데이터베이스 운영 시 중요도가 높은 문법이므로 잘 숙지 할것.								
     
     SELECT 의 기본 형식.								
     
	 SELECT 컬럼의 이름 및 데이터								
       FROM 테이블 이름 								
       WHERE 조건 								
 */					
 
 /*****************************************************************************************************						
  1. 기본적인 SELECT 형식 */							
 
  -- SELECT 로 만 표현 
  SELECT '안녕하세요' 


  -- * : 애스터리스크 Asterisk (조건을 만족하는 테이블의 모든 내용을 검색)		
 SELECT * FROM t_itemmaster ti ; 								



/** SELECT 는 
    FROM 과는 별개의 명령어로 
	' , ' 단위를 사용하여 각각 한개의 컬럼(열)로 데이터를 표현하라 라는 명령어 이다. **/
SELECT 1 , 2 , 3 ;

				



 /*****************************************************************************************************								
  2. 특정 컬럼 만 검색.

  t_ItemMaster 테이블 에서 ITEMCODE(품목), ITEMNAME(품목명), ITEMTYPE(품목구분) 컬럼의데이터 만 조회

  
  
  ITEMCODE : 품목
  ITEMNAME : 품목명
  ITEMTYPE : 품목구분

  */
  
 SELECT ITEMCODE								
 	   ,ITEMNAME							
 	   ,ITEMTYPE							
   FROM T_ItemMaster;  								
							
								
								
								
 /****** 실습 *******								
  t_ItemMaster 테이블 에서 ITEMCODE(품목), WHCODE(창고), BASEUNIT(단위), MAKEDATE(생성일시) 컬럼을 조회 하세요. */							
 SELECT ITEMCODE								
 	   ,WHCODE							
 	   ,BASEUNIT							
	   ,MAKEDATE							
  FROM T_ItemMaster;  								
						
 
 
 
								
 /*****************************************************************************************************							
    2. 별칭 주기 (AS)								
    컬럼 또는 테이블에 별칭을 주어 지정한 컬럼의 이름으로 변경하여 조회.
	
	AS 로 설정 할 수 있으며 띄워쓰기 이후 에 별칭 으로 설정 가능
	*/								
 
 
 /* t_ItemMaster 테이블 을  ITEM_M 으로 
    ITEMCODE 컬럼을 ITEM_CODE 로 								
    ITEMNAME 컬럼을 ITEM_NAME 으로		
	
 */
  SELECT ITEM_M.ITEMCODE AS ITEM_CODE								
 	    ,ITEM_M.ITEMNAME AS ITEM_NAME							
   FROM t_ItemMaster ITEM_M;




   
							
 								
 								
 -- ****** 실습 ******* 								
 /* t_ItemMaster 테이블 에서 ITEMCODE 컬럼을 ITEM_CODE, 								
    WHCODE   컬럼을 WAREHOUSE, 								
    BASEUNIT 컬럼을 BASE_UNIT, 								
    MAKEDATE 컬럼을 MAKE_DATE 컬럼의 이름으로 바꾸어 조회 하세요.*/							
 SELECT ITEMCODE AS ITEM_CODE								
 	   ,WHCODE	 AS WAREHOUSE						
 	   ,BASEUNIT AS	BASE_UNIT						
	   ,MAKEDATE AS MAKE_DATE							
  FROM t_ItemMaster;								
								
				
 
 
 
 
 
 
 /*****************************************************************************************************								
   3. WHERE 절 								
    검색 조건을 입력하여 원하는 데이터만 조회 한다. 								
    SQL 에서 문자열은 ' 홑따옴표로 정의한다. 	*/							
								
 -- t_ItemMaster 테이블 에서 								
 -- BASEUNIT 가 EA 인 모든 컬럼을 검색.								
 SELECT * 								
   FROM t_ItemMaster 								
  WHERE BASEUNIT = 'EA' 								
								
 								
 								
 -- ** 검색 조건 AND 추가  
 
 /* t_ItemMaster테이블에서								
    BASEUNIT 가 EA 인 것과								
    ITEMTYPE = 'HALB' 인  모든 컬럼을 검색.	*/
 SELECT * 								
   FROM t_ItemMaster 								
  WHERE BASEUNIT = 'EA' 								
    AND ITEMTYPE = 'HALB'								
							
 								

    
 -- ** 검색 조건 OR 추가 
 /* t_ItemMaster테이블에서								
    ITEMTYPE 이 FERT  또는 OM  인  모든 컬럼을 검색. */
 SELECT ITEMCODE								
       ,BASEUNIT 								
       ,ITEMTYPE 								
   FROM t_ItemMaster 								
  WHERE ITEMTYPE = 'FERT' 								
    OR  ITEMTYPE = 'OM' 								
								
    
    
    
								
 -- 아래의 OR 을 묶음 단위로 표현한 것과 동일한 결과 를 얻을수 있다. 								
  SELECT ITEMCODE								
       ,BASEUNIT 								
       ,ITEMTYPE 								
   FROM t_ItemMaster 								
  WHERE (ITEMTYPE = 'FERT'  OR  ITEMTYPE = 'OM')								
								
								
  
  
  
  
 								
 /* ** 주의 ** 								
    컬럼이 다른 검색조건에 OR 이 사용 될 경우								
    BASEUNIT 가 KG 가 아니며 ITEMTYPE 이 HALB 가 아닌 데이터가 검색 될 수 있다. */
	 
 SELECT ITEMCODE								
       ,BASEUNIT 								
       ,ITEMTYPE								
   FROM t_ItemMaster 								
  WHERE BASEUNIT = 'KG' 								
     OR ITEMTYPE = 'HALB'								
	 							
								
     
     
     
     
 /****** 실습 *******							
  t_ItemMaster 테이블에서 								
  WHCODE(창고 코드) 가 'WH003' 이고 'WH008'인 데이터중								
  BASEUNIT(단위) 이 'EA' 인 ITEMCODE(품목), WHCODE(창고), BASEUNIT(단위) 컬럼을 조회 하세요 */							
  SELECT ITEMCODE								
        ,WHCODE 								
        ,BASEUNIT								
   FROM t_ItemMaster 								
  WHERE BASEUNIT = 'EA' 								
    AND (WHCODE = 'WH003' OR ITEMTYPE = 'WH008')								
								
 								
    
    
    
    
    
    
    
    
 --*****************************************************************************************************								
 /* 4. 관계 연산자 의 사용								
    검색 조건에 시작 과 종료 에 대한 정보를 입력하여 원하는 결과를 조회한다. 								
    보통 기간이나 숫자를 검색하지만 문자의 내역도 검색이 가능하다.*/							
 								
 -- ** 기간 관계 연산 검색								
 SELECT * 								
   FROM t_ItemMaster 								
  WHERE EDITDATE > '2021-01-01'								
    AND EDITDATE <= '2021-12-31';								
 								
   
   
   
 -- ** 수 관계 연산 검색								
 -- 정수형 컬럼 정수조건으로 검색								
 SELECT * 								
   FROM t_ItemMaster 								
  WHERE MAXSTOCK > 700 								
    AND MAXSTOCK <= 1000;				
 								
   
   
   
 -- ** 문자열로 입력 하여 정수 형 컬럼 검색 가능								
 SELECT * 								
   FROM t_ItemMaster 								
  WHERE MAXSTOCK > '700' 								
    AND MAXSTOCK <= '1000';								
 								
   
   
    
   
 -- ** 문자 관계 연산 검색	
 -- INSPFLAG 컬럼이 U 값을 가진 내역을 조회.
 SELECT * 								
   FROM t_ItemMaster 								
  WHERE  INSPFLAG = 'U';	 							
								
 
 
 
 
 								
 -- INSPFLAG 컬럼이 U 값을 제외한 내역을 조회.	( != , <> )						
 SELECT * 								
   FROM t_ItemMaster 								
  WHERE INSPFLAG != 'U';								
								
								
 
 
 
 /* INSPFLAG 컬럼이 B 부터 U 까지의 값을 가진 내역을 조회.								
    t_ItemMaster 테이블에서 								
    INSPFLAG 컬럼내용이 A 이상 U 이하인 데이터의 컬럼을 모두 조회.*/								
 SELECT * 								
   FROM t_ItemMaster 								
  WHERE INSPFLAG > 'K' 								
    AND INSPFLAG <= 'U';								
							
								
								
 -- ** 관계 연산자 절 BETWEEN AND 		
 /* t_ItemMaster 테이블에서 								
    MAXSTOCK 이 10 이상 20 이하인 데이터의 컬럼을 모두 조회.*/	
 SELECT * 								
   FROM t_ItemMaster 								
  WHERE MAXSTOCK BETWEEN 700 AND 1000; 								
							
 								
 
 
 
 
 -- BETWEEN AND 는 아래 연산 과 같은 동작을 한다. 이상/이하 								
 SELECT * 								
   FROM t_ItemMaster 								
  WHERE MAXSTOCK >= 700 								
    AND MAXSTOCK <= 1000;								
								
								
-- ****** 실습 *******							
 /* t_ItemMaster 테이블에서								
    WHCODE(창고코드) 가 WH002 ~ WH005 이며								
    UNITCOST(단가) 가 1000 을 초과하는 값을가지고								
    INSPFLAG(검사여부) 가 I 가 아닌 행의								
    ITEMCODE(품목), WHCODE(창고), UNITCOST(단위),INSPFLAG(검사여부) 컬럼을 나타내세요 */								
SELECT ITEMCODE								
	  ,WHCODE							
	  ,UNITCOST							
	  ,INSPFLAG 							
  FROM t_ItemMaster								
 WHERE WHCODE BETWEEN 'WH002' AND 'WH005'								
   AND UNITCOST > 1000								
   AND INSPFLAG <> 'I'								
								
 								
   
   
   
   
 --*****************************************************************************************************								
 -- 5. 특정 컬럼 검색 조건 N 개 설정.  (IN, NOT IN ) 	 빈도수 *** 							
 -- 특정 컬럼이 포함하고 있는 데이터 중 검색하고자 하는 조건이 많을때 사용. 								


 /* t_ItemMaster 에서 								
    ITEMCODE, 와 ITEMTYPE, MAXSTOCK 컬럼 을 조회하고								
    MAXSTOCK 의 수가 1 이상 3000 이하인 것 중에 								
    ITEMTYPE 이 'FERT','HALB' 인 데이터만 조회.  */								
 SELECT ITEMCODE								
 	   ,ITEMTYPE							
 	   ,MAXSTOCK							
   FROM t_ItemMaster 								
  WHERE MAXSTOCK BETWEEN 800 AND 2200      								
    AND ITEMTYPE IN ('FERT','HALB');     								
								
								
 								
 -- 위의 내용은 OR 을 조건을 추가하여 조회한 것과 같은 결과를 조회한다.  
 SELECT ITEMCODE								
 	  ,ITEMTYPE							
 	  ,MAXSTOCK							
   FROM t_ItemMaster 								
  WHERE MAXSTOCK BETWEEN 800 AND 2200                   -- 검색조건 1 BETWEEN								
    AND (ITEMTYPE = 'FERT' OR ITEMTYPE = 'HALB') ;    -- 검색조건 2 IN 과 동일한 결과 								

    
 -- ** 주의 ** 								
 -- 검색 조건에 OR 을 사용할 경우 괄호 묶음을 잘해 줄것.
 SELECT ITEMCODE								
 	  ,ITEMTYPE							
 	  ,MAXSTOCK							
   FROM t_ItemMaster 								
  WHERE MAXSTOCK BETWEEN 800 AND 2200                    -- 검색조건 1 BETWEEN							
    AND ITEMTYPE = 'FERT' OR ITEMTYPE = 'HALB' ;     --  
 -- (MAXSTOCK 이 1 부터 3000 사이인 FERT 유형 데이터들)  이거나  (ITEMTYPE 가 HALB 유형) 의 데이터 를 조회
 

 								
    
    
    
 -- ** 컬럼의 데이터 중 특정 데이터를 제외 하고 검색 NOT IN 
    
 /* t_ItemMaster 에서 								
    ITEMCODE, 와 ITEMTYPE, MAXSTOCK 컬럼 을 조회하고								
    MAXSTOCK 의 수가 1 이상 3000 이하인 것 중에 								
    ITEMTYPE 이 'FERT','HALB' 이 아닌 데이터만 조회  */
 SELECT ITEMCODE								
 	   ,ITEMTYPE 							
 	   ,MAXSTOCK							
   FROM t_ItemMaster 								
  WHERE MAXSTOCK BETWEEN 1 AND 3000         -- 검색조건 1 BETWEEN								
    AND ITEMTYPE NOT IN ('FERT','HALB');    -- 검색조건 2 NOT IN 								
			

    
-- 실습 
--  not in 을 쓰지 않고 위와 똑같은 결과를 출력 해 보세요
 SELECT ITEMCODE								
 	  ,ITEMTYPE							
 	  ,MAXSTOCK							
   FROM t_ItemMaster 								
  WHERE MAXSTOCK BETWEEN 1 AND 3000                   -- 검색조건 1 BETWEEN								
    AND (ITEMTYPE <> 'FERT' AND ITEMTYPE <> 'HALB') ;    -- 검색조건 2 NOT IN 과 동일한 결과 							
 								
 --*****************************************************************************************************								
 -- ****** 실습 ******* 								
 /* t_ItemMaster 테이블에서 								
    WHCODE 컬럼의 값이 WH004 와 WH007 사이에 있는 것중								
    ITEMTYPE 이 HALB,FERT 인 
    ITEMCODE, ITEMNAME, ITEMTYPE,WHCODE 컬럼의 데이터를 검색 하시오. */
	
 SELECT ITEMCODE								
 	   ,ITEMNAME							
 	   ,ITEMTYPE							
 	   ,WHCODE							
   FROM t_ItemMaster								
  where  WHCODE BETWEEN 'WH004' AND 'WH007'								
    AND ITEMTYPE in ('HALB','FERT');
