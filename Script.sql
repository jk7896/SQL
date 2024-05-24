#우리 회사에서 관리하는 모든 품목의 유형을 검색
#1. 품목의 유형의 데이터가 있는지 ? ->품목 마스터에 모든 품목의 유형이 무엇인지

select ITEMTYPE  from t_itemmaster ti; #품목의 모든 유형이 다 조회된다.

#2. 품목의 유형을 그룹화 해서 나타낸다.
select distinct ITEMTYPE  
	from t_itemmaster ti;
	#from where group having select distinct order
	#전체 리스트를 도출 한 후에 병합

  /* 단위가 KG 을 가질 수 있는 품목 유형을 검색 하세요.

     t_ItemMaster 테이블에서 BASEUNIT = 'KG' 인 데이터 의 					
     ITEMTPYPE 을 합병 후 검색  */			
	#1.중요데이터가 어느 테이블에 존재하는가?

  SELECT DISTINCT ITEMTYPE 					
  		     FROM t_ItemMaster			
  		    WHERE BASEUNIT = 'KG';		
  		    
 
#여러 컬럼을 병합할때
#데이터가 동시에 중보고디는 행을 그룹화한다.
#~ 별 ~의 데이터
  		   
#단위가 kg을 가지는 품목 유형별 창고를 나타나세요.
select distinct ITEMTYPE ,
				WHCODE  
	from t_itemmaster ti
	where BASEUNIT ='EA'
	order by itemtype,whcode;
	
 /*
  * 우리회사에서 관리한느 품목 중 단위가 'EA'이고 규격(spec)정보가 있는 품목의 품목구분 별 규격을 검색
  * */		   
  	
select ITEMTYPE ,
		spec  
	from t_itemmaster ti
	where BASEUNIT ='EA' 
	and SPEC is not null 
	order by itemtype,whcode;
  		   
  		   
  		   
   /****** 실습 *******	
	규격(SPEC)이 'DS-PLT'로 시작하는 품목들의 유형별 관리 창고를 검색
  */

  SELECT DISTINCT ITEMTYPE
				 ,WHCODE
             FROM t_ItemMaster
		    WHERE SPEC  LIKE 'DS-PLT%' ;				   
  		   
  		   
  	
/**********************************************************************************************/
/*
 * 2. 데이터합병 검색(group by) .중요도(***************)
 *  .GROUP BY 할 컬럼의 데이터를 그룹화  --distince 동일
 * 	.GROUP BY 된 데이터를 조건으로 필터링(HAVING) -- 그룹바이에 조건으로 사용가능   --distince와 차이
 * 	****집계 함수와 혼용하여 사용 할 수 있다.  --distince 와 차이
 * 
 * */

#group by의 기본 유형 품목 테이블에서 품목 구분만 검색
select	ITEMTYPE
	from t_itemmaster ti  
	group by ITEMTYPE; #(distince와 같은결과)
	# from -> group by -> select
  	# --> 1. 품목들의 모든 정보 중에 itemtype 컬럼만 추출
  	# --> 2. 추출된 itemtype컬럼을 병합하여 그룹화
  	# --> 3. 2)의 결과에서 itemtype을 표현
	
	
#where 조건절이 혼용되는 경우
#wh003 창고에 관리되는 품목의 유형
select ITEMTYPE 
	from t_itemmaster ti 
	where WHCODE  = 'wh003'
	group by ITEMTYPE; 
	# from -> where -> group -> select
 		   
#주의 !!!! 
#select로 표현할 컬럼은 반드시 group by로 그룹화가 되어있어야 한다.
select ITEMTYPE
	from t_itemmaster ti 
	where WHCODE  = 'wh003'
	group by spec;
# spec을 병합한 리스트에서 ITEMCODE를 표현하려고 하는 문제가 발생하여 오류를 반환한다.
# 정상적인 구문
select spec
	from t_itemmaster ti 
	where WHCODE  = 'wh003'
	group by spec;

#오류를 반환하는 유형
#리스트에 있는 컬럼과 없는 컬럼을 표현하려고 할 때 
select ITEMCODE ,
		WHCODE 
from t_itemmaster ti 
where WHCODE ='wh003'
group by ITEMCODE ;
  		   
#정상구문
select SPEC ,WHCODE  
from t_itemmaster ti
where WHCODE ='wh003'
group by SPEC,WHCODE  ;
 
/*
 * 실습    [point1]
 * 매장재고(t_stock)
 * 현재수량(stockqty)이 1500 이상이고
 * 등록일시(makedate) '2022-08-01' 부터 '2023-08-01' 사이인 재고
 * 등록일시 별 품목으로 나타내세요
 * */
  SELECT ITEMCODE 
          ,`MAKEDATE`
      FROM t_Stock
	 WHERE STOCKQTY >= 1500
	   AND `MAKEDATE` >='2022-01-01'  and `MAKEDATE` <='2023-08-01'
  GROUP BY ITEMCODE,MAKEDATE; 
 		   
  		   
  		   
 /*
  * [poin2]
  * GROUP BY된 리스트의 목록을 필터링 하는 조건문
  * 	>HAVING : GROUP BY 다음에 처리한다.
  * */		   
  		   
  /*
   * 우리매장에서 관리하는 품목 중에 최대 재고수량(maxstock)컬럼의 데이터가 2000을 초과하는 품목의
   * 품목유형(ITEMTYPE)별 수입검사여부(InspFlag)를 나타내고 
   * 수입검사 여부가 I,U인 데이터를 검색
   * */		   
  
 # 1. 품목마스터테이블에서 maxstock이 2000을 초과하는 리스트 생성
  	# 2. 1의 결과에서 ITEMTPE컬럼과 InspFlag 컬럼을 따로 추출
  	# 3. 2를 진행하면서 inspflag가 i,u인 품목만 그룹에 등록
 
  SELECT ITEMTYPE
  		,INSPFLAG 	
        FROM t_ItemMaster					
	   WHERE MAXSTOCK > 2000  
    GROUP BY ITEMTYPE,INSPFLAG 	
	  HAVING INSPFLAG in ('I','U'); 	
	
  	

	 
# 주의 !!!!!
# HAVING을 실행할 컬럼은 반드시 GROUP BY를 통해 병합될 컬럼이어야 한다.
select *	
	from t_itemmaster ti
	group by SPEC , WHCODE 
	having ITEMCODE ='HALB';
	 
#작동이 되게 수정된 코드	 
select SPEC , WHCODE 
	from t_itemmaster ti
	group by SPEC , WHCODE 
	having WHCODE ='wh003';	  #group by 하려는 대상의 컬럼에 조건을 설정
	 

/*
 * [point1]의 내용은 GROUP BY이지만 DISTINCT로 사용도 가능
 * */
SELECT distinct ITEMCODE 
          ,`MAKEDATE`
      FROM t_Stock
	 WHERE STOCKQTY >= 1500
	   AND `MAKEDATE` >='2022-01-01'  and `MAKEDATE` <='2023-08-01';
  #GROUP BY ITEMCODE,MAKEDATE; 	 
/*
 * [point2]의 내용은 HAVING을 사용하지 않고도 가능
 * */	 
SELECT distinct SPEC 
  		,WHCODE  	
        FROM t_ItemMaster					
	   WHERE WHCODE ='wh003'; 
    #GROUP BY ITEMTYPE,INSPFLAG 	
	  #HAVING INSPFLAG in ('I','U'); 		 
	 
	 
#왜 GROUP BY와 HAVING을 사용할까
/*
 * 3. 집계 함수와 GROUP BY
 *  -특정 컬럼의 여러 행에 있는 데이터로 집계연산 후 하나의 결과를 변환하는 함수
 *	  >N개의 데이터를 연산 처리 후 결과를 반환하는 함수
 *	 SUM()   : 병합되는 컬럼의 데이터를 모두 합한다.					
     MIN()   : 병합되는 컬럼의 데이터 중 가장 작은 수를 나타낸다.					
     MAX()   : 병합되는 컬럼의 데이터 중 가장 큰 수를 나타낸다.					
     COUNT() : 병합되는 컬럼의 행 개수를 나타낸다.
     AVG()   : 병합되는 컬럼의 숫자 데이터값의 평균을 나타낸다.	
     
     *집계함수에서 처리되는 컬럼은 GROUP BY내역에 포함 되지 않아도 된다.
     >함수의 특성고 ㅏ기능에 의해 GROUP BY대상 리스트에 없어도 연산처리 가능
 *
 * */	 
	 
/*품목 구분 itmetype이 제품 'fert'인 데이터의 단가(UNITCOST) 총합*/	 	 
select sum(UNITCOST) as FERT_SUM_UNITCOST
from t_itemmaster ti 
where ITEMTYPE ='FERT';
#품목 구분이 제품인 그룹이 형성 되어 있으므로 집계함수 단독을 사용 가능

#집계함수와 group by
#품목별 입/출 횟수을 검색
select ITEMCODE 
		,count(*) as ITEMINOUT_CNT
from t_stockhst ts  #품목별 입출이력을 표시
group by ITEMCODE;
	 
# 품목별로 횟수를 검색하고자 하므로 group by를 통해서 품목코드에대한 그룹을 먼저 만들어 주고,
#그 그룹에서 건별 입출횟수를 구하는 함수가 동작

select * from t_stockhst ts  where ITEMCODE ='64354/64-D3000B';

/*GROUP BY로 그룹을 지정하지 않으면 집계함수처리해야 할 대상에 대한 기준이 모호해지므로
 * 오류를 반환한다.
 */
select ITEMCODE ,
		count(*) as stockqty
from t_stockhst ts ;
#where ITEMCODE ='64354/64-D3000B'; #이 코드를 추가하면 코드가 작동된다. (명확한 기준 그룹이 필요하다.)
#group by ITEMCODE #이 코드를 추가하면 코드가 작동된다. (명확한 기준 그룹이 필요하다.)

#ITEMCODE ='64354/64-D3000B'라는 명확한 단일 그룹이 생성

#집계함수의 예제(사용)
#입출이력의 품목별 입출수량 평균
select ITEMCODE ,
		avg(INOUTQTY) as avgqty
from t_stockhst ts 
group by ITEMCODE ;


select ITEMCODE ,
		max(INOUTQTY) as avgqty
from t_stockhst ts 
group by ITEMCODE ;

select ITEMCODE ,
		min(INOUTQTY) as avgqty
from t_stockhst ts 
group by ITEMCODE ;
#집계함수 Count(*)테이블 행의 개수
#조회된 데이터의 모든 행을 조회하기 위해 *를 많이 사용
#Count(ItemCode) : 컬럼이 기재되어 있을 경우
#	> ItemCode컬럼 데이터가 null이 아닌 상태의 개수를 반환
select count(*) from t_itemmaster ti ;
select count(spec) from t_itemmaster ti ;

/* 동일한 그루벵 집계함수를 여러번 사용하여 원하는 결과를 검색 할 수 있다.
 * 품목 구분 별 단가의 합, 최소금액을 보고 싶을때
 */

select ITEMTYPE 
		,sum(UNITCOST) as totalsum
		,max(UNITCOST) as `maxvalue`
from t_itemmaster ti 
group by ITEMTYPE ;

/* 1. 유형별로 group리스트 생성
 * 2. 그룹에 있는 품목유형별로 from where조건절을 만족하는 데이터에서
 * 		unitcost컬럼의 N개 데이터합산.
 * 3. 그룹에 있는 품목유형별로 from where조건절을 만족하는 데이터에서
 * 		unitcost컬럼의 N개 최대값 도출.
 * 4. 결과를 표현.
 * 
 */




-- ** 집계 함수를 사용한 결과의 조회 조건 처리 후 정렬
-- 병합 된 결과에서 HAVING 조건 절을 추가 후 표현하고 특정 컬럼으로 정렬
 
   /* t_ItemMaster 테이블 에서 UNITCOST 가 10000 이상인 데이터 를 가진 행중
       ITEMTYPE 별로 unitcost 1000000 을 초과 하는 행의 
       ITEMTYPE 컬럼, UNITCOST 의 합, UNITCOST 의 최대값 을 나타내고
       UNITCOST 최대값 을 기준으로 오름차순 하여 표현하라. */ 
/*단가(UNITCOST)가 10000이상인 품목중
 * 품목구분 별 단가의 합이 1,000,000초과하는 품목을 품목 구분별로 단가의 총합과 최대값을 조회하고 단가 총합을 기준을 내림차순으로 표현
 */
      SELECT ITEMTYPE,					
 	         SUM(UNITCOST) AS UNITCOST_SUM, #단가의 총합		
 			 MAX(UNITCOST) AS UNITCOST_MAX	#단가중 최고값
        FROM t_ItemMaster
	   WHERE UNITCOST >= 10000
    GROUP BY ITEMTYPE			
      HAVING SUM(UNITCOST)>1000000 					
    ORDER BY UNITCOST_SUM desc;    		
/* HAVING SUM(UNITCOST)>1000000 					
    ORDER BY UNITCOST_SUM desc;    는 mysql DB의 특성에 유연한 코드를 할 수 있도록 지원해 주는 기능
    								표준 SQL 문법을 따르지 않는 코드이므로 권장하지는 않는다.
 * */


/*데이터베이스에 처리되는 절차
 * 프리웨어를 구하세요
 * from were groupby having select orderby
 * 
 * 1. 품목테이블에서 unitcost가 10000을 초과하는 데이터 추출
 *    select * from t_itemmaster where UNITCOST > 10000;
 * 
 * 2. 1의 결과에서 품목마스터에서 itemtype컬럼만 병합한 테이블을 별도로 생성
 * 3. 2의 결과에서 그룹화 진행중 sum(unitcost)의 값이 1000000을 초과하는 그룹만 추출
 * 4. select 단위별 수행
 *   >3의 결과 리스트에서 ITEMTYPE추출
 *   > itemtype별 sum(unitcost)함수 수행
 *   >3리스트 마지막가지 반복
 * 5.결과를 총합기준으로 내림차순 정렬 order by desc
 *   >select를 수행하고 sum(unitcost)의 별칭이 주어지므로
 *    order by 명령이 UNITCOST_SUM의 컬럼이름으로 정렬이 된다.
 */
	 
	 
	 
/* 정리
 * 1. 집계함수는 group by와 함께 사용하여 통계적 데이터를 가공하는데 큰 편의성을 제공한다.
 * 2. 집계함수의 결과 조건을 사용하지 않을경우 group by와 distince의 차이는 없다.
 * 3. having 절에서 사용한 집계함수는 그룹을 만들 필터링을 위하여 조건으로 사용
 */
   
   
   
 /*실습 [point3]
  * '2023-01-02' 일로부터 현재까지
  * 창고별로 2번이상 입고된 품목의 총 횟수(count)와 총입고수량(sum)을 조회하고
  * 수량의 총 합을 오름차순으로 표현하세요
  * 
  * 창고별 품목의 총입고횟수, 입출 수량의 총합
  */  
   
select WHCODE
		,ITEMCODE 
		,count(*) as cnt
		,sum(INOUTQTY) as qty_sum
	from  t_stockhst ts 
   where `MAKEDATE` >='2023-01-02' and INOUTFLAG  ='I'
group by WHCODE ,ITEMCODE 
	having count(*)>=2
order by WHCODE ,qty_sum asc;
	 




/*
 * 다차원 집계함수
 * 활용도가 높지는 않다.
 * .주어진데이터를 활용하여 좀더 복잡하고 유용한 집계결과를 반환하는데 사용
 */

# 1) GROUP BY - WITH ROLLUP  의 예1 (단일컬럼) 
	# 전체 합계와 소 그룹간의 소계를 집계하여 표현
  -- 1-1 일자 별 총 입출 수량 
   SELECT INOUTDATE,
  	      SUM(INOUTQTY) AS SUMQTY
     FROM t_Stockhst 
    WHERE INOUTDATE > '2022-11-01'
 GROUP BY INOUTDATE 
 order by INOUTDATE desc;
  
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


-- 3.예제 : 일자별 품목의 총 입출수량(레포트 형식처럼 바꾸기)
#ifnull() : null 일 경우 표현하고자 하는 키워드
select ifnull(INOUTDATE,'총합')as INOUTDATE ,
		ifnull(ITEMCODE,'일자별 소개') as INOUTCODE ,
		sum(INOUTQTY) as SUMQTY
from t_stockhst ts 
 WHERE INOUTDATE > '2022-11-01'
 GROUP BY INOUTDATE,ITEMCODE with rollup
order by INOUTDATE;

#연산처리순서
#1.t_stock 테이블의 모든 데이터를 메모리에 등록(조회)
select * from t_stock ts ;
/*2.select 가 하나씩 표현
 * select itemnaem form t_itemmaster ti where itemcode='';
 * select itemnaem form t_itemmaster ti where itemcode='';
 * .......168
 * select itemnaem form t_itemmaster ti where itemcode='';
 * 
 * 
 * select *from t_stock;을 조회 하는 select와 ITEMNAME을 조회하는 SELECT가 168수행되어
 * 총 169의 SELECT를 수행한다.
 * 비효율적인 코딩일 될 수 있다.
 * 대량의 데이터를 가공할 경우는 사용하는 것을 권장하지 않는다.
 */

/* FROM절의 하위쿼리
 * FROM절에는 테이블의 명령이 되는 것이라 생각하지만 테이블 명칭 자체도 데이터의 집합
 * 데이터의 집합을 SELECT구문으로 만들어 FROM절에 테이블 처럼 참조하도록 할 수 있다.
 * 	>조회 해야 하는 비교 대상에 미리 필터링 해두어 성능의 향상을 바랄 수 있다.
 *  >테이블화 한 묶음에 임의로 명칭을 병 해 주어야 한다.
 */


select *
from (select ITEMCODE ,ITEMNAME ,ITEMTYPE  
		from t_itemmaster ti 
		where ITEMTYPE ='HALB') as A ;


/*실습
 * 재고 입출이력에서 (t_stockhst) 창고별 입출 횟수가 가장많은 창고 와 횟수를 구하세요
 * group by,having,having 하위쿼리
 */
 SELECT WHCODE , 
             COUNT(*) AS CNT
         FROM t_Stockhst
     GROUP BY WHCODE
       HAVING COUNT(*) = (SELECT MAX(CNT)
  						  FROM (SELECT WHCODE,
  								       COUNT(*) AS CNT
 								  FROM t_Stockhst
  							  GROUP BY WHCODE )A) ;
#1.창고별 입출 횟수
SELECT WHCODE,
	    COUNT(*) AS CNT
 		FROM t_Stockhst
  		GROUP BY WHCODE  								   

#2.
SELECT MAX(CNT)
  	FROM (SELECT WHCODE,
  			COUNT(*) AS CNT
 			FROM t_Stockhst
  			GROUP BY WHCODE )A


#3.
SELECT WHCODE , 
             COUNT(*) AS CNT
         FROM t_Stockhst
     GROUP BY WHCODE
       HAVING COUNT(*) = (SELECT MAX(CNT)
  						  FROM (SELECT WHCODE,
  								       COUNT(*) AS CNT
 								  FROM t_Stockhst
  							  GROUP BY WHCODE ) A) ;



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





/*실습
 * [point3]의 문제 HAVING 조건에 의해 집계함수가 한번수행 되고 SELECT절에서 집계함수가 또 수행된다.
 * 하위 쿼리를 통해 데이터의 내용을 미리 작성해 두고(대조군의 볼륨을 줄인다.) 정보를 추출 할 수 있도록 하여 성능 향상을 할 수 있는 기법으로 활용 할 수 있다.
 * select WHCODE
		,ITEMCODE 
		,count(*) as cnt
		,sum(INOUTQTY) as qty_sum
	from  t_stockhst ts 
   where `MAKEDATE` >='2023-01-02' and INOUTFLAG  ='I'
group by WHCODE ,ITEMCODE 
	having count(*)>=2
order by WHCODE ,qty_sum asc;
 */

#1. t_stockhst에서 조건에 따른 기본 데이터 조회
select *
from t_stockhst ts 
where INOUTFLAG ='I'
and INOUTDATE >='2023-01-02';

#2.조회된 결과에서 ITEMCOD 별 WHCODE그룹 생성
select ITEMCODE ,WHCODE 
from t_stockhst ts 
where INOUTFLAG ='I'
and INOUTDATE >='2023-01-02'
group by ITEMCODE ,WHCODE ;

#3.그룹결과에서 총 수량과 합을 구하는 집계함수 생성
select *
from(
select ITEMCODE as itemcode ,WHCODE as whcode,count(*)as cnt,sum(INOUTQTY) as sum_qty
from t_stockhst ts 
where INOUTFLAG ='I'
and INOUTDATE >='2023-01-02'
group by ITEMCODE ,WHCODE)A 
where cnt>2 ;









	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   
  		   