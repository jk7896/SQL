/*순위를 산출해서 집계하는 기능
1.rank over(order by ***)
.집계 결과 중복 횟수를 감안하여 순위를 산출 =>25,25,25,28
*/

#23년 연간 일별 입출 수량이 가장 많은 일자
select INOUTDATE as INOUTDATE
		,sum(INOUTQTY) as dateper_inoutqty
		,rank()over(order by sum(inoutqty) desc) as degree
from t_stockhst ts 
where INOUTDATE between '2023-01-01' and '2023-12-31'
group by INOUTDATE 




#집계함수를 한번만 사용하여 같은 결과 도출하기
select A.INOUTDATE,A.dateper_inoutqty
	,rank()over(order by A.dateper_inoutqty desc) as degree
from(select INOUTDATE as INOUTDATE
		,sum(INOUTQTY) as dateper_inoutqty
from t_stockhst ts 
where INOUTDATE between '2023-01-01' and '2023-12-31'
group by INOUTDATE )A

#DENSE_RANK() : 중복 순위가 존재해도 순차적으로 다음 순위 값을 표시함 
select A.INOUTDATE,A.dateper_inoutqty
	,dense_rank()over(order by A.dateper_inoutqty desc) as _rank
from(select INOUTDATE as INOUTDATE
		,sum(INOUTQTY) as dateper_inoutqty
from t_stockhst ts 
where INOUTDATE between '2023-01-01' and '2023-12-31'
group by INOUTDATE )A

#rank 30위가 나오게
select *
from (
select A.INOUTDATE,A.dateper_inoutqty
	,dense_rank()over(order by A.dateper_inoutqty desc) as _rank
from(select INOUTDATE as INOUTDATE
		,sum(INOUTQTY) as dateper_inoutqty
from t_stockhst ts 
where INOUTDATE between '2023-01-01' and '2023-12-31'
group by INOUTDATE )A)B
where _rank=30;

																	
/*
 * 실습
 * 23년 연간 일자별 품목별 창고의 정보를 입출 일자별 오름차순 순번과 함께 표현하세요.
 * 
 * 순번,일자,품목코드,창고
 */

#ROW_NUMBER 는 모든 행의 번호를 순차적으로 지정합니다(예: 1, 2, 3, 4, 5). RANK 는 순위 동률(예: 1, 2, 2, 4, 5)

select row_number ()over(order by INOUTDATE) as number
		,INOUTDATE 
		,ITEMCODE 
		,WHCODE 
from t_stockhst ts  
where  INOUTDATE  between  '2023-01-01' and '2023-12-31';















































































































































