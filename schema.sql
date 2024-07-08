-- .shell cls -> to clear sqlite terminal

CREATE TABLE users (
    id INTEGER,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    phone_no TEXT UNIQUE,
    PRIMARY KEY (id),
    CHECK(length(phone_no) == 10)
);

CREATE TABLE location (
    id INTEGER,
    loc_name TEXT NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE bikes (
    id INTEGER,
    model_name TEXT NOT NULL,
    model_year INTEGER,
    charge_per_hr NUMERIC,
    PRIMARY KEY(id)
);

CREATE TABLE bike_availability (
    id INTEGER,                             -- this is the bike_uid (unique id for each bike; even for same model in same loc)
    loc_id INTEGER,
    bike_model_id INTEGER,                  -- id for bike model
    PRIMARY KEY(id)
    FOREIGN KEY(loc_id) REFERENCES location(id),
    FOREIGN KEY(bike_model_id) REFERENCES bikes(id)
);

CREATE TABLE bookings (
    id INTEGER,
    user_id INTEGER,
    bike_id INTEGER,            -- unique id
    start_date TEXT NOT NULL,
    end_date TEXT NOT NULL,
    PRIMARY key(id),
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(bike_id) REFERENCES bike_availability(id)
    -- CHECK(start_date != end_date)               -- both dates cannot be same
);

CREATE TABLE bookings_user (        -- table used by user to book a bike
    id INTEGER,
    fname TEXT,
    lname TEXT,
    bikeid INTEGER,
    start_date TEXT NOT NULL,
    end_date TEXT NOT NULL,
    PRIMARY key(id)
    FOREIGN KEY(fname) REFERENCES users(first_name),
    FOREIGN KEY(lname) REFERENCES users(last_name),
    FOREIGN KEY(bikeid) REFERENCES bike_availability(id)
    CHECK(start_date != end_date) 
);

CREATE TABLE cost (
    id INTEGER,
    booking_id INTEGER,
    "total_cost (Rs.)" NUMERIC,
    PRIMARY KEY(id),
    FOREIGN KEY(booking_id) REFERENCES bookings(id)
);

-- View
CREATE VIEW booking_details AS
    SELECT first_name, last_name, b.model_name, start_date, end_date, 'Rs.'||"total_cost (Rs.)" 
    FROM bookings bk
    JOIN cost c ON bk.id = c.booking_id
    JOIN users u ON bk.user_id = u.id 
    JOIN bike_availability ba ON ba.id = bk.bike_id
    JOIN bikes b ON b.id = ba.bike_model_id;


------------------------------------------------------------------------------------

CREATE TRIGGER concurrent_entry
BEFORE INSERT ON bookings_user
FOR EACH ROW
BEGIN
    INSERT INTO bookings (user_id, bike_id, start_date, end_date)
    VALUES (
            (SELECT id FROM users WHERE first_name = NEW.fname and last_name = NEW.lname),
            NEW.bikeid,
            NEW.start_date, NEW.end_date
    );
END;


CREATE TRIGGER check_availability
BEFORE INSERT ON bookings
FOR EACH ROW
BEGIN
    SELECT CASE
        WHEN EXISTS (
            SELECT 1 FROM bookings
            WHERE NEW.bike_id = bike_id 
            AND (
                (NEW.start_date BETWEEN start_date AND end_date) OR
                (NEW.end_date BETWEEN start_date AND end_date) OR
                (start_date BETWEEN NEW.start_date AND NEW.end_date)
            )
        )
        THEN RAISE(FAIL, 'Slot is not available')
    END;
END;

-- trigger to simultaneously delete entries bookings_user table
CREATE TRIGGER delete_booking_user
AFTER DELETE ON bookings
FOR EACH ROW
BEGIN
    DELETE FROM bookings_user
    WHERE 
        fname = (SELECT first_name FROM users WHERE id = OLD.user_id)
        AND lname = (SELECT last_name FROM users WHERE id = OLD.user_id) 
        AND bikeid = OLD.bike_id 
        AND start_date = OLD.start_date 
        AND end_date = OLD.end_date;
END;

-- delete cost entry when booking is deleted
CREATE TRIGGER delete_cost
AFTER DELETE ON bookings
FOR EACH ROW
BEGIN
    DELETE from cost 
    WHERE booking_id = OLD.id;
END;

CREATE TRIGGER amt_calc
AFTER INSERT ON bookings
FOR EACH ROW
BEGIN
    INSERT INTO cost (booking_id, "total_cost (Rs.)")
    VALUES (
        NEW.id,
        ((julianday(NEW.end_date) - julianday(NEW.start_date)) * 24 * 
            (SELECT charge_per_hr FROM bike_availability ba 
            JOIN bookings bk ON bk.bike_id = ba.id  
            JOIN bikes b ON b.id = ba.bike_model_id 
            WHERE ba.id = NEW.bike_id)
        ) * 1.28
    );  
END;
-- 1.28 - for adding 28% tax


------------------------------------------------------------------------------------
-- Indexes

CREATE INDEX "user_name_search" ON "users"("first_name", "last_name");
CREATE INDEX "bike_model_name_search" ON "bikes"("model_name");
CREATE INDEX "bike_charge_per_hr_search" ON "bikes"("charge_per_hr");
CREATE INDEX "loc_name_search" ON "location"("loc_name");



DELETE FROM bookings;

SELECT * FROM bookings;
SELECT * FROM bookings_user;
SELECT * FROM cost;
