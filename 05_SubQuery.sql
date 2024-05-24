

  					
  /*********************************************************************************************************************
    7. 하위 쿼리 (서브 쿼리)
    - 쿼리 안의 쿼리 
	- 일반적으로 SELECT 절,  FROM 절, WHERE 절 등에 사용된다.

	장점 : SQL 구문 안에서 유연하게 또 다른 SQL문을 만들어 활용할 수 있다.
    단점 : 쿼리가 복잡해진다.  
	

	1. 서브쿼리를 괄호로 감싸서 사용한다.
    2. 서브쿼리는 단일 행 또는 복수 행 비교 연산자와 함께 사용 가능하다.
    3. 서브쿼리에서는 ORDER BY 를 사용하지 못한다.

	*/	 


  -- ** 하위 쿼리를 통한 데이터의 조회 (WHERE)

  /* t_Stockhst 테이블에서LOTNO 가 'LTM-03-22198912' 인 ITEMCODE 의 정보를 
     t_ItemMaster 테이블 에서 조회하여 ITEMCODE,ITEMNAME,ITEMTYPE,SPEC 컬럼으로 검색.  */
  SELECT ITEMCODE
        ,ITEMNAME
		,ITEMTYPE
		,SPEC
    FROM t_ItemMaster
   WHERE ITEMCODE =  (SELECT ITEMCODE 
                        FROM t_Stockhst 
					   WHERE LOTNO = 'LTM-03-221989121');

 

 /* t_Stockhst 테이블에서 LOTNO 가 'LTM-03-22198912' 인 ITEMCODE 값을 포함하지 않는 데이터를 
    t_ItemMaster 테이블 에서 조회하여 ITEMCODE,ITEMNAME,ITEMTYPE,SPEC 컬럼으로 검색.  */
  SELECT ITEMCODE
        ,ITEMNAME
		,ITEMTYPE 
		,SPEC
    FROM t_ItemMaster
   WHERE ITEMCODE <> (SELECT ITEMCODE 
                        FROM t_Stockhst 
					   WHERE LOTNO = 'LTM-03-221989121');


 -- ** '=' 인 조건에는 두개 이상의 값이 나오는 하위쿼리 내용을 적용 할 수 없다. 
     SELECT ITEMCODE
        ,ITEMNAME
		,ITEMTYPE
		,SPEC 
    FROM t_ItemMasteree
   WHERE ITEMCODE =  (SELECT ITEMCODE 
                        FROM t_Stockhst 
					   WHERE INOUTFLAG = 'I') ;
    -- t_Stockhst 테이블에 INOUTFLAG 가 'I' 값을 가지는 데이터가 2개 이상이므로 오류가 발생. 

					  
					  

  -- ** 두개 이상인 데이터를 하위 쿼리로 적용 하는 방법 ? IN, NOT IN 

   /*  t_Stockhst (자재 입출이력) 테이블에서 
	   REMARK 가 NULL 이 아니면서  
	   INOUTQTY 가 1000 개 이상이면서
	   INOUTFLAG 가 I(입고이력) 인 ITEMCODE 를 병합하고 ITEMCODE 관련 정보를 
	   t_ItemMaster 에서 ITEMCODE, ITEMNAME, ITEMTYPE   내역으로 검색.*/ 
  SELECT ITEMCODE
        ,ITEMNAME
		,ITEMTYPE  
    FROM t_ItemMaster
   WHERE ITEMCODE IN (SELECT DISTINCT ITEMCODE 
					    FROM t_Stockhst 
					   WHERE REMARK IS NOT NULL
					     AND INOUTFLAG = 'I'
					     AND INOUTQTY >= 200) ;
					     

  -- ** 하위 쿼리의 하위쿼리. 
   /* '2022-10-31' 일 입고된 품목의 LOTNO 에 대한 품목 코드 를 자재 재고 현황에서 찾고
    * 해당 품목의 품목코드,품명, 품목타입 에 대한 정보를 나타내시오.
    */
   SELECT ITEMCODE
        ,ITEMNAME
		,ITEMTYPE 
    FROM t_ItemMaster
   WHERE ITEMCODE IN (SELECT ITEMCODE 
                        FROM t_Stock
					   WHERE LOTNO	 IN (SELECT LOTNO 
					                       FROM t_Stockhst
										  WHERE INOUTDATE = '2022-10-31')); 

										 
										 
										 
    -- ** 하위 쿼리를 통한 데이터의 조회 (SELECT)
   /*  
	  LOTNO : 생산 또는 구매시 생산 품 또는 원자재 등의 묶음 단위

	  t_Stock 테이블에서 ITEMCODE, LOTNO, STOCKQTY 컬럼의 데이터를 검색하고
	  품목 마스터 에서 품명(ITEMNAME) 의 정보를 조회하여 표현
   */
   -- [POINT 4]
   SELECT ITEMCODE
		 ,(SELECT ITEMNAME FROM t_ItemMaster WHERE ITEMCODE = A.ITEMCODE ) AS ITEMNAME
		 ,LOTNO 
		 ,STOCKQTY 
     FROM t_Stock A;

   -- [POINT 4] 의 연산 순서
   -- 1. t_Stock 테이블 에서 지정 컬럼 데이터 추출. 
	SELECT ITEMCODE 
		  ,LOTNO  
		  ,STOCKQTY 
     FROM t_Stock A;


   -- 2. 1에서 조회 된 ITEMCODE 별 ITEMNAME 를 T_ITEMMASTER 에서 건별 조회  
   
   SELECT ITEMNAME  
     FROM t_ItemMaster 
	WHERE ITEMCODE = '65774-C3000-02W';	 -- 65774-C3000-02W
										 -- 66735-B1000-08W
										 -- 64341-B1000-02W
										 -- 64353-D3000-04W
										 -- 64364-D3000P
										 -- 64371-D3000-01W
										 -- 71711-1R000-04W
										 -- 71721-1R000-04W
										 -- 71711-1R000-04(CKD)W
										 -- 64351-3X000W
										 -- 64319-2W000C
										 -- 65676/86-3Z000B
										 -- 71233/43-4F000C
										 -- .... 201 건의 ITEMCODE

	-- **** 주의 ***** 
	-- 기준테이블 t_Stock 에서 조회 1번  하위 쿼리 에서 총 201번 하여 총 202번의 검색 연산이 실행된다 
    -- 간단한 조회문일 경우 무리없이 수행 되는것 처럼 보이지만 효율은 좋지 않다.
	-- 대량의 데이터를 가공 할 경우 오랜 시간이 소요 될 가능성이 있다. 
	  
	
	
	

-- SELECT 구문을 FROM  위치에 두는 경우. 
-- FROM 에 오는 테이블 형식처럼 임시 테이블 을 쿼리로 작성하여 조회 가능. 
-- 가공 한 데이터를 테이블 형식으로 사용 할 수 있다. 
-- 테이블의 묶음단위 뒤에 테이블의 이름 부여해야한다. 

SELECT ITEMCODE
      ,ITEMNAME
	  ,ITEMTYPE
  FROM (SELECT ITEMCODE	
		      ,ITEMNAME
			  ,ITEMTYPE
          FROM t_ItemMaster
		 WHERE ITEMTYPE = 'HALB') A    

		 
		 
		 

  /**** 실습.
   입출이력(t_Stockhst) 테이블 에서 창고(WHCODE) 별  입출 횟수 가 가장 많은 창고 와 횟수를 구하시오
   GROUP BY 사용
  */ 

     SELECT WHCODE , 
            COUNT(*) AS CNT
        FROM t_Stockhst
    GROUP BY WHCODE
      HAVING COUNT(*) = (SELECT MAX(CNT)
 						  FROM (SELECT WHCODE,
 								       COUNT(*) AS CNT
 								  FROM t_Stockhst
 							  GROUP BY WHCODE ) A ) ;


 /**** 실습 2 
  * 위 실습에서 구한 결과 창고 의 총 입출 수량을 구하시오.  (1 번결과 N 행 일경우 를 감안한 로직 구현) 
  */							  
 SELECT WHCODE 
       ,SUM(INOUTQTY) AS INOUTQTY
   FROM t_Stockhst 
  WHERE WHCODE IN (SELECT WHCODE 
        			 FROM t_Stockhst
				 GROUP BY WHCODE
      			   HAVING COUNT(*) = (SELECT MAX(CNT)
 						  				FROM (SELECT WHCODE,
 								       				 COUNT(*) AS CNT
 								  				FROM t_Stockhst
 							  				GROUP BY WHCODE ) A ))	
 GROUP BY WHCODE;
 							 
 
				  
		 

/****  실습3 
   앞서 진행 했던 실습. [POINT 3] 을 FROM 위치에 테이블 처럼 가공한 SELECT 구문을 사용하여 HAVING 를 쓰지 않고 표현하기.
   '2023-01-02' 일 부터 현재까지
   창고별(WHCODE) 로 2번 이상 입고 된 품목(ITEMCODE) 의 입고 횟수 와 총 입고 수량(INOUTQTY) 을 조회 하고 
   창고별 입고 수량 합 을 오름차순하여 표현하세요
     * 대상 테이블 입출 이력 테이블 : t_stockhst
     * 입고 여부 : INOUTFAG = 'I' 

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
  */ 

				  
				  

-- 1. t_Stockhst테이블 에서 조건에 따른 결과 데이터 행 조회
  SELECT * 
    FROM t_Stockhst 
   WHERE INOUTDATE > '2023-01-01'
     AND INOUTFLAG = 'I';

-- 2. 조회 된 결과 에서 ITEMCODE 별 WHCODE 그룹 생성
  SELECT ITEMCODE , WHCODE
    FROM t_Stockhst 
   WHERE INOUTDATE > '2023-01-01'
 	 AND INOUTFLAG = 'I'
GROUP BY ITEMCODE,WHCODE;

-- 3. t_Stockhst 테이블 에서 2에서 생성된 ITEMCODE,WHCODE 그룹 별 COUNT, SUM 연산 
   SELECT ITEMCODE 
         ,WHCODE 
         ,COUNT(*)      AS CNT
         ,SUM(INOUTQTY) as SUM_QTY
      FROM t_Stockhst 
    WHERE INOUTDATE > '2023-01-01'
      AND INOUTFLAG = 'I'
  GROUP BY ITEMCODE,WHCODE;


-- 4. 처리된 결과 에서 CNT 가 2 이상인 데이터 검출
	 SELECT *
	   FROM (SELECT ITEMCODE 
			       ,WHCODE 
			       ,COUNT(*) AS CNT
			       ,SUM(INOUTQTY) as SUM_QTY
		       FROM t_Stockhst 
			  WHERE INOUTDATE > '2023-01-01'
			    AND INOUTFLAG = 'I'
		   GROUP BY ITEMCODE,WHCODE) AS MMREC
	  WHERE CNT >= 2;

-- 5. 결과 에서 INOUTDATE,WHCODE, CNT 컬럼 표현.
	 SELECT ITEMCODE
		   ,WHCODE
		   ,CNT
		   ,SUM_QTY
	   FROM (SELECT ITEMCODE 
			       ,WHCODE 
			       ,COUNT(*) AS CNT
			       ,SUM(INOUTQTY) as SUM_QTY
		       FROM t_Stockhst 
			  WHERE INOUTDATE > '2023-01-01'
			    AND INOUTFLAG = 'I'
		   GROUP BY ITEMCODE,WHCODE) AS MMREC
	  WHERE CNT >= 2

