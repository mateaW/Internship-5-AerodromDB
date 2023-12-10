-- 1.
SELECT Name, Model FROM Airplanes
WHERE PassengerCapacity > 100;

-- 2.
SELECT * FROM Tickets
WHERE Price BETWEEN 100 AND 200;

-- 3.
SELECT DISTINCT s.FirstName, s.LastName, s.Gender, COUNT(f.FlightID) AS NumberOfFlights
FROM Staff s
JOIN Flights f ON s.FlightID = f.FlightID
WHERE s.Gender = 'Female' AND S.StaffRole = 'Pilot'
GROUP BY s.FirstName, s.LastName, s.Gender
HAVING COUNT(f.FlightID) > 20;

-- 4.
SELECT s.FirstName, s.LastName, a.Location 
FROM Staff s
JOIN Flights f ON s.FlightID = f.FlightID
JOIN Airplanes a ON f.AirplaneID = a.AirplaneID
WHERE s.StaffRole = 'Flight Attendant' AND a.Location = 'InAir';

-- 5.
SELECT COUNT(*) FROM Flights f
JOIN Airports a ON f.DestinationAirportID = a.AirportID
WHERE (a.City = 'Split' OR 
f.DestinationAirportID IN (SELECT AirportID FROM Airports 
WHERE City = 'Split'))
AND EXTRACT(YEAR FROM DepartureTime) = 2023;

-- 6. 
SELECT * FROM Flights
WHERE DestinationAirportID = (SELECT AirportID FROM Airports WHERE City = 'Vienna')
AND EXTRACT(YEAR FROM DepartureTime) = 2023
AND EXTRACT(MONTH FROM DepartureTime) = 12;

-- 7.
SELECT COUNT(*) AS NumberOfSoldEconomyFlights
FROM Tickets t
JOIN Flights f ON t.FlightID = f.FlightID
JOIN Airplanes a ON f.AirplaneID = a.AirplaneID
WHERE a.Company = 'AirDUMP'
AND t.SeatClass = 'B'
AND EXTRACT(YEAR FROM t.PurchaseDate) = 2021;

-- 8.
SELECT AVG(r.Rating) AS AverageFlightRating FROM Reviews r
JOIN Flights f ON r.FlightID = f.FlightID
JOIN Airplanes a ON f.AirplaneID = a.AirplaneID
WHERE a.Company = 'AirDUMP';


-- 9.
SELECT a.Name, COUNT(*) AS NumberOfAirbusPlanes FROM Airports a
JOIN Airplanes ap ON a.AirportID = ap.AirportID
WHERE ap.Model = 'Airbus'
AND ap.Location = 'Runway' AND a.City = 'London'
GROUP BY a.AirportID
ORDER BY NumberOfAirbusPlanes DESC;

-- 10.
UPDATE Tickets
SET Price = Price * 0.8
WHERE FlightID IN (SELECT FlightID
FROM Flights WHERE FlightCapacity < 20
);

-- 11.
ALTER TABLE Staff
ADD COLUMN Salary INT;

UPDATE Staff
SET Salary = Salary + 100
WHERE StaffID IN (SELECT DISTINCT s.StaffID FROM Staff s
JOIN Flights f ON s.FlightID = f.FlightID
WHERE s.StaffRole = 'Pilot'
AND EXTRACT(YEAR FROM f.DepartureTime) = EXTRACT(YEAR FROM CURRENT_DATE)
AND f.ArrivalTime - f.DepartureTime > INTERVAL '10 hours'
GROUP BY s.StaffID HAVING COUNT(*) > 10
);

-- 12. 
ALTER TABLE Airplanes
ADD COLUMN YearOfManufacture DATE;

UPDATE Airplanes
SET Status = 'Disassembled'
WHERE EXTRACT(YEAR FROM AGE(NOW(), YearOfManufacture)) > 20
AND AirplaneID NOT IN (SELECT DISTINCT AirplaneID FROM Flights
WHERE DepartureTime > NOW());
	  
-- 13.
DELETE FROM Flights
WHERE FlightID NOT IN (SELECT FlightID FROM Tickets);

-- 14.
UPDATE Users
SET LoyaltyCardeExpiryDate = NULL
WHERE LastName LIKE '%ov' OR LastName LIKE '%ova' 
OR LastName LIKE '%in' OR LastName LIKE '%ina';











