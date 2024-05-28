SELECT DISTINCT ts.ITEMCODE 								
FROM t_stockhst ts LEFT JOIN t_stock ts2							
                              ON ts.ITEMCODE = ts2.ITEMCODE 								
WHERE ts2.ITEMCODE is NULL;								
	


SELECT INOUTDATE, WHCODE, cnt 					
FROM ( SELECT INOUTDATE, WHCODE, count(*) AS cnt 					
                     FROM t_stockhst ts 					
                WHERE INOUTQTY > 100 AND INOUTFLAG = 'I' 					
            GROUP BY INOUTDATE, WHCODE ) A					
WHERE cnt >= 2 ORDER BY INOUTDATE;					





SELECT A.fruit AS Fruit,
    B.FruitName AS FruitName,
    IFNULL(A.orderCNT, 0) AS orderCNT,
    IFNULL(C.SaleCNT, 0) AS SaleCNT    
	FROM (SELECT fruit, SUM(amount) AS orderCNT FROM t_orderlist GROUP BY fruit) A
		LEFT JOIN t_fruitmaster B 
		ON A.fruit = B.fruit
		LEFT join (SELECT fruit, SUM(amount) AS SaleCNT FROM t_saleshst GROUP BY fruit) C
		ON A.fruit = C.fruit;



																

                                                              
SELECT DATE, SUM(amount * unitprice) AS DayCost
FROM t_saleshst ts JOIN t_fruitmaster tf 
					ON ts.fruit = tf.Fruit
GROUP BY DATE
HAVING SUM(amount * unitprice) = (SELECT MAX(DailyTotal) FROM (SELECT SUM(amount * unitprice) AS DailyTotal
                                                                  FROM t_saleshst ts JOIN t_fruitmaster tf 
                                                                  						ON ts.fruit = tf.Fruit
                                                                GROUP BY DATE) AS DailySums);
