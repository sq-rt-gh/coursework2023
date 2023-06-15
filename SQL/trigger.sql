CREATE OR REPLACE FUNCTION trig_ticket_operation()
RETURNS TRIGGER AS
$$
BEGIN
	IF TG_OP = 'INSERT' THEN
		IF (NOT EXISTS(SELECT 1 FROM available_seats a WHERE NEW.flight_id = a.flight_id)) THEN
			INSERT INTO available_seats VALUES( NEW.flight_id, (SELECT pl.seats - 1 FROM planes pl WHERE pl.id = (SELECT f.plane_id FROM flights f WHERE f.id = NEW.flight_id) ));
		ELSE
			UPDATE available_seats SET seats_left = seats_left - 1 WHERE flight_id = NEW.flight_id;
		END IF;
	ELSEIF TG_OP = 'DELETE' THEN
		UPDATE available_seats  SET seats_left = seats_left + 1 WHERE flight_id = OLD.flight_id;
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER seat_counter AFTER INSERT OR DELETE ON tickets 
FOR EACH ROW EXECUTE PROCEDURE trig_ticket_operation();


-------------------------------------------------------


CREATE OR REPLACE FUNCTION trig_change_view()
RETURNS TRIGGER AS 
$$
BEGIN
	IF TG_OP = 'INSERT' THEN
		CALL add_flight(new.departure_city, new.arrival_city, new.departure_time, new.arrival_time, 
						new.ticket_price, (SELECT pl.id FROM planes pl WHERE pl.model = new.model));
	
	ELSEIF TG_OP = 'UPDATE' THEN
		UPDATE flights SET departure_city = new.departure_city, 
						   arrival_city = new.arrival_city, 
						   departure_time = new.departure_time, 
						   arrival_time = new.arrival_time,
						   ticket_price = new.ticket_price
		WHERE id = (SELECT ti.flight_id FROM tickets ti WHERE ti.id = old.id);
		
		IF (old.fio <> new.fio) OR (old.passport <> new.passport) THEN
			UPDATE passengers SET fio = new.fio, passport = new.passport
			WHERE passport = old.passport;
		END IF;
		IF old.model <> new.model THEN
			UPDATE planes SET model = new.model 
			WHERE id = (SELECT ti.plane_id FROM tickets ti WHERE ti.id = old.id);
		END IF;
	ELSEIF TG_OP = 'DELETE' THEN
		DELETE FROM tickets WHERE id = old.id;
	END IF;
	
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER change_view_trigger INSTEAD OF INSERT OR UPDATE OR DELETE ON join_all_tables 
FOR EACH ROW EXECUTE PROCEDURE trig_change_view();

