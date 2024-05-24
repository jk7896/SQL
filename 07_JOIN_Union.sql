/*
 * JOIN
 * 관계형 데이터 베이스를 사용하기 위한 가장 중요한 문법
 * 
 * 테이블 간 데이터 연결 및 조회(JOIN)
 * 	.ON : 두 테이블간의 관계를 설정할 조건 절
 * -내부조인(inner join)
 * 	.JOIN : 관계를 가지는 테이블의 데이터 둘다 존재 해야함. 
 * 
 * -외부조인(outer join)
 * 	.기준테이블의 모든 값이 포함된 결과에서 부가적인 정보를 환인하기 위해 사용
 * 	.LEFT JOIN : 기준 테이블을 좌측에 기술한 테이블로 둘때 
 * 	.RIGHT JOIN : 기준 테이블을 우측에 기술한 테이블로 둘떄
 * 
 * >기준테이블 : 테이블 간 데이터를 연계할때 많은 정보를 포함하거나 반드시 표현해야 하는 데이터가 포함된 테이블
 */

#innser join
#그냥 JOIN으로 표현 가능

select * from t_fruitmaster tf ; #고객마스터(정보)
select * from t_customer tc ; #과일 마스터(정보)
select * from t_orderlist to2 ; #판매이력
select * from t_saleshst ts ; #과일 발주이력


#판매이력에 있는 고객의 id와 이름과 과일 종류를 표현

select A.Cust_Id 
		,B.name
		,A.fruit 
		,A.amount 
from t_saleshst A join t_customer B   #연결 할 테이블을 기술 (좌/우)
					on A.Cust_Id = B.Cust_Id  ; #연결 할 기준을 기술,조건을 통한 필터링

#내부조인은 두테이블 모두 데이터가 존재해야 표현
#확실히 데이터가 존재 할 경우에 inner join(기준정보)  두가지가 모두 존재 할 때 사용
select tc.Cust_Id
		,tc.Name 
		,ts.fruit 
		,ts.amount 
from t_customer tc  inner join t_saleshst ts  on tc.Cust_Id =ts.Cust_id ;



#inner join의 묵시적 표현방법
#join문을 명시하지 않고 테이블을 나열하여 작성하는 방식
select *
from t_customer tc ,t_saleshst ts #join(=inner join)을 묵시적으로 표현
where tc.Cust_Id =ts.Cust_id ;


# 실습 ############################################
-- 위 쿼리 내용을 참조 하여 과일 정보 테이블 t_fruitmaster 를 INNER join 을 활용하여 
-- 일자 별 판매 현황을 조회해 보세요
-- 고객ID, 고객명, 과일명, 판매수량, 판매일자.

select tc.Cust_Id 
		,tc.Name 
		,ts.fruit  
		,tf.FruitName 
		,ts.amount 
from t_saleshst ts  join t_customer tc  on ts.Cust_Id =tc.Cust_Id 
					join t_fruitmaster tf  on ts.fruit = tf.Fruit ;




#OUTER JOIN (외부조인)
#1.LEFT JOIN 2.RIGHT JOIN 외부조인
/*
 * LEFT JOIN
 * 왼쪽에 기술한 테이블을 기준으로 모든 데이터를 연결하여 표현
 * 1.왼쪽테이블의 모든 내용을 표현
 * 2.오른쪽 테이블에서 관련 데이터 검색후 있으며 표현, 없으면 null
 * 
 * 고객을 기준으로 판매 현황을 보고 싶을때
 * 고객 마스터에 있는 모든 내용을 기준을 ㅗ판매 내역이 있으면 보여주고, 없으면 null로 변환
 */

select tc.Cust_Id 
		,tc.Name 
		,ts.`date` 
		,ts.fruit 
		,ts.amount 
from t_customer tc left join t_saleshst ts  on tc.Cust_Id =ts.Cust_id ;




#판매현황별 고객 리스트
select tc.Cust_Id 
		,tc.Name 
		,ts.`date` 
		,ts.fruit 
		,ts.amount 
from t_saleshst ts left join  t_customer tc on ts.Cust_id = tc.Cust_Id;




#right JOIN
#기준데이블을 오른쪽에 기술한 테이블로 둔다.
#고객별 판매 현황 리스트
select tc.Cust_Id 
		,tc.Name 
		,ts.`date` 
		,ts.fruit 
		,ts.amount 
from t_saleshst ts right join  t_customer tc 
					on ts.Cust_id = tc.Cust_Id;



/*
 * 내부 조인과 외부 조인의 차이
 * 두 테이블간에 데이터가 상호 존재 할 경우 표현하느냐
 * 기준 테이블에 있는 데이터를 기준을 모두 표현 하느냐의 차이
 */



/******** 실습 ***********
	T_Stockhst 자재 입출 이력 중 REMARK(비고) 내역이 있고 (NULL 이아니고)
	ITEMTYPE(품목구분) 이 ROH 인
	입출 이력만 조회해 보세요.
	
	-- 표현 컬럼. 
	[입출일자], [입출순번], [품목],   [품명],   [입출수량],    [최소발주수량]
	INOUTDATE,  INOUTSEQ,   ITEMCODE, ITEMNAME,	ITEMQTY,       MINORDERQTY 정보를 나타내시오. 
	 */ 

#join하기 전에 데이터에서 조건
select ts.INOUTDATE 
		,ts.INOUTSEQ 
		,ts.ITEMCODE 
		,ti.ITEMNAME 
		,ts.INOUTSEQ 
		,ti.MINORDERQTY 
from t_stockhst ts  join t_itemmaster ti  
					on ts.ITEMCODE =ti.ITEMCODE 
					and ti.ITEMTYPE ='ROH'
where ts.remark is not null ;
	
#join하고 난 뒤에 데이터에서 조건
select ts.INOUTDATE 
		,ts.INOUTSEQ 
		,ts.ITEMCODE 
		,ti.ITEMNAME 
		,ts.INOUTSEQ 
		,ti.MINORDERQTY 
from t_stockhst ts  join t_itemmaster ti  
					on ts.ITEMCODE =ti.ITEMCODE 
where ts.remark is not null
and ti.ITEMTYPE ='ROH';

#leftjoin하고 난 뒤에 데이터에서 조건
select ts.INOUTDATE 
		,ts.INOUTSEQ 
		,ts.ITEMCODE 
		,ti.ITEMNAME 
		,ts.INOUTSEQ 
		,ti.MINORDERQTY 
from t_stockhst ts left join t_itemmaster ti  
					on ts.ITEMCODE =ti.ITEMCODE 
where ts.remark is not null
and ti.ITEMTYPE ='ROH';


#leftjoin하기 전에 데이터에서 조건
/*
 * join on 구문에 조건이 있을 경우 일단 -LEFT join의 성격에 의해 모든 데이터가 
 * 일단 연결이 되고 추가적인 조건이 where절에 오면서 결과를 보여줄데이터의 필터링정도가 약해진다.
 * 
 * where절에 조건이 있을경우 -모든 데이터엣 필터링이 2번 적용 되므로 걸러질 데이터가 더 많아 질 수 있다.
 * 	>두곳에 조건을 넣고 사용 할 수 있지만 결과가 다를 수 있다는 것을 인지하고 정확하게 사용
 */
select ts.INOUTDATE 
		,ts.INOUTSEQ 
		,ts.ITEMCODE 
		,ti.ITEMNAME 
		,ts.INOUTSEQ 
		,ti.MINORDERQTY 
from t_stockhst ts  left join t_itemmaster ti  
					on ts.ITEMCODE =ti.ITEMCODE 
					and ti.ITEMTYPE ='ROH'
where ts.remark is not null ;


# 다중 JOIN
  /* 사과를 제외한 판매현황 을 
     판매일자, 고객ID, 고객 이름,고객 연락처, 판매과일, 과일단가, 판매 금액 으로 나타내세요 */

SELECT 	ts.`DATE`					AS `DATE`			
        ,ts.CUST_ID			    	AS CUST_ID		
		,tc.NAME					AS NAME		
		,tc.PHONE			    	AS PHONE		
		,tf.FRUITNAME		    	AS FRUIT	
		,tf.unitprice 	        	AS unitprice		
		,tf.unitprice * ts.AMOUNT   AS total_price  
    FROM T_Saleshst ts LEFT JOIN T_Customer tc
	                         ON ts.CUST_ID    = tc.CUST_ID
					  LEFT JOIN t_fruitmaster tf
					         ON ts.fruit  = tf.Fruit 
   WHERE ts.`DATE` > '2023-12-03' 
     AND ts.FRUIT != 'AP' ;


/*
 * 고객별 과일의 총 계산 금액 구하기
 * 고객ID,고객명,과일이름,과일별 총계산액
 * 고객그룹
 */
#1. 고객별 과일 그룹구하기
select Cust_id ,fruit  
	from t_saleshst ts 
group cust_id,fruit;

#2.고객별 과일의 총 구매개수
select Cust_id 		 as Cust_id 
		,fruit 		 as fruit 
		,sum(amount) as fruitCNT
from t_saleshst ts  
group by Cust_Id ,fruit ;

#3.2에서 구한 내용에 살을 붙이기
select ts.Cust_id 		 as Cust_id 
		,tc.Name 		 as Name 
		,ts.fruit 		 as fruit
		,tf.FruitName    as fruitname
		,sum(ts.amount*tf.unitprice)  as fruitCNT
	from t_saleshst ts  join t_customer tc  
						on ts.Cust_id =tc.Cust_Id 
					join t_fruitmaster tf  
						on ts.fruit =tf.Fruit 
group by ts.Cust_Id ,ts.fruit,tc.Name,tf.FruitName ;



#고객별 과일의 총 구매횟수를 구하고 단가를 한번만 곱하는 쿼리
select A.cust_id
		,C.name
		,B.FruitName 
		,A.fruitCNT * B.unitprice  as custperFRUItCOST
	from (select Cust_Id
				,fruit
				,sum(amount) as fruitCNT
			from t_saleshst ts 
		group by Cust_id ,fruit )A left join t_fruitmaster B  
										on A.fruit=B.Fruit
										left join t_customer C
										on A.Cust_id=c.Cust_Id ;



#고객별 과일의 총 구매금액
/*
 * 고객별 총 구매 금액이 가장 큰 고객의 정보를 나타내세요
 * 고객ID,고객이름,고객주소,총 구매 금액
 */

select tc.Cust_Id 
		,tc.Name 
		,tc.Address 
		,tf.FruitName 
		,tf.unitprice*A.fruitCNT as totalcost 
from (select Cust_Id
				,fruit
				,sum(amount) as fruitCNT
			from t_saleshst ts
		group by Cust_id  ) A
					left join t_customer tc  ON A.Cust_id = tc.Cust_Id 
					left join t_fruitmaster tf  on A.fruit =tf.Fruit 
group by tc.Cust_Id ,tc.Name ,tc.Address ,tf.FruitName,tf.unitprice*A.fruitCNT 
order  by totalcost desc;

/*T*/
#1.고객별 과일의 구매 총 금액
select ts.Cust_id  as Cust_Id 
		,tc.Name as Name 
		,tc.Address as Address 
		,sum(ts.amount*tf.unitprice) as custperfruitcost
	from t_saleshst ts  join t_fruitmaster tf 
						on ts.fruit =tf.Fruit 
						join t_customer tc 
						on tc.Cust_Id =ts.Cust_Id 
group by ts.Cust_id
order by custperfruitcost desc 
limit 1;


select rank() over(order by sum(ts.amount*tf.unitprice) desc) as `rank`
		,tc.Name 
		,tc.Address 
		,sum(ts.amount*tf.unitprice) as custperfruitcost
from t_customer tc join t_saleshst ts
					on tc.Cust_Id =ts.Cust_Id 
					join t_fruitmaster tf 
						on ts.fruit =tf.Fruit 
group by tc.Name,tc.Address 


#2.총 구매금액이 가장 큰 구매 내역을 가지는 고객을 찾아라
#2-1 고객별 총 판매 금액 리스트에서 가장큰 금액만큼 구입한 고객 추출
select ts.Cust_id  as Cust_Id 
		,tc.Name as Name 
		,tc.Birth  
		,sum(ts.amount*tf.unitprice) as custperfruitcost
	from t_saleshst ts  join t_fruitmaster tf 
						on ts.fruit =tf.Fruit 
						join t_customer tc 
						on tc.Cust_Id =ts.Cust_Id 
group by ts.Cust_id
	having sum(ts.amount * tf.unitprice) =166000;
 
#2-2 고객별 가장 큰 구매 금액 구하기 (1660000)
select max(custperfruitcost)
from (select sum(ts.amount * tf.unitprice) as custperfruitcost
		from t_saleshst ts  join t_fruitmaster tf 
							on ts.fruit = tf.fruit
						group by ts.cust_id)A

#2-3 having 절 하위 쿼리로 변경
select ts.cust_id as cust_id
		,tc.name
		,tc.Birth 
		,sum(ts.amount * tf.unitprice) as custperfruitcost
	from t_saleshst ts  join t_fruitmaster tf 
						on ts.fruit =tf.Fruit 
						join t_customer tc 
						on ts.Cust_id =tc.Cust_Id 
	group by ts.Cust_id 
		having sum(ts.amount*tf.unitprice)=(select max(custperfruitcost)
												from(select sum(ts.amount *tf.unitprice)as custperfruitcost
													from t_saleshst ts join t_fruitmaster tf 
																		on ts.fruit =tf.Fruit 
													group by ts.Cust_id )A);
/*
 * 실습
 * 가장많이 팔린 과일의 종류와 총 판매 수량을구하세요
 * 가장많이 팔린 과일의 수량을 구하고
 * 그 수량만큼 팔린 과일의 리스트를 산출
 * 과일, 판매수량
 */

select 	A.FruitName
		,custperfruit
from (
	select tf.FruitName 
			,sum(ts.amount)as custperfruit	
		from t_saleshst ts join t_fruitmaster tf 
						on ts.fruit =tf.Fruit 
		group by tf.FruitName )A
order by custperfruit desc
limit 1;

													
#과일별 판매 횟수를 찾기
select fruit 
		,sum(amount) as saleCNT
from t_saleshst ts 
group by fruit 
order by saleCNT desc ;
limit 1; #공동 87개의 과일 판매가 사과, 참외 2종류라면 공동 1위는 산출할 수 없다.
#그렇다면 과일별 총 판매 횟수의 가장 높은 횟수를 찾고
#그 판매 횟수를 가지고 있는과일

											
													
													
select fruit 
		,sum(amount) as saleCNT
from t_saleshst ts 
group by fruit 	
	having  sum(amount) = (select max(saleCNT)
								from(select sum(amount) as saleCNT
										from t_saleshst ts 
									group by fruit 
									order by saleCNT desc )A)
													
													
/*
 * 집계함수를 한번만 사용하여 표현해 보세요
 */
													
select *
from (select fruit
			,sum(amount) as salcCNT
		from t_saleshst ts 
	group by fruit)A
where A.salcCNT = (select max(saleCNT)
						from(select sum(amount) as saleCNT
								from t_saleshst ts 
							group by fruit 
							order by saleCNT desc )A);
													
													
																																			
													
													
select * from t_customer tc ;
select * from t_fruitmaster tf ;
select * from t_itemmaster ti ;
select * from t_orderlist to2 ;
select * from t_saleshst ts ;
select * from t_stock ts ;
select * from t_stockhst ts ;
													
													
/*****************************************************************************
  
  3. UNION / UNION ALL
  다수의 검색 내역 병합 
  조회한 다수의 SELECT 문을 하나로 합치고싶을때 유니온(UNION) 을 사용.
  UNION     : 중복되는 행은 하나만 표시 
  UNION ALL : 중복제거를 하지 않고 모두 표시.  
   

  
  *** 합병 될 컬럼의 데이터 형식과 컬럼의 수는 일치해야한다.	*/											
													
													
# UNION : 중복데이터를 제거후 출력
select `date`
		,Cust_id #판매일자
		,fruit #고객ID
		,amount #과일
from t_saleshst ts #판매현황
union 
select `date` #발주일자
		,custCODE  #발주처
		,fruit #발주과일
		,amount #수량
from t_orderlist to2 
																										
																																						


# UNION ALL 중복된 데이터로 출력
select `date`
		,Cust_id #판매일자
		,fruit #고객ID
		,amount #과일
from t_saleshst ts #판매현황
union ALL
select `date` #발주일자
		,custCODE  #발주처
		,fruit #발주과일
		,amount #수량
from t_orderlist to2 

#union를 할때 컬럼 수가 동일해야 union를 할 수 있다.
#표현되어야 되는 컬럼의 쌍은 반드시 동일 해야 된다.
#관련 없는 내용이라 해도 순서대로 같은 컬럼에 표현한다.	

#발주이력에서 중복 데이터를 찾기
select count(*)
from t_orderlist to2 
group by `date` ,CUSTCODE ,fruit ,amount 
having count(*) >1;


#데이터 가공

# UNION ALL 중복된 데이터로 출력
select '판매'as TITLE
		,ts.`date` as DATE
		,ts.Cust_id #판매일자
		,tc.Name 
		,ts.fruit 
		,tf.FruitName  #고객ID
		,ts.amount #과일
from t_saleshst ts join t_fruitmaster tf 
					ON ts.fruit  =tf.Fruit  #판매현황
					join t_customer tc 
					on ts.Cust_id =tc.Cust_Id 
union ALL
select '발주' as TITLE
		,to2.`date` #발주일자
		,to2.custCODE  #발주처
		,'' as name
		,to2.fruit #발주과일
		,tf2.FruitName 
		,amount #수량
from t_orderlist to2 join t_fruitmaster tf2
						on to2.fruit =tf2.fruit;
																																																																	
#데이터를 UNION를 할 컬럼의 개수는 일치하여야 한다.																																																																														


select '판매'as TITLE
		,ts.`date` as DATE
		,ts.Cust_id #판매일자
		,tc.Name 
		,ts.fruit 
		,tf.FruitName  #고객ID
		,ts.amount #과일
from t_saleshst ts join t_fruitmaster tf 
					ON ts.fruit  =tf.Fruit  #판매현황
					join t_customer tc 
					on ts.Cust_id =tc.Cust_Id 
union ALL
select '발주' as TITLE
		,to2.`date` #발주일자
		,to2.custCODE  #발주처
		,case custCODE when '10' then '삼전물산'
					   when '20' then '하나'
					   when '30' then '농협'
					   when '40' then '대림' end as name
		,to2.fruit #발주과일
		,tf2.FruitName 
		,amount #수량
from t_orderlist to2 join t_fruitmaster tf2
						on to2.fruit =tf2.fruit	;																																																																																																							
																																																																																																																					
																																																																																																																																		
																																																																																																																																															
																																																																																																																																																												
#일자별 판매, 발주 현황리스트를 생성(하위쿼리)
select A.title
		,A.DATE
		,A.Cust_id
		,A.Name
		,A.fruit
		,A.FruitName
		,A.amount
from (select '판매'as TITLE
		,ts.`date` as DATE
		,ts.Cust_id #판매일자
		,tc.Name 
		,ts.fruit 
		,tf.FruitName  #고객ID
		,ts.amount #과일
from t_saleshst ts join t_fruitmaster tf 
					ON ts.fruit  =tf.Fruit  #판매현황
					join t_customer tc 
					on ts.Cust_id =tc.Cust_Id 
union ALL
select '발주' as TITLE
		,to2.`date` #발주일자
		,to2.custCODE  #발주처
		,case custCODE when '10' then '삼전물산'
					   when '20' then '하나'
					   when '30' then '농협'
					   when '40' then '대림' end as name
		,to2.fruit #발주과일
		,tf2.FruitName 
		,amount #수량
from t_orderlist to2 join t_fruitmaster tf2
						on to2.fruit =tf2.fruit	)A
order by `date`;																																																																																																																																																																																						

																																																																																																																																																																																																																

/*
 * 실습 
 * Union 과 join을 이용하여 
 * 두가지 방법을 과일 가게의 일자별 마진 금액을 산출하세요.
 * date			MARGIN
 * 2023-11-30   -150000
 * 2023-12-01    30000
 */

select   A.`date`,sum(A.tunitprice) as margin
from(select  ts.`date`,sum(tf.unitprice*ts.amount) as tunitprice
from t_saleshst ts join t_fruitmaster tf  
					on ts.fruit =tf.Fruit 
group by `date`											
union All
select `date`,-sum(tf.ordercost*to2.amount) as tunitprice
from t_orderlist to2  join t_fruitmaster tf  
					on to2.fruit =tf.Fruit 
group by to2.`date`) A
group by `date`
order by margin desc;


#JOIN으로 해결하기는 힘들다.
select A.`date`,A.tunitprice-B.tunitprice as daypercost
from (select  ts.`date`,sum(tf.unitprice*ts.amount) as tunitprice
from t_saleshst ts join t_fruitmaster tf  
					on ts.fruit =tf.Fruit 
group by `date`	) A left join (select `date`,sum(tf.ordercost*to2.amount) as tunitprice
						from t_orderlist to2  join t_fruitmaster tf  
											on to2.fruit =tf.Fruit 
						group by to2.`date`)B on A.`date`=B.`date` 



												
													
													
													
													
													
													




