-------------------------------------ПОДЗАПРОСЫ--------------------------------------
CREATE OR REPLACE FUNCTION plane_popularity()
RETURNS TABLE (model VARCHAR, cnt BIGINT) AS 
$$
BEGIN
	RETURN QUERY SELECT pl.model, (SELECT COUNT(*) FROM flights f WHERE f.plane_id = pl.id) AS cnt
				 FROM planes pl
				 ORDER BY cnt DESC;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION plane_avg_price()
RETURNS TABLE (model VARCHAR, avg_price INT) AS 
$$
BEGIN
	RETURN QUERY SELECT pl.model, av.avg_price
				 FROM planes pl 
				 JOIN (SELECT f.plane_id, AVG(f.ticket_price)::INT AS avg_price FROM flights f GROUP BY f.plane_id) 
				 AS av ON av.plane_id = pl.id;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION passenger_ticket_count()
RETURNS TABLE (name VARCHAR, tickets_count BIGINT) AS 
$$
BEGIN
	RETURN QUERY SELECT p.fio, (SELECT COUNT(*) FROM tickets ti WHERE ti.passenger_id = p.id) AS tickets_count
				 FROM passengers p
				 WHERE EXISTS (SELECT * FROM tickets tic WHERE tic.passenger_id = p.id);
END;
$$ LANGUAGE plpgsql;


--------------------------------КОРРЕЛИРОВАННЫЕ ПОДЗАПРОСЫ------------------------------


CREATE OR REPLACE FUNCTION bought_tickets_persentage()
RETURNS TABLE (flight_id INT, seats_left INT, bought_tickets_persentage DOUBLE PRECISION) AS 
$$
BEGIN
	RETURN QUERY SELECT av.flight_id, av.seats_left,
				 (SELECT (1.0 - av.seats_left::REAL/pl.seats)*100 FROM flights f JOIN planes pl ON pl.id = f.plane_id WHERE f.id = av.flight_id) AS persentage
				 FROM available_seats av;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION bought_tickets_per_plane()
RETURNS TABLE (plane VARCHAR, tickets BIGINT) AS 
$$
BEGIN
	RETURN QUERY SELECT pl.model, (SELECT COUNT(*) FROM tickets ti WHERE ti.plane_id = pl.id) 
				 FROM planes pl;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION favorite_payment_method()
RETURNS TABLE (fio VARCHAR, payment_method VARCHAR) AS 
$$
BEGIN
	RETURN QUERY SELECT p.fio, (SELECT ti.payment_method FROM tickets ti 
								WHERE ti.passenger_id = p.id
								GROUP BY ti.payment_method
							    ORDER BY COUNT(ti.payment_method) DESC LIMIT 1) 
				 FROM passengers p;
END;
$$ LANGUAGE plpgsql;


-------------------------------------------ИНДЕКСЫ----------------------------------------


SELECT * FROM planes WHERE model = 'Ил-96';

SELECT * FROM passengers WHERE passport = '1234567890';

SELECT * FROM flights WHERE departure_city = 'Москва' AND ticket_price <= 5000;


-----------------------------------------Группировка--------------------------------------------


CREATE OR REPLACE FUNCTION city_total_revenue()
RETURNS TABLE (city VARCHAR, total_revenue BIGINT) AS 
$$
BEGIN
	RETURN QUERY SELECT f.departure_city, SUM(f.ticket_price) AS total_revenue
				 FROM flights f
				 JOIN tickets ti ON f.id = ti.flight_id
				 GROUP BY f.departure_city
				 HAVING SUM(f.ticket_price) > 10000;
END;
$$ LANGUAGE plpgsql;


--------------------------------------предикат ALL--------------------------------------------


CREATE OR REPLACE FUNCTION get_free_planes()
RETURNS SETOF planes AS 
$$
BEGIN
	RETURN QUERY SELECT * FROM planes WHERE id != ALL(SELECT DISTINCT plane_id FROM flights);
END;
$$ LANGUAGE plpgsql;



--		select * from get_free_planes()

