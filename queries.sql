
--  the number of bikes of each model available at all locations
SELECT ba.id,model_name, count(ba.id) AS "Nos."
FROM bike_availability ba 
JOIN bikes b ON b.id = ba.bike_model_id
JOIN location l on ba.loc_id = l.id
GROUP BY b.model_name;
-- WHERE l.loc_name = 'Whitefield'
-- WHERE model_name = 'NS200' AND l.loc_name = 'Whitefield'


-- bikes, model names and charges
SELECT ba.id,model_name, charge_per_hr 
FROM bike_availability ba 
JOIN bikes b ON b.id = ba.bike_model_id;

-- all bikes and all locations
SELECT ba.id, model_name, loc_name
FROM bike_availability ba
JOIN location l ON ba.loc_id = l.id 
JOIN bikes b ON ba.bike_model_id = b.id;

-- ================== Process of booking ================== --

-- display the list of bikes 
SELECT model_name from bikes;


-- check where the bike you want is availble along with their ids
SELECT ba.id,model_name, loc_name FROM bike_availability ba
JOIN bikes b ON ba.bike_model_id = b.id 
JOIN location l ON ba.loc_id = l.id
WHERE model_name = 'Duke 250';

-- per_hr_charge of bike you want to book
SELECT model_name, charge_per_hr FROM bikes
WHERE model_name = 'Duke 250';

-- book the bike

-- what is the final amount (including 28% tax) for the user
SELECT * FROM booking_details           
WHERE first_name = 'Arjun' AND last_name = 'Sharma';
--'booking_details' is a View

-----------------------------------------------------------------------

-- what is the charge per hr for a bike you booked
SELECT model_name, charge_per_hr FROM bike_availability ba 
JOIN bookings bk ON bk.bike_id = ba.id  
JOIN bikes b ON b.id = ba.bike_model_id 
WHERE bk.id = 1;


--================================================================================--

-- Sample data
INSERT INTO users(first_name, last_name, phone_no) VALUES ('Arjun', 'Sharma', '8865822948');
INSERT INTO users(first_name, last_name, phone_no) VALUES ('Michael', 'Brown', '3856009666');
INSERT INTO users(first_name, last_name, phone_no) VALUES ('David', 'Wilson', '7299665249');
INSERT INTO users(first_name, last_name, phone_no) VALUES ('James', 'Johnson', '4582993101');
INSERT INTO users(first_name, last_name, phone_no) VALUES ('Robert', 'Davis', '5844983313');


INSERT INTO location(loc_name) VALUES ('Whitefield');
INSERT INTO location(loc_name) VALUES ('Krishnarajapuram');
INSERT INTO location(loc_name) VALUES ('Marathahalli Bridge');
INSERT INTO location(loc_name) VALUES ('HSR Layout');
INSERT INTO location(loc_name) VALUES ('Indiranagar');


INSERT INTO bikes(model_name, model_year, charge_per_hr) VALUES('MT-15', 2023, 35.00);
INSERT INTO bikes(model_name, model_year, charge_per_hr) VALUES('NS200', 2018, 23.00);
INSERT INTO bikes(model_name, model_year, charge_per_hr) VALUES('Speed 400', 2023, 85.00);
INSERT INTO bikes(model_name, model_year, charge_per_hr) VALUES('Himalayan', 2023, 88.00);
INSERT INTO bikes(model_name, model_year, charge_per_hr) VALUES('Duke 250', 2020, 70.00);
INSERT INTO bikes(model_name, model_year, charge_per_hr) VALUES('RTR200', 2019, 45.00);


INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(1,2);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(1,2);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(1,3);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(1,6);

INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(2,4);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(2,4);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(2,4);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(2,5);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(2,2);

INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(3,5);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(3,1);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(3,2);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(3,3);

INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(4,5);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(4,5);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(4,5);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(4,6);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(4,1);

INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(5,6);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(5,6);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(5,4);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(5,3);
INSERT INTO bike_availability(loc_id, bike_model_id) VALUES(5,3);


-----------------------------------------------------------------


INSERT INTO bookings_user (fname, lname, bikeid, start_date, end_date)
VALUES ('Arjun','Sharma',10,'2024-07-01','2024-07-02');

INSERT INTO bookings_user (fname, lname, bikeid, start_date, end_date)
VALUES ('Michael','Brown',18,'2024-06-26','2024-06-30');

-- error check (should retrun error - overlapping slots)
INSERT INTO bookings_user (fname, lname, bikeid, start_date, end_date)
VALUES ('David','Wilson',18,'2024-06-25','2024-06-30');

INSERT INTO bookings_user (fname, lname, bikeid, start_date, end_date)
VALUES ('James','Johnson',9,'2024-05-07','2024-05-10');

INSERT INTO bookings_user (fname, lname, bikeid, start_date, end_date)
VALUES ('James','Johnson',9,'2024-05-07','2024-05-10');