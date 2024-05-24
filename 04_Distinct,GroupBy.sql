
 /*********************************************************************************************************************
   5.데이터 합병 검색 (DISTINCT)					
   컬럼의 데이터가 중복 이 있을경우 중복 된 데이터를 합병하여 검색. */					
  					
  -- 회사에서 관리하는 모든 품목의 유형을 표현하세요.
  -- t_ItemMaster 테이블에서 ITEMTPYPE 을 합병 후 검색	
  SELECT DISTINCT ITEMTYPE 					
  		     FROM t_ItemMaster;			
				
  					
  /* 단위가 KG 을 가질 수 있는 품목 유형을 조회 하세요.

     t_ItemMaster 테이블에서 BASEUNIT = 'KG' 인 데이터 의 					
     ITEMTPYPE 을 합병 후 검색  */				
  SELECT DISTINCT ITEMTYPE 					
  		     FROM t_ItemMaster			
  		    WHERE BASEUNIT = 'KG';			
	


  -- ** 여러 컬럼을 병합 시 조회할 컬럼의 데이터가 동시에 중복되는 데이터의 행을 표현한다. 
  
-- 단위 가 KG 을 가지는 품목 유형 별 창고 를 나타내세요 
  SELECT DISTINCT ITEMTYPE 	, WHCODE 				
  		     FROM t_ItemMaster			
  		    WHERE BASEUNIT = 'KG';	
  
  -- Baseunit 가 KG 인 데이터 는 ROH 이며 WH001 인데이터 와 
  -- 							 HALB 이며 WH003 인 데이터 가 있다. 
  		   
  		   

  /* t_ItemMaster 테이블에서 BASEUNIT = 'EA' 이고 SPEC 정보가 NULL 이 아닌 속성 데이터 중
      ITEMTYPE 과 SPEC 데이터 를 중복없이 나열 하세요     		   
     . distinct 를 쓰지 않으면 중복된 데이터 가 모두 조회 된다. */ 
     SELECT ITEMTYPE					
		   ,SPEC 		
	   FROM t_ItemMaster			
	  WHERE BASEUNIT = 'EA'
	    AND SPEC is not NULL; 
	    
			   
	-- 조건을 만족하는 데이터 중 ITEMTYPE 과 SPEC 의 데이터 를 중복 하지 않고 조회 한다.		   
    SELECT DISTINCT ITEMTYPE					
  				   ,SPEC 		
  			   FROM t_ItemMaster			
			  WHERE BASEUNIT = 'EA'
			    and SPEC is not NULL;			
					
  					
  /****** 실습 *******	
  BOXSPEC 가 DS-PLT 로 시작하는 품목 들의 유형 별  창고 를 보여 주세요.

  = t_ItemMaster 테이블에서 BOXSPEC 이 'DS-PLT' 로 시작하는 ITEMTYPE 별 WHCODE 의 종류를 조회하세요. */

  SELECT DISTINCT ITEMTYPE
				 ,WHCODE
             FROM t_ItemMaster
		    WHERE SPEC  LIKE 'DS-PLT%' ;				
			

  
/*		  SQL 실행 의 우선순위
  . FROM: 데이터를 가져올 테이블을 지정한다.
  . JOIN: 테이블을 결합한다.
  . WHERE: 가져올 데이터를 필터링한다.
  . GROUP BY: 그룹화한다.
  . HAVING: 그룹화된 결과를 필터링한다.
  . SELECT: 가져올 데이터를 지정한다.
  . DISTINCT: 중복을 제거한다.
  . ORDER BY: 결과를 정렬한다.
  . TOP: 상위 N개의 데이터를 반환한다.
  . UNION: 결과를 합친다.	   
*/

		   
		   
  /*********************************************************************************************************************
    6. 데이터 합병 검색 GROUP BY .  중요도 **********
    . GROUP BY 조건에 따라 해당 컬럼의 데이터를 병합.	- distinct 와 동일 				
    . GROUP BY 로 병합된 결과 에서 조회조건을 두어 검색(HAVING)		- distinct 와 차이			
    . ** 집계함수 ** 를 사용하여 병합 데이터를 연산하는 기능 수행.  - distinct 와 차이
  */					
  					

  -- GROUP BY 의 기본 유형 
  /* 1. t_ItemMaster 테이블에서 ITEMTYPE 컬럼만 추출 후 리스트 작성
     2. 리스트에서 ITEMTYPE 컬럼 조회 */
     SELECT ITEMTYPE					
       FROM t_ItemMaster				
   GROUP BY ITEMTYPE
   
   
   
   -- distinct 와 같은 결과 
     SELECT distinct ITEMTYPE					
       FROM t_ItemMaster	 
   

       
       
  -- GROUP BY 의 기본 유형 (조건 처리 후 병합)
     SELECT ITEMTYPE					
       FROM t_ItemMaster
	  WHERE WHCODE = 'WH003'
   GROUP BY ITEMTYPE 
  /* 1. t_ItemMaster 테이블에서 WHCODE 컬럼의 데이터가 'WH003' 인 행 리스트 작성 : 조건 처리
	 2. 리스트1 에서 ITEMTYPE 컬럼 만 병합 후 리스트2 등록.
	 3. 리스트2 에서 ITEMTYPE 컬럼 조회 */





  -- *** 주의 *** 
  -- SELECT 할 컬럼은 반드시 GROUP BY 로 병합할 대상 컬럼의 리스트에 있어야 한다. 	 
      SELECT ITEMCODE					
        FROM t_ItemMaster 					
    GROUP by SPEC  ;				
  /* t_ItemMaster 테이블에서 					
     GROUP BY 가 실행 시 SPEC 컬럼 만 병합 대상이 되어 처리 되므로
     SELECT 할때는 SPEC 컬럼만 조회 할 수 있다. */

   
   

    -- 정상적인 구문				
      SELECT ITEMCODE					
        FROM t_ItemMaster 					
    GROUP BY ITEMCODE ;					

														/********************************************************
														    (하위 쿼리 후에 설명 할것)
														    아래와 같은 결과 
														     SELECT ITEMCODE
														       FROM (SELECT DISTINCT SPEC
														   	           FROM t_ItemMaster) A 
														    
															A 테이블 : GROUP BY 가 실행 될때 등록 된 컬럼(SPEC) 으로 생성하는 테이블 데이터.
														********************************************************/  


	  SELECT SPEC
	        ,WHCODE				
        FROM t_ItemMaster 					
    GROUP BY SPEC ;
  /* t_ItemMaster 테이블에서					
     SPEC 컬럼만 병합 하려 하나 SPEC 과 WHCODE 가 검색 컬럼으로 지정 된 경우 
	 WHCODE 는 병합 대상 컬럼으로 처리 되지 않았으므로 나타낼 수 없음. (오류) */ 



	-- 정상적인 구문				
      SELECT SPEC	
	        ,WHCODE				
        FROM t_ItemMaster 					
    GROUP BY SPEC, WHCODE;					
  					
  
   
   
   
  -- [POINT 1]
  /************************ 실습 *******************************/
   /* t_Stockhst 테이블에서 
     STOCKQTY(현재수량) 이 1500 이상인 
	 makedate(등록일자) '2022-08-01' 부터 '2023-08-01' 사이인 재고를 중복을 제외하고
	 makedate 별 ITEMCODE (품목) 으로  나타 내세요  */ 
    SELECT ITEMCODE 
          ,MAKEDATE
      FROM t_Stock
	 WHERE STOCKQTY >= 1500
	   AND MAKEDATE  between  '2022-01-01'  and '2023-08-01'
  GROUP BY ITEMCODE,MAKEDATE; 

 
 
 
 
 -- [POINT 2]
 -- HAVING 을 이용한 병합 결과 에서 검색 

 /*  t_ItemMaster 테이블에서 
     MAXSTOCK 컬럼의 데이터가 2000 을 초과 는 데이터 중
    ITEMTYPE(품목유형) 별 INSPFLAG(수입검사 여부) 를 나타내고 
    INSPFLAG(수입검사 여부) 가 I,'U' 인 데이터를 표현
   */ 
      SELECT ITEMTYPE,INSPFLAG					
        FROM t_ItemMaster					
	   WHERE MAXSTOCK > 2000  
    GROUP BY ITEMTYPE,INSPFLAG	
	  HAVING INSPFLAG in ('I','U'); 
	   
	 
	  

  -- *** 주의 ***
  -- HAVING 을 실행 할 컬럼은 반드시 GROUP BY 를 통해 병합된 컬럼이어야 한다. 					
      SELECT SPEC	
	        ,WHCODE				
        FROM t_ItemMaster 					
    GROUP BY SPEC,WHCODE					
      HAVING ITEMTYPE = 'HALB';	-- GROUP BY 를 통해 병합하지 않은 컬럼을 조건을 두려고함. 				

      /* t_ItemMaster 테이블에서 SPEC, WHCODE 컬럼을 병합하여 나온 결과에서 ITEMTYPE 을 검색 한 경우(오류)	
     SELECT DISTINCT SPEC,WHCODE FROM t_ItemMaster 의 결과에서 ITEMTYPE 이 'HALB' 인 데이터의 행을 표현 
     하게 되므로 오류 가 남. */ 

 -- 정상 동작 					
      SELECT ITEMTYPE
	        ,WHCODE
        FROM t_ItemMaster 					
    GROUP BY ITEMTYPE,WHCODE					
      HAVING WHCODE = 'WH003';					 

  
  -- 여기서 잠깐.!!!!!!!!

-- [POINT 1] 은 아래 쿼리와 같다.
  SELECT DISTINCT MAKEDATE , ITEMCODE
    FROM t_Stock
   WHERE STOCKQTY >= 1500
	 AND MAKEDATE BETWEEN '2022-01-01'  and '2023-08-01'
	 
	 
	 
-- [POINT 2] 는 아래 쿼리 와 같다.
      SELECT DISTINCT ITEMTYPE,INSPFLAG					
        FROM t_ItemMaster					
	   WHERE MAXSTOCK > 2000  
	     AND INSPFLAG in ('I','U');

-- 왜 GROUP BY 와 HAVING 를 사용하는 것일까 ? 


/*******************************************************************************
   7. 집계함수 
     - 특정 컬럼의 여러 행에 있는 데이터로 연산후 하나의 결과를 반환하는 함수 

     SUM()   : 병합되는 컬럼의 데이터를 모두 합한다.					
     MIN()   : 병합되는 컬럼의 데이터 중 가장 작은 수를 나타낸다.					
     MAX()   : 병합되는 컬럼의 데이터 중 가장 큰 수를 나타낸다.					
     COUNT() : 병합되는 컬럼의 행 개수를 나타낸다., 					
     AVG()   : 병합되는 컬럼의 숫자 데이터값의 평균을 나타낸다.	 		 			
 

    - 집계함수를 사용하지 않는 컬럼이 포함 되어 있을 경우 GROUP BY 할 컬럼에 반드시 포함되어야 한다. */	 
 		
	 
 -- 품목마스터 테이블에서 ITEMTYPE = 'FERT' 인 데이터의 UNITCOST 합.	 
 SELECT SUM(UNITCOST) AS FERT_UNITCOST_SUM					
  FROM t_ItemMaster					
 WHERE ITEMTYPE = 'FERT';	 




  -- 강의안 PPT 37p (GROUP BY 와 집계함수 (조회부)) 참조
 -- ** ITEMCODE 별 등록 행의 개수 조회	 
    SELECT ITEMCODE	
		  ,COUNT(*) AS ITEM_COUNT		
      FROM t_stockhst ts  					
  GROUP BY ITEMCODE; 		 
  -- 64354/64-D3000B 품목의 이력이 N건 인것을 확인 할 수있다. 
 select itemcode,INOUTQTY  from t_stockhst ts  where itemcode = '64354/64-D3000B';
  					
  -- ** ITEMCODE 별 INOUTQTY 합 조회
  -- 품목 별 N 건의 총 합 구하기					
      SELECT ITEMCODE	
	        ,SUM(INOUTQTY)	AS STOCKQTY_SUM			
        FROM t_stockhst ts
     GROUP BY ITEMCODE;		
  -- 만약 GROUP BY ITEMCODE; 가 없으면 SUM 집계함수 가 집계해야 할 기준이 모호하여 오류가 발생한다.
  -- ITEMCODE 별로 집계 를 하고자 하였지만 그룹으로 나눌 ITEMCODE 의 그룹화가 선행 되어 있지 않기 때문이다
   
   
  -- ** 조회 할 데이터 가 1건일 경우 
  -- group by 를 사용하지 않아도 집계 함수 를 사용할 수있다. 
  -- 집계 함수가 실행할 itemcode = '64354/64-D3000B' 만의 단일 그룹이 이미 생성 되어 있기 때문.
      select ITEMCODE  
	        ,SUM(INOUTQTY)	AS INOUTQTY_SUM			
        FROM t_stockhst ts
       WHERE itemcode = '64354/64-D3000B';    
      
      
      
  -- ** ITEMCODE 별 STOCKQTY 평균 조회					
      SELECT ITEMCODE	
	        ,AVG(INOUTQTY)	AS INOUTQTY_AVG			
        FROM t_stockhst ts  					
    GROUP BY ITEMCODE;					
  					
   
   
   
  -- ** ITEMCODE 별 INOUTQTY 최대값 조회					
      SELECT ITEMCODE	
	        ,MAX(INOUTQTY)	AS INOUTQTY_MAX			
        FROM t_stockhst ts  					
    GROUP BY ITEMCODE;					
   
   
   
  					
  -- ** ITEMCODE 별 INOUTQTY 최소값 조회					
      SELECT ITEMCODE	
	        ,MIN(INOUTQTY)	AS INOUTQTY_MIN			
        FROM t_stockhst ts 				
    GROUP BY ITEMCODE;					 

   
   
   
 					
 -- *** 동일한 그룹 에 집계함수를 여러번 사용하여 원하는 결과를 검색 할 수 있다.  					
  -- ITEMTYPE 별 UNITCOST 합과 최소값 조회					
      SELECT ITEMTYPE,					
 	         SUM(UNITCOST) AS UNITCOST_SUM,				
 			 MAX(UNITCOST) AS UNITCOST_MAX		
        FROM t_ItemMaster 					
    GROUP BY ITEMTYPE;					

 -- 순서 
 -- 1. 유형(ITEMTYPE) 별로 group by 
 -- 2. 해당 그룹 별로 t_ItemMaster 의 UNITCOST 의 합(SUM) 연산 
 -- 3. 해당 그룹 별로 t_ItemMaster 의 UNITCOST 의 최대값(MAX) 연산 
   
   

 -- 집계 함수를 사용한 결과의 조회 조건 (HAVING)					
 -- GROUP BY로 병합된 결과의 HAVING 조건에 집계함수 를 사용시 GROUP BY 에 명시하지 않은 컬럼 을 사용 할 수 있다. 

   	  SELECT ITEMTYPE,					
 	         SUM(UNITCOST) AS UNITCOST_SUM,				
 			 MAX(UNITCOST) AS UNITCOST_MAX
        FROM t_ItemMaster 					
    GROUP BY ITEMTYPE					
      HAVING SUM(UNITCOST) > 1000000;
	  
	  /* 1. HAVING 조건 절에는 SELECT 의 별칭을 사용 할 수 없다.(having 이 select 보다 우선 실행된다.) 
	  
	     2. HAVING 과 SELECT 에서 집계 함수 를 사용하면 집계 함수 로직을 두번 실행 하는 결과 !!!!! HAVING , SELECT 
	       1)GROUP BY   유형별로 group by 
           2)HAVING     group 별로 t_ItemMaster 테이블 에서 유형별 unitcost 의 합 산출 하여 1000000 이상인 그룹 필터링
	       3)SELECT     2 에서 나온 결과의 행 에서 ITEMTYPE 추출 결과의 그룹 별로 UNITCOST 합산 및, 최대값 산출. 
	        * Having 조건절의 집계 함수 연산 처리 수량 >= SELECT 절의 집계 함수 연산 처리 수량
	        * Having 에서 걸러내는 행의 결과가 적으면 SELECT 에서 수행할 집계 내용이 줄어든다. 
	  */



												/***********************************************************************************************************************
												 -- 집계 함수의 괄호안의 컬럼은 테이블 과 GROUP BY 결과 테이블과 함께 함수 에 전달 되어 처리 된 결과(MAX값 등)가 GROUP BY 병합 결과 테이블에 추가가 되며
												 -- 이때 추가된 컬럼 의 데이터 를 보고 비교를 한다. 
												 
												 -- EX)  A : GROUP BY 결과 테이블 
												 -- SELECT ITEMTYPE
												 --   FROM ( SELECT ITEMTYPE,[ITEMTYPE 별 UNITCOST 가 가장 큰 값을 찾는 함수]  AS MAX_UNITCOST
												 --            FROM t_ItemMaster GROUP BY ITEMTYPE) A 
												 -- WHERE A.MAX_UNITCOST > 500
												 ***********************************************************************************************************************/



 -- ** 집계 함수를 사용한 결과의 조회 조건 처리 후 정렬 					
 -- 병합 된 결과에서 HAVING 조건 절을 추가 후 표현하고 특정 컬럼으로 정렬
 
   /* t_ItemMaster 테이블 에서 UNITCOST 가 10000 이상인 데이터 를 가진 행중
       ITEMTYPE 별로 unitcost 1000000 을 초과 하는 행의 
       ITEMTYPE 컬럼, UNITCOST 의 합, UNITCOST 의 최대값 을 나타내고
       UNITCOST 최대값 을 기준으로 오름차순 하여 표현하라. */ 
      SELECT ITEMTYPE,					
 	         SUM(UNITCOST) AS UNITCOST_SUM,				
 			 MAX(UNITCOST) AS UNITCOST_MAX		
        FROM t_ItemMaster
	   WHERE UNITCOST >= 10000
    GROUP BY ITEMTYPE			
      HAVING SUM(UNITCOST)>1000000 					
    ORDER BY UNITCOST_SUM;   
   
   
   /* 
      데이터베이스 처리 절차
      ** FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDERBY 순으로 처리.  
      1. t_itemmaster 테이블에서 unitcost 가 10000 이상인 데이터 추출.
         select * from t_itemmaster where unitcost >= 10000;
         
      2. 1의 결과 에서 품목 마스터 에서 ITEMTYPE 컬럼만 병합한 테이블을 별도로 생성
        *  그룹화는 이후의 집계 함수(SUM, MAX)에 사용되는 데이터 세트를 구성하기 위한 것
         select itemtype from t_itemmaster where unitcost >= 10000 group by itemtype;
         
      3. UNITCOST 의 SUM 이 1000000 을 초과하는 ITEMTYPE 만 추출 하여 2의 결과 에서 추리기. 
        > 2 의 결과 에서 1줄씩 비교 
         . ROH1 의 SUM(UNITCOST) > 1000000 ? 
         . ROH1 의 SUM(UNITCOST) > 1000000 ?   
        
        select itemtype from t_itemmaster where unitcost >= 10000 group by itemtype having sum(unitcost) > 1000000;
         
      4. SELECT 수행
      
         - 3의 결과 ITEMTYPE 컬럼 표현
         - 3의 결과 ITEMTYPE 별 UNITCOST 총 합  산출 후 UNITCOST_SUM 이름의 컬럼 표현
         -  의 결과 ITEMTYPE 별 UNITCOST 최대값 산출 후 UNITCOST_MAX 이름의 컬럼 표현
         
      5. 표현된 모든 컬럼 의 행 중 UNITCOST_SUM 컬럼 데이터를 기준으로 오름 차순으로 정렬함.

	  . SELECT 수행 시 컬럼 별칭이 부여 되어 
	    이후 수행되는 로직인 ORDER BY 에서 별칭으로 호출 가능. 
   */
 
  /*** 정리
  1. 집계 함수는 GROUP BY 와 함께 사용 하여 통계적 데이터를 가공하는데 큰 편의를 제공한다. 
  2. 집계 함수 의 결과 조건 을 사용하지 않을 경우 GROUP BY / DISTINCT큰 차이가 없다.
     > DISTINCT 는 SELECT 이후 연산 되어 GROUP BY 보다 연산 속도가 느려질 수 있다.
  3. HAVING 절에서 사용한 집계함수 는 필터 링을 위하여 조건으로 사용, 연산 처리 과정이 수행된다.
     SELECT 절에서 사용한 집계함수 는 표현을 위하여 having 으로 필터링 된 결과에서 한번더 연산 처리 한다. (2번 연산 처리)
   */
 

  /**** 실습  [POINT 3] 
   '2023-01-02' 일 부터 현재까지
   창고별(WHCODE) 로 2번 이상 입고 된 품목(ITEMCODE) 의 입고 횟수 와 총 입고 수량(INOUTQTY) 을 조회 하고 
   창고별 입고 수량 합 을 오름차순하여 표현하세요
     * 대상 테이블 입출 이력 테이블 : t_stockhst
     * 입고 여부 : INOUTFAG = 'I' 
  */ 
     SELECT WHCODE
     	   ,ITEMCODE  
	       ,COUNT(*) AS CNT
	       ,SUM(INOUTQTY) as SUM_QTY
       FROM t_Stockhst 
	  WHERE INOUTDATE  > '2023-01-01'
	    and INOUTFLAG  = 'I'
   GROUP BY ITEMCODE,WHCODE
     HAVING COUNT(*) >= 2 
   ORDER BY WHCODE,SUM_QTY;
 
  
  
  
   
 -- *** WHERE 조건절 에는 집계 함수를 사용 할 수 없다 .
 -- 집계 를 해야 할 그룹의 대상이 정해져 있지 않기 때문
 SELECT ITEMCODE 
   FROM t_Stockhst
  WHERE MAX(STOCKQTY) > 10


  

/*
 - 다차원 집계함수 
   . 주어진 데이터 를 활용하여 좀더 복잡하고 유용한 집계 결과를 반환하는데 사용.
 
 
1) GROUP BY ## with rollup
  - 전체합계와 소그룹 간의 소계를 계산하는 ROLLUP 함수 */
	  
  -- 1.  GROUP BY  with rollup  의 예1 (단일컬럼) 
  -- 1-1 일자 별 총 입출 수량 
   SELECT INOUTDATE,
  	      SUM(INOUTQTY) AS SUMQTY
     FROM t_Stockhst 
    WHERE INOUTDATE > '2022-11-01'
 GROUP BY INOUTDATE;
  
   -- 1-2 일자 별 총 입출 수량 과 합계
   SELECT INOUTDATE, 
   	   SUM(INOUTQTY) AS SUMQTY
   FROM t_Stockhst 
   WHERE INOUTDATE > '2022-11-01'
   GROUP BY INOUTDATE with rollup 
  order by INOUTDATE desc;
 

   -- 2.  GROUP BY ROLLUP 의 예2 (다중 컬럼) 
  -- 2-1 일자 별 품목 총 입출 수량 
   SELECT INOUTDATE,
		  ITEMCODE,
  	      SUM(INOUTQTY) AS SUMQTY
     FROM t_Stockhst 
    WHERE INOUTDATE > '2022-11-01'
 GROUP BY INOUTDATE,ITEMCODE
order by INOUTDATE,ITEMCODE ;
  
-- 2-2 일자 별 품목 총 입출 수량 과 합계
   SELECT INOUTDATE,
		  ITEMCODE,
  	      SUM(INOUTQTY) AS SUMQTY
     FROM t_Stockhst 
    WHERE INOUTDATE > '2022-11-01'
 GROUP BY INOUTDATE,ITEMCODE with rollup;
 -- 일자 품목별 합계   +  일자 별 품목의 소합계(sub Total)  +  총합계(grand Total)

			 -- NULL 컬럼에 합계에 관련 글귀 입력 예제 
  			 -- IFNULL : null 일 경우 임시로 원하는 데이터 로 대체하여 표현하는 mysql 내장 함수
			    SELECT IFNULL(INOUTDATE,'총합')  AS INOUTDATE,
			  		   IFNULL(ITEMCODE,'계') 	 AS ITEMCODE,
		  	       SUM(INOUTQTY) 			     AS SUMQTY
			     FROM t_Stockhst 
			    WHERE INOUTFLAG = 'I'
				  AND INOUTDATE > '2022-11-01'
			  GROUP BY  INOUTDATE,ITEMCODE with rollup ; 

			 
			 

-- 2-3 일자 별 품목 별 창고 별 수량 과 합계
-- 표현 컬럼이 3개 이므로 3 개의 분류로 합계를 구한다.
-- 1. 일자 별 품목 별 창고 별 수량 과 합계
-- 2. 일자 별 품목 별 수량 과 합계
-- 3. 일자 별 수량 과 합계
   SELECT INOUTDATE,
		  ITEMCODE,
		  WHCODE ,
  	      SUM(INOUTQTY) AS SUMQTY
     FROM t_Stockhst 
    WHERE  INOUTDATE > '2022-11-01'
 GROUP BY INOUTDATE,ITEMCODE,WHCODE with rollup; 



  