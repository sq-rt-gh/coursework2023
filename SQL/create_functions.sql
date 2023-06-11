-------------------------------INSERT--------------------------------

CREATE OR REPLACE PROCEDURE add_plane(_model TEXT, _seats INT) AS
$$
BEGIN
	INSERT INTO planes(model, seats) VALUES(_model, _seats);
	
	IF (EXISTS (SELECT 1 FROM planes WHERE model = _model)) THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE add_flight(d_city TEXT, ar_city TEXT, d_time TIMESTAMP, 
									   ar_time TIMESTAMP, price INT, _pl_id INT) AS
$$
DECLARE tmp_id INT;
BEGIN
	INSERT INTO flights(departure_city,arrival_city,departure_time,arrival_time,ticket_price,plane_id) 
	VALUES(d_city, ar_city, d_time, ar_time, price, _pl_id)
	RETURNING id INTO tmp_id;

	INSERT INTO available_seats VALUES(tmp_id, (SELECT seats FROM planes p WHERE p.id = _pl_id));
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE add_passenger(_fio TEXT, _passport TEXT) AS
$$
BEGIN
	INSERT INTO passengers(fio, passport) VALUES(_fio, _passport);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE buy_ticket(_flight_id INT, _passenger_id INT, payment TEXT = 'cash') AS
$$
BEGIN
	IF ((SELECT seats_left FROM available_seats av WHERE av.flight_id = _flight_id) > 0) THEN
		INSERT INTO tickets(payment_method, purchase_time, flight_id, plane_id, passenger_id)
 		VALUES(payment, now()::timestamp, _flight_id, (SELECT plane_id FROM flights f WHERE f.id = _flight_id), _passenger_id);
		COMMIT;
	ELSE 
		ROLLBACK;
	END IF;

END;
$$ LANGUAGE plpgsql;


-----------------------------UPDATE------------------------------------------


CREATE OR REPLACE FUNCTION upd_plane(_id INT, new_model VARCHAR, new_seats INT)
RETURNS VOID AS
$$
BEGIN
	UPDATE planes SET model = new_model, seats = new_seats WHERE id = _id;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION upd_flight(_id INT, dc VARCHAR, arc VARCHAR, dt TIMESTAMP, 
									  art TIMESTAMP, price INT, pl_id INT)
RETURNS VOID AS
$$
BEGIN
	UPDATE flights SET departure_city = dc,
					   arrival_city = arc,
					   departure_time = dt,
					   arrival_time = art,
					   ticket_price = price,
					   plane_id = pl_id
		WHERE id = _id;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION upd_passenger(_id INT, new_fio VARCHAR, new_psprt VARCHAR)
RETURNS VOID AS
$$
BEGIN
	UPDATE passengers SET fio = new_fio, passport = new_psprt WHERE id = _id;
END;
$$ LANGUAGE plpgsql;


-------------------------------DELETE----------------------------------------


CREATE OR REPLACE FUNCTION del_plane(_id INT)
RETURNS VOID AS
$$
BEGIN
	DELETE FROM planes WHERE id = _id;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION del_flight(_id INT)
RETURNS VOID AS
$$
BEGIN
	DELETE FROM available_seats WHERE flight_id = _id;
	DELETE FROM flights WHERE id = _id;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION del_passenger(_id INT)
RETURNS VOID AS
$$
BEGIN
	DELETE FROM passengers WHERE id = _id;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION refund_ticket(ticket_id INT)
RETURNS VOID AS
$$
BEGIN
	DELETE FROM tickets WHERE id = ticket_id;
END;
$$ LANGUAGE plpgsql;


------------------------------SELECT---------------------------------


CREATE OR REPLACE FUNCTION get_planes()
RETURNS SETOF planes AS
$$
BEGIN
RETURN QUERY SELECT * FROM planes;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_flights()
RETURNS SETOF flights AS
$$
BEGIN
	RETURN QUERY SELECT * FROM flights;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_flights_exp()
RETURNS SETOF available_flights AS
$$
BEGIN
	RETURN QUERY SELECT * FROM available_flights;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_passengers()
RETURNS SETOF passengers AS
$$
BEGIN
	RETURN QUERY SELECT * FROM passengers;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_passenger(pasprt TEXT)
RETURNS SETOF passengers AS
$$
BEGIN
	RETURN QUERY SELECT * FROM passengers p WHERE p.passport = pasprt;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_tickets()
RETURNS SETOF tickets AS
$$
BEGIN
	RETURN QUERY SELECT * FROM tickets;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_tickets_exp(psngr_id INT)
RETURNS TABLE (Id INT, Departure_city VARCHAR, Arrival_city VARCHAR, Departure_time TIMESTAMP, Arrival_time TIMESTAMP, Plane VARCHAR) AS
$$
BEGIN
	RETURN QUERY SELECT ti.id, f.departure_city, f.arrival_city, f.departure_time, f.arrival_time, pl.model 
					FROM tickets ti 
					JOIN flights f ON f.id = ti.flight_id  
					JOIN planes pl ON pl.id = ti.plane_id
					WHERE ti.passenger_id = psngr_id;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_joined_tables()
RETURNS SETOF join_all_tables AS
$$
BEGIN
	RETURN QUERY SELECT * FROM join_all_tables;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_tickets_count()
RETURNS INT AS
$$
DECLARE res INT;
BEGIN
	SELECT COUNT(*) INTO res FROM tickets;
	RETURN res;
END;
$$ LANGUAGE plpgsql;
