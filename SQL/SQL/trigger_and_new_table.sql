CREATE TABLE available_seats
(
	flight_id INT NOT NULL PRIMARY KEY,
	seats_left INT
);

-----------------------------------------------------------
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

-------------------------------------------------------
CREATE TRIGGER seat_counter AFTER INSERT OR UPDATE OR DELETE
ON tickets FOR EACH ROW
EXECUTE PROCEDURE trig_ticket_operation();


--SELECT * from available_seats;
