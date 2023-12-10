-- 1.
SELECT Name, Model FROM Airplanes
WHERE PassengerCapacity > 100;

-- 2.
SELECT * FROM Tickets
WHERE Price BETWEEN 100 AND 200;

-- 3.
SELECT FirstName, LastName
FROM Staff
WHERE Gender = 'Female' AND StaffRole = 'Pilot'
    AND StaffID IN (
        SELECT S.StaffID
        FROM Staff S
        JOIN Flights F ON S.FlightID = F.FlightID
        GROUP BY S.StaffID
        HAVING COUNT(F.FlightID) > 0
    );

