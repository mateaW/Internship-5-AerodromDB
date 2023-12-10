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






