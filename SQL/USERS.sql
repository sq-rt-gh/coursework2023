CREATE USER admin WITH PASSWORD 'admin';

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO admin;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO admin;
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA public TO admin;

------------------------------------------------

CREATE USER client WITH PASSWORD '123';

CREATE ROLE clients_group;
GRANT clients_group TO client;

GRANT EXECUTE ON PROCEDURE add_passenger, buy_ticket TO admin;
GRANT EXECUTE ON FUNCTION get_passenger, 
						  get_flights_exp,
						  get_tickets_exp,
						  refund_ticket TO clients_group;
						  
GRANT SELECT ON ALL TABLES IN SCHEMA public TO clients_group;
GRANT SELECT ON available_flights TO clients_group;

GRANT INSERT ON TABLE passengers, tickets, available_seats TO clients_group;
GRANT UPDATE ON TABLE available_seats TO clients_group;
GRANT DELETE ON TABLE tickets TO clients_group;
GRANT USAGE ON SEQUENCE passengers_id_seq, tickets_id_seq TO clients_group;

