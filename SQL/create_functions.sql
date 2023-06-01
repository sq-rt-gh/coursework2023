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

CREATE OR REPLACE FUNCTION upd_plane(_model TEXT, new_seats INT)
RETURNS VOID AS
$$
BEGIN

IF (EXISTS (SELECT 1 FROM planes WHERE model = _model)) THEN
	UPDATE planes SET seats = new_seats WHERE model = _model;
END IF;

END;
$$ LANGUAGE plpgsql;

---------------------------------

CREATE OR REPLACE FUNCTION del_plane(_model TEXT)
RETURNS VOID AS
$$
BEGIN

IF (NOT EXISTS (SELECT 1 FROM planes WHERE model = _model)) THEN
	DELETE FROM planes WHERE model = _model;
END IF;

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
BEGIN

IF (NOT EXISTS (SELECT 1 FROM flights f WHERE f.departure_city = d_city AND 
			   f.arrival_city = ar_city AND f.departure_time = d_time AND
			   f.arrival_time = ar_time AND f.ticket_price = price AND f.plane_id = _pl_id))
	THEN
	INSERT INTO flights(departure_city, arrival_city, departure_time, arrival_time,
						ticket_price, plane_id) 
	VALUES(d_city, ar_city, d_time, ar_time, price, _pl_id);
END IF;

END;
$$ LANGUAGE plpgsql;

------------------------------------
/*
select add_flight('St. Petersburg','Moscow','2023-05-24 16:30:00','2023-05-24 20:00:00',8200,2) 

select add_plane('Boing 2', 55)
select * from planes
*/

CREATE OR REPLACE FUNCTION upd_flight_dc(_id INT, dc TEXT)
RETURNS VOID AS
$$
BEGIN
	IF (EXISTS (SELECT 1 FROM flights WHERE id = _id)) THEN
		UPDATE flights SET departure_city = dc WHERE id = _id;
	END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION upd_flight_ac(_id INT, ac TEXT)
RETURNS VOID AS
$$
BEGIN
	IF (EXISTS (SELECT 1 FROM flights WHERE id = _id)) THEN
		UPDATE flights SET arrival_city = ac WHERE id = _id;
	END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION upd_flight_dt(_id INT, dt TIMESTAMP)
RETURNS VOID AS
$$
BEGIN
	IF (EXISTS (SELECT 1 FROM flights WHERE id = _id)) THEN
		UPDATE flights SET departure_time = dt WHERE id = _id;
	END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION upd_flight_at(_id INT, _at TIMESTAMP)
RETURNS VOID AS
$$
BEGIN
	IF (EXISTS (SELECT 1 FROM flights WHERE id = _id)) THEN
		UPDATE flights SET arrival_time = _at WHERE id = _id;
	END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION upd_flight_price(_id INT, price INT)
RETURNS VOID AS
$$
BEGIN
	IF (EXISTS (SELECT 1 FROM flights WHERE id = _id)) THEN
		UPDATE flights SET ticket_price = price WHERE id = _id;
	END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION upd_flight_plane(_id INT, _plane INT)
RETURNS VOID AS
$$
BEGIN
	IF (EXISTS (SELECT 1 FROM flights WHERE id = _id)) THEN
		UPDATE flights SET plane_id = _plane WHERE id = _id;
	END IF;
END;
$$ LANGUAGE plpgsql;

-------------------------------

CREATE OR REPLACE FUNCTION del_flight(_id INT)
RETURNS VOID AS
$$
BEGIN
	IF (EXISTS (SELECT 1 FROM flights WHERE id = _id)) THEN
		DELETE FROM flights WHERE id = _id;
	END IF;
END;
$$ LANGUAGE plpgsql;

-------------------------------

CREATE OR REPLACE FUNCTION get_flights()
RETURNS TABLE(id INT, departure_city TEXT, arrrival_city TEXT, 
departure_time TIMESTAMP, arrival_time TIMESTAMP, ticket_price INT, plane_id INT) AS
$$
BEGIN
	RETURN QUERY SELECT * FROM flights;
END;
$$ LANGUAGE plpgsql;


-----------------------------------------------------------------------


CREATE OR REPLACE FUNCTION add_passenger(_fio TEXT, _passport TEXT)
RETURNS VOID AS
$$
BEGIN
	--IF (NOT EXISTS (SELECT 1 FROM passengers WHERE fio = _fio AND passport = _passport)) THEN
		INSERT INTO passengers(fio, passport) VALUES(_fio, _passport);
	--END IF;
END;
$$ LANGUAGE plpgsql;

------------------------

CREATE OR REPLACE FUNCTION upd_passenger_pas(_id INT, pasprt TEXT)
RETURNS VOID AS
$$
BEGIN
	IF (EXISTS (SELECT 1 FROM passengers WHERE id = _id)) THEN
		UPDATE passengers SET passport = pasaprt WHERE id = _id;
	END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION upd_passenger_fio(_id INT, _fio TEXT)
RETURNS VOID AS
$$
BEGIN
	IF (EXISTS (SELECT 1 FROM passengers WHERE id = _id)) THEN
		UPDATE passengers SET fio = _fio WHERE id = _id;
	END IF;
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
RETURNS TABLE(id INT, fio TEXT, passport TEXT) AS
$$
BEGIN
	RETURN QUERY SELECT * FROM passengers;
END;
$$ LANGUAGE plpgsql;


-----------------------------------------------------------------


CREATE OR REPLACE FUNCTION buy_ticket(_flight_id INT, _passenger_id INT, payment TEXT = 'cash')
RETURNS VOID AS
$$
BEGIN
	INSERT INTO tickets(payment_method, purchase_time, flight_id, plane_id, passenger_id)
 		VALUES(payment, now()::timestamp, _flight_id, 
			   (SELECT plane_id FROM flights WHERE id = _flight_id), 
			   _passenger_id);

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

CREATE OR REPLACE FUNCTION get_tickets(psngr_id INT)
RETURNS TABLE (id INT, payment VARCHAR(20), purchase_time TIMESTAMP, flight_id INT, plane_id INT, passenger_id INT) AS
$$
BEGIN
	RETURN QUERY SELECT * FROM tickets ti WHERE ti.passenger_id = psngr_id;
END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION get_tickets_exp()
RETURNS TABLE (Id INT, Departure_city VARCHAR, Arrival_city VARCHAR, Departure_time TIMESTAMP, Arrival_time TIMESTAMP, Passenger VARCHAR, Passport VARCHAR, Plane VARCHAR, Ticket_price INT,  Payment_method VARCHAR, Purchase_time TIMESTAMP) AS
$$
BEGIN
	RETURN QUERY SELECT * FROM join_all_tables;
END;
$$ LANGUAGE plpgsql;

--------------------------------------

CREATE OR REPLACE FUNCTION get_tickets_exp(psngr_id INT)
RETURNS TABLE (Id INT, Departure_city VARCHAR, Arrival_city VARCHAR, Departure_time TIMESTAMP, Arrival_time TIMESTAMP, Passenger VARCHAR, Passport VARCHAR, Plane VARCHAR, Ticket_price INT,  Payment_method VARCHAR, Purchase_time TIMESTAMP) AS
$$
BEGIN
	RETURN QUERY SELECT * FROM join_all_tables j
					WHERE j.passport = (SELECT p.passport FROM passengers p WHERE p.id = psngr_id);
END;
$$ LANGUAGE plpgsql;

/*
select * from buy_ticket(3,1,'online');
SELECT * from refund_ticket(12);
SELECT * from get_tickets_exp();

SELECT * FROM add_passenger('Vladislav Kumbaruli', '1234567890');
SELECT * FROM passengers;
*/
