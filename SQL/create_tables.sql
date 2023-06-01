CREATE TABLE planes --информация о самолетах
(
    id SERIAL NOT NULL PRIMARY KEY,    
	model VARCHAR(40),
    seats INT CHECK(seats > 0)    
);
-------------------------------------------
CREATE TABLE flights --расписание полетов
(
    id SERIAL NOT NULL PRIMARY KEY,    
	departure_city VARCHAR(40),
    arrival_city VARCHAR(40),    
	departure_time TIMESTAMP,
    arrival_time TIMESTAMP,
	ticket_price INT CHECK(ticket_price > 0),
	plane_id INT,
    
    CONSTRAINT FK_flight_plane FOREIGN KEY(plane_id) REFERENCES planes(id)
);
-------------------------------------------
CREATE TABLE passengers
(
    id SERIAL NOT NULL PRIMARY KEY,
    fio VARCHAR(100) NOT NULL,
    passport VARCHAR(15)
    --phone_number VARCHAR(15),
    --email VARCHAR(40)
);
-------------------------------------------
CREATE TABLE tickets --покупка/возврат билетов
(
    id SERIAL NOT NULL PRIMARY KEY,
	payment_method VARCHAR(20), --cash/credit card/google pay
	purchase_time TIMESTAMP,
    flight_id INT,    
    CONSTRAINT FK_ticket_flight FOREIGN KEY(flight_id) REFERENCES flights(id),
	plane_id INT,
	CONSTRAINT FK_ticket_plane FOREIGN KEY(plane_id) REFERENCES planes(id),
	passenger_id INT,
	CONSTRAINT FK_ticket_passenger FOREIGN KEY(passenger_id) REFERENCES passengers(id)
);

--------------------------------------------------------------------------------------------------------------------------

CREATE UNIQUE INDEX unique_passport_index ON passengers (passport)

--------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW join_all_tables AS 
	SELECT ti.id, f.departure_city, f.arrival_city, f.departure_time, f.arrival_time, p.fio, p.passport, 
			pl.model, f.ticket_price,  ti.payment_method, ti.purchase_time 
	FROM tickets ti 
	JOIN flights f ON f.id = ti.flight_id  
	JOIN planes pl ON pl.id = ti.plane_id
	JOIN passengers p ON p.id = ti.passenger_id;

