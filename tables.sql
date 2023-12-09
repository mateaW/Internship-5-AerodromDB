-- tables
CREATE TABLE Cities (
	CityID SERIAL PRIMARY KEY,
	CityName varchar(100) NOT NULL,
	Coordinates POINT NOT NULL
);

CREATE TABLE Airports (
	AirportID SERIAL PRIMARY KEY,
	Name VARCHAR(100) NOT NULL,
	CityID INT REFERENCES Cities(CityID),
	MaxCapacityRunway INT NOT NULL,
	MaxCapacityWarehouse INT NOT NULL
);

CREATE TABLE Airplanes (
	AirplaneID SERIAL PRIMARY KEY,
	Status VARCHAR(20) NOT NULL,
	Location VARCHAR(10) NOT NULL,
	PassengerCapacity INT NOT NULL,
	AirportID INT REFERENCES Airports(AirportID)
);

CREATE TABLE Flights (
	FlightID SERIAL PRIMARY KEY,
	AirplaneID INT REFERENCES Airplanes(AirplaneID),
	FlightCapacity INT NOT NULL,
	DepartureAirportID INT REFERENCES Airports(AirportID),
	DestinationAirportID INT REFERENCES Airports(AirportID),
	DepartureTime TIME,
	ArrivalTime TIME
);

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