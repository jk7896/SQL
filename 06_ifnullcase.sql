#IFNULL
# null인 상태의 셀의 값으 ㄹ원하는 데이터로 변형하기
/*
 * 재고이력 테이블에서 비고(REMARK)가 null인 경우 '-'로 표현해서 나타내기
 */

select ITEMCODE 
		,INOUTQTY 
		,ifnull(REMARK,'-') as remark 
from t_stockhst ts  ;

#사용자 인터페이스 프로그램을 만들때 사용자가 불특정한데이터를 보낼때 예상하여 select의 조건절에 (where)에 검색하는 조건을 
#like로 설정 할때가 많다.
#검색 하려는 컬럼이 null 상태 일 경우에는 like 연산자로 조회 할 수 없다.

select *
	from t_itemmaster ti
where ifnull(spec,'') like concat('%','','%');     #(밑에코드하고 같은 결과가 나온다.) ifnull를 사용하여 null를 바꿔주고 검색하면 나온다.
#where spec like '%%';

#where spec like '%%'
#-->like처리 하는 컬럼의 데이터를 임의로 ''(아무것도 없는 값)을 치환해서 like를 동작 할 수 있도록 한다.

/*
 * 분기문 case when then end
 * 특정 조건을 만족시킬때의 여러가지 경우를 나누어 결과를 다르게 표현하는 문법
 * 
 * 1.case [비교대상] WHEN [조건] TEHN[결과로직] END
 * 	.고정된 비교대상과 다수의 조건에 따른 결과 표현(1:N)
 * 2.case when[비교대상의 비교연산 조건(참/거짓)] THEN[결과] END
 * 	.다수의 비교 대상의 경우를 다수의 결과로 반환하고 싶을때 [N:N]
 * 
 */


#조회부에서 사용되는 case when문 예제
#1.case [비교대상] WHEN [조건] TEHN[결과로직] END

select ITEMCODE 
		,ITEMNAME 
		,case WHCODE when 'wh003' then '원재료' #창고를 나타내는 코드에 따른 문자 표현
					 when 'WH005' then '상품창고'
					 else '기타' end  
	from t_itemmaster ti ;



#2.case when[비교대상의 비교연산 조건(참/거짓)] THEN[결과] END
 SELECT ITEMCODE
        ,CASE WHEN STOCKQTY <= 300  THEN '재고미달'
              WHEN STOCKQTY >= 0 AND STOCKQTY <= 1000 THEN '-'
           ELSE '재고초과' END AS STOCK_STATE
   FROM t_Stock; 
#WHCOED 같은 데이터는 기준정보(WHCODE를 관리하는 테이블)에서 상세내역을 연결하여 조회하는것이 맞지만, 일부 데이터에서만 관리하려는 내역이라면
#상세 내역 테이블에 데이터가 등록되어있지 않을 수 도 있다.
#SELECT절에사용되는 case는 등록되어있는 데이터를 가공하는 역할이 크다.


#조건부에 사용되는 CASE
#조건을 만족하는 경우에 따라 전혀 다른 데이터 결과를 SET을 반환하다.
/*
 * 조건부 CASE 예1)
 * 입고등록일 '2023-01-01'부터 '2023-12-31' 까지인 재고의 수량이 60이상일 경우 
 * '12'로 시작하는 품목의 리스트를 반환하고
 * 그렇지 않을 경우 '63'으로 시작하는 품목의 모든 리스트를 조회
 * CONCAT : 문자열을 합쳐서 하나의 문자열로 만들어주는 기능
 */

select *
from t_itemmaster ti  
where ITEMCODE like concat(case when(select count(*)
									from t_stock ts 
									where MAKEDATE between '2023-01-01' and '2023-12-31')>=60 then '12'
										else '63' end ,'%'); 




select *
from t_itemmaster ti 
where ITEMCODE like concat(case when(
						select count(*)
							from t_stock ts 
						where MAKEDATE between '2023-01-01' and '2023-12-31')>=1000 then '12'
							else '64' end ,'%');



#조건부 case 예2)
#비교대상을 1 또는 특정 문자열을 두어 CASE WHEN문을 통해 참일 경우 1을 반환 하도록 하여
#원하는 결과를 분기로 확인할수 있도록 하는 기법

#[기본틀]
-- select *
-- from t_stock ts 
-- where 1= case [비교대상] when [~일때] then 1 
-- 								 else 0 end;



select *
 from t_stock ts 
 where 1= (case when(select count(*)
					from t_stock ts 
				where MAKEDATE between '2023-01-01' and '2023-12-31' )
				 >=20 then 1 
				else 0 end)
and itemcode like '64%';














































































