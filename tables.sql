-- tables
CREATE TABLE Airports (
	AirportID SERIAL PRIMARY KEY,
	Name VARCHAR(100) NOT NULL,
	MaxCapacityRunway INT NOT NULL,
	MaxCapacityWarehouse INT NOT NULL
);

ALTER TABLE Airports 
ADD COLUMN City VARCHAR(100) NOT NULL;

CREATE TABLE Airplanes (
	AirplaneID SERIAL PRIMARY KEY,
	Status VARCHAR(20) NOT NULL,
	Location VARCHAR(10) NOT NULL,
	PassengerCapacity INT NOT NULL,
	AirportID INT REFERENCES Airports(AirportID)
);

ALTER TABLE Airplanes
ADD COLUMN Name VARCHAR(50) NOT NULL;

ALTER TABLE Airplanes
ADD COLUMN Model VARCHAR(50) NOT NULL;

ALTER TABLE Airplanes
ADD COLUMN Company VARCHAR(50) NOT NULL;

CREATE TABLE Flights (
	FlightID SERIAL PRIMARY KEY,
	AirplaneID INT REFERENCES Airplanes(AirplaneID),
	FlightCapacity INT NOT NULL,
	DepartureAirportID INT REFERENCES Airports(AirportID),
	DestinationAirportID INT REFERENCES Airports(AirportID),
	DepartureTime TIME,
	ArrivalTime TIME
);

-- change into timestamp so we can see year and date also
ALTER TABLE Flights DROP COLUMN DepartureTime;
ALTER TABLE Flights DROP COLUMN ArrivalTime;

ALTER TABLE Flights
ADD COLUMN DepartureTime TIMESTAMP;
ALTER TABLE Flights
ADD COLUMN ArrivalTime TIMESTAMP;

-- departure airport is airportID from airplaneID
ALTER TABLE Flights
DROP COLUMN DepartureAirportID;

CREATE TABLE Users (
	UserID SERIAL PRIMARY KEY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Birth DATE,
	E_mail VARCHAR(50),
	LoyaltyCardeExpiryDate DATE
);

CREATE TABLE Tickets (
	TicketID SERIAL PRIMARY KEY,
	UserID INT REFERENCES Users(UserID),
	FlightID INT REFERENCES Flights(FlightID),
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	SeatClass VARCHAR(1) NOT NULL,
	SeatNumber INT NOT NULL,
	Price DECIMAL NOT NULL,
	PurchaseDate DATE NOT NULL
);

CREATE TABLE Staff (
	StaffID SERIAL PRIMARY KEY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	StaffRole VARCHAR(50) NOT NULL,
	Birth DATE,
	Gender VARCHAR(10) NOT NULL,
	FlightID INT REFERENCES Flights(FlightID)
);

CREATE TABLE Reviews (
	ReviewID SERIAL PRIMARY KEY,
	UserID INT REFERENCES Users(UserID),
	FlightID INT REFERENCES Flights(FlightID),
	CommentContent TEXT,
	Rating INT NOT NULL
);

-- constraints 
ALTER TABLE Airplanes
    ADD CONSTRAINT CK_Status CHECK (
        Status IN ('Active', 'For Sale', 'Under Repair', 'Disassembled')),
    ADD CONSTRAINT CK_Location CHECK (
        Location IN ('Air', 'Runway', 'Warehouse'));
		
ALTER TABLE Tickets
    ADD CONSTRAINT CK_SeatClass CHECK (
        SeatClass IN ('A', 'B'));
	
ALTER TABLE Staff
	ADD CONSTRAINT CK_Gender CHECK (Gender IN ('Male', 'Female')),
    ADD CONSTRAINT CK_StaffRole CHECK (StaffRole IN ('Pilot', 'Flight Attendant', 'Technical Staff')),
    ADD CONSTRAINT CK_PilotAge CHECK (
        CASE 
            WHEN StaffRole = 'Pilot' THEN 
			EXTRACT(YEAR FROM AGE(NOW(), Birth)) >= 20 AND EXTRACT(YEAR FROM AGE(NOW(), Birth)) <= 60
        ELSE true
        END);  
	
ALTER TABLE Reviews
    ADD CONSTRAINT CK_Rating CHECK (Rating >= 1 AND Rating <= 5);
	
-- function to check if FlightCapacity <= PassengerCapacity
CREATE OR REPLACE FUNCTION ck_capacity(flight_capacity INT, airplane_id INT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN flight_capacity <= 
  (SELECT PassengerCapacity FROM Airplanes 
   WHERE AirplaneID = airplane_id);
END;
$$ LANGUAGE plpgsql;

-- constraint using the function above
ALTER TABLE Flights
ADD CONSTRAINT CK_Capacity CHECK (ck_capacity(FlightCapacity, AirplaneID));

-- function to check if user can make a loyalty card
CREATE OR REPLACE FUNCTION ck_loyalty_card()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.LoyaltyCardeExpiryDate IS NULL AND (
    SELECT COUNT(*) FROM Tickets WHERE UserID = NEW.UserID) < 10 
	THEN
    RAISE EXCEPTION 'User must have at least 10 bought tickets before havin a Loyalty Card';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- trigger that calls the function before inserting or updating the Users table:
CREATE TRIGGER trigger_ck_loyalty_card
BEFORE INSERT OR UPDATE ON Users
FOR EACH ROW
EXECUTE FUNCTION ck_loyalty_card();








	
	
	
	
	
	
	
	