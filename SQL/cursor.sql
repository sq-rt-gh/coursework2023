CREATE OR REPLACE FUNCTION count_available_seats()
RETURNS VOID AS
$$
DECLARE
	_cursor CURSOR FOR SELECT id FROM flights;
	fl_id INT;
	plane_seats INT;
BEGIN
	OPEN _cursor;
	LOOP
		FETCH _cursor INTO fl_id;
		EXIT WHEN NOT FOUND;
		plane_seats := (SELECT pl.seats FROM flights f JOIN planes pl ON pl.id = f.plane_id WHERE f.id = fl_id);
		IF (EXISTS(SELECT 1 FROM available_seats WHERE flight_id = fl_id)) THEN
			UPDATE available_seats SET seats_left = 
				(plane_seats - (SELECT COUNT(*) FROM tickets ti WHERE ti.flight_id = fl_id))
				WHERE flight_id = fl_id;
		ELSE
			INSERT INTO available_seats VALUES(fl_id, plane_seats);
		END IF;
	END LOOP;
	CLOSE _cursor;
END;
$$ LANGUAGE plpgsql;
 