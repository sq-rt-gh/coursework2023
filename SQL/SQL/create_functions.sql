--DROP FUNCTION add_plane(text,integer)
CREATE OR REPLACE FUNCTION add_plane(_model TEXT, _seats INT)
RETURNS VOID AS
$$
BEGIN

IF (NOT EXISTS (SELECT 1 FROM planes WHERE model = _model)) THEN
	INSERT INTO planes(model, seats) VALUES(_model, _seats);
END IF;

END;
$$ LANGUAGE plpgsql;

----------------------------------

CREATE OR REPLACE FUNCTION upd_plane(_id INT, new_model VARCHAR, new_seats INT)
RETURNS VOID AS
$$
BEGIN
	UPDATE planes SET model = new_model, seats = new_seats WHERE id = _id;
END;
$$ LANGUAGE plpgsql;

---------------------------------select * from planes

CREATE OR REPLACE FUNCTION del_plane(_id INT)
RETURNS VOID AS
$$
BEGIN
	DELETE FROM planes WHERE id = _id;
END;
$$ LANGUAGE plpgsql;

----------------------------------

CREATE OR REPLACE FUNCTION get_planes()
RETURNS TABLE (id INT, model VARCHAR(40), seats INT) AS
$$
BEGIN
RETURN QUERY SELECT * FROM planes;
END;
$$ LANGUAGE plpgsql;


-------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION add_flight(d_city TEXT, ar_city TEXT, d_time TIMESTAMP, 
									  ar_time TIMESTAMP, price INT, _pl_id INT)
RETURNS VOID AS
$$
DECLARE tmp_id INT;
BEGIN

INSERT INTO flights(departure_city,arrival_city,departure_time,arrival_time,ticket_price,plane_id) 
VALUES(d_city, ar_city, d_time, ar_time, price, _pl_id)
RETURNING id INTO tmp_id;

INSERT INTO available_seats VALUES(tmp_id, (SELECT seats FROM planes p WHERE p.id = _pl_id));

END;
$$ LANGUAGE plpgsql;

------------------------------------


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



-------------------------------

CREATE OR REPLACE FUNCTION del_flight(_id INT)
RETURNS VOID AS
$$
BEGIN
	IF (EXISTS (SELECT 1 FROM flights WHERE id = _id)) THEN
		DELETE FROM available_seats WHERE flight_id = _id;
		DELETE FROM flights WHERE id = _id;
	END IF;
END;
$$ LANGUAGE plpgsql;

-------------------------------

CREATE OR REPLACE FUNCTION get_flights()
RETURNS TABLE(id INT, departure_city VARCHAR, arrival_city VARCHAR, 
departure_time TIMESTAMP, arrival_time TIMESTAMP, ticket_price INT, plane_id INT) AS
$$
BEGIN
	RETURN QUERY SELECT * FROM flights;
END;
$$ LANGUAGE plpgsql;

-----------------------

CREATE OR REPLACE FUNCTION get_flights_exp()
RETURNS TABLE(id INT, departure_city VARCHAR, arrival_city VARCHAR, departure_time TIMESTAMP, 
			  arrival_time TIMESTAMP, ticket_price INT, plane VARCHAR, seats_left INT) AS
$$
BEGIN
	RETURN QUERY SELECT * FROM available_flights;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------------


CREATE OR REPLACE FUNCTION add_passenger(_fio TEXT, _passport TEXT)
RETURNS VOID AS
$$
BEGIN
		INSERT INTO passengers(fio, passport) VALUES(_fio, _passport);
END;
$$ LANGUAGE plpgsql;

------------------------

CREATE OR REPLACE FUNCTION upd_passenger(_id INT, new_fio VARCHAR, new_psprt VARCHAR)
RETURNS VOID AS
$$
BEGIN
	UPDATE passengers SET fio = new_fio, passport = new_psprt WHERE id = _id;
END;
$$ LANGUAGE plpgsql;


-----------------------------


CREATE OR REPLACE FUNCTION del_passenger(_id INT)
RETURNS VOID AS
$$
BEGIN
	IF (EXISTS (SELECT 1 FROM passengers WHERE id = _id)) THEN
		DELETE FROM passengers WHERE id = _id;
	END IF;
END;
$$ LANGUAGE plpgsql;

------------------------------

CREATE OR REPLACE FUNCTION get_passengers()
RETURNS TABLE(id INT, fio VARCHAR, passport VARCHAR) AS
$$
BEGIN
	RETURN QUERY SELECT * FROM passengers;
END;
$$ LANGUAGE plpgsql;

------------------------------

CREATE OR REPLACE FUNCTION get_passenger(pasprt TEXT)
RETURNS TABLE(id INT, fio VARCHAR, passport VARCHAR) AS
$$
BEGIN
	RETURN QUERY SELECT * FROM passengers p WHERE p.passport = pasprt;
END;
$$ LANGUAGE plpgsql;


-----------------------------------------------------------------


CREATE OR REPLACE FUNCTION buy_ticket(_flight_id INT, _passenger_id INT, payment TEXT = 'cash')
RETURNS VOID AS
$$
BEGIN
	IF ((SELECT seats_left FROM available_seats av WHERE av.flight_id = _flight_id) > 0) THEN
		INSERT INTO tickets(payment_method, purchase_time, flight_id, plane_id, passenger_id)
 			VALUES(payment, now()::timestamp, _flight_id, 
			   	(SELECT plane_id FROM flights f WHERE f.id = _flight_id), 
			   	_passenger_id);
	END IF;

END;
$$ LANGUAGE plpgsql;

-----------------------------

CREATE OR REPLACE FUNCTION refund_ticket(ticket_id INT)
RETURNS VOID AS
$$
BEGIN
	DELETE FROM tickets WHERE id = ticket_id;
END;
$$ LANGUAGE plpgsql;

-----------------------------------

CREATE OR REPLACE FUNCTION get_tickets()
RETURNS TABLE (id INT, payment VARCHAR(20), purchase_time TIMESTAMP, flight_id INT, plane_id INT, passenger_id INT) AS
$$
BEGIN
	RETURN QUERY SELECT * FROM tickets;
END;
$$ LANGUAGE plpgsql;

-------------------------------------
/*
CREATE OR REPLACE FUNCTION get_tickets(psngr_id INT)
RETURNS TABLE (id INT, payment VARCHAR(20), purchase_time TIMESTAMP, flight_id INT, plane_id INT, passenger_id INT) AS
$$
BEGIN
	RETURN QUERY SELECT * FROM tickets ti WHERE ti.passenger_id = psngr_id;
END;
$$ LANGUAGE plpgsql;
--*/
-------------------------------------------------

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

-------------------------------------------------


CREATE OR REPLACE FUNCTION get_joined_tables()
RETURNS TABLE (Id INT, Departure_city VARCHAR, Arrival_city VARCHAR, Departure_time TIMESTAMP, Arrival_time TIMESTAMP, Passenger VARCHAR, Passport VARCHAR, Plane VARCHAR, Ticket_price INT,  Payment_method VARCHAR, Purchase_time TIMESTAMP) AS
$$
BEGIN
	RETURN QUERY SELECT * FROM join_all_tables;
END;
$$ LANGUAGE plpgsql;
--*/
--------------------------------------
/*
CREATE OR REPLACE FUNCTION get_joined_tables(psngr_id INT)
RETURNS TABLE (Id INT, Departure_city VARCHAR, Arrival_city VARCHAR, Departure_time TIMESTAMP, Arrival_time TIMESTAMP, Passenger VARCHAR, Passport VARCHAR, Plane VARCHAR, Ticket_price INT,  Payment_method VARCHAR, Purchase_time TIMESTAMP) AS
$$
BEGIN
	RETURN QUERY SELECT * FROM join_all_tables j
					WHERE j.passport = (SELECT p.passport FROM passengers p WHERE p.id = psngr_id);
END;
$$ LANGUAGE plpgsql;
*/

