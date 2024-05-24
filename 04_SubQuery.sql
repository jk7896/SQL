/*****************************************************************/
/* 1. 하위 쿼리(SubQuery)
	-쿼리 안의 쿼리
	-select 절, from 절, where 절
	
	-장점 : sql 구문안에서 유연하게 즉 즉시 다른 sql문을 만들어 적용 할 수 있다.
	-단점 : wql 구문이 가독성이 떨어지고 쿼리가 불필요하게 복잡해진다.
*/

#하위 쿼리를 통한 데이터의 조회(WHERE)
/* 재고이력(t_stockhst)에서 이력 등록 일시가 '2023-12-07'인 품목의 정보를 품목코드,품목명,품목구분,규격정보로 검색*/

#1.'2021-12-07'의 이력 품목구하기

select ITEMCODE 
from t_stockhst ts 
where MAKEDATE ='2021-12-07'


#2.품목의 정보 : 품목코드,품목명,품목구분,규격정보(품목 마스터)
#where절의 하위 퀄리로 일부 정보만을 가지고 검색을 하려는 대상의 정보를 조회후
#그 결과를 상세 테이블에서 검색 하도록 할 수 있다.
select ITEMCODE,
		ITEMNAME ,
		ITEMTYPE ,
		SPEC 
from t_itemmaster ti  
where ITEMCODE =(select ITEMCODE from t_stockhst  where MAKEDATE='2021-12-07');


#하위쿼리 결과 데이터를 포함하지 않는 결과를 변환
select ITEMCODE,
		ITEMNAME ,
		ITEMTYPE ,
		SPEC 
from t_itemmaster ti  
where ITEMCODE !=(select ITEMCODE from t_stockhst  where MAKEDATE='2021-12-07');




#n개 이상인 하위 쿼리 결과 데이터를 검색 조건으로 설정하고자 할때
#in : 하위쿼리에서 도출된 N개의 결과 데이터를 복수로 검색
select ITEMCODE,
		ITEMNAME ,
		ITEMTYPE ,
		SPEC 
from t_itemmaster ti  
where ITEMCODE !=(select ITEMCODE from t_stockhst);





#n개 이상인 하위 쿼리 결과 데이터를 검색 조건으로 배제하고자 할때
#not in : 이력테이블에 한번도 등록되지 않은 품목의 정보를 조회
select ITEMCODE,
		ITEMNAME ,
		ITEMTYPE ,
		SPEC 
from t_itemmaster ti  
where ITEMCODE not in (select distinct ITEMCODE from t_stockhst); #이력에 등록된 품목을 제외한 나머지 품목전체의 정보



#하위쿼리의 하위쿼리
/*'2022-10-31'일 입고된 품목의 창고에 대한 품목 코드를 
 * 재고현황(T_STOCK)에서 찾고 n개의 품목 정보를 품목 마스터에서 검색
 */

select ITEMCODE ,
		ITEMNAME ,
		WHCODE ,
		LOCCODE 
	from t_itemmaster ti 
  where ITEMCODE in(select ITEMCODE 
					from t_stock ts 
				where WHCODE  in (select WHCODE 
									from t_stockhst ts 
								where INOUTDATE ='2022-10-31'
								and INOUTFLAG ='I'));



#SELECT절에서의 하위 쿼리
/*자재 재고에서 iTEMCODE< STOCKQTY데이터를 검색하고
 * 품목별 품명의 정보를 같이 나타내세요
 * 자재 재고 품목, 품명, 재고수량
 */
select ITEMCODE ,
		STOCKQTY ,
		(select ITEMNAME
		from t_itemmaster ti
		where ITEMCODE = ts.ITEMCODE) as ITEMNAME
from t_stock ts ;

select * from t_stock ts where ITEMCODE ='12986-06193H';
select * from t_itemmaster ti where ITEMCODE ='12986-06193H';


























































							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							