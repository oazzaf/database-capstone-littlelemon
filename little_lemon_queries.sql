-- View for orders with quantity greater than 2
CREATE VIEW OrdersView AS (
SELECT OrderID, Quantity, Bill_Amount
FROM Orders
WHERE Quantity > 2
);

-- Order details for orders with cost greater than 150
SELECT
    c.CustomerID,
    c.FullName,
    o.OrderID,
    o.TotalCost,
    m.Cuisine,
    mi.CourseName
FROM Orders o
INNER JOIN Customers c
  ON o.CustomerID = c.CustomerID
INNER JOIN Menus m
  ON o.MenuID = m.MenuID
INNER JOIN MenuItems mi
  ON m.MenuItemsID = mi.MenuItemsID
WHERE o.TotalCost > 150
ORDER BY o.TotalCost;

-- Stored procedure to get the order with the max quantity 
CREATE PROCEDURE GetMaxQuantity()  
AS
BEGIN
    SELECT MAX(Quantity) AS "Max Quantity in Order"
    FROM Orders;
END;

-- Call the GetMaxQuantity procedure
CALL GetMaxQuantity();

-- Prepared statement to get order details using user input order id
PREPARE GetOrderDetail 
FROM 'SELECT OrderID, Quantity, TotalCost FROM Orders WHERE OrderID = ?';
SET @id = 1;
EXECUTE GetOrderDetail USING @id;

-- Stored procedure to manage a booking (Add, Update, Cancel)
DELIMITER //
CREATE PROCEDURE ManageBooking(
    IN action VARCHAR(10), 
    IN bookingID INT, 
    IN bookingDate DATE NULL, 
    IN tableNumber INT NULL, 
    IN customerID INT NULL, 
    IN employeeID INT NULL
)
BEGIN
    IF action = 'ADD' THEN
        INSERT INTO Bookings (BookingID, BookingDate, TableNumber, CustomerID, EmployeeID) 
        VALUES (bookingID, bookingDate, tableNumber, customerID, employeeID);
        SELECT CONCAT("New Booking ID ", bookingID, " Added.") AS Confirmation;
    ELSEIF action = 'UPDATE' THEN
        UPDATE Bookings 
        SET BookingDate = bookingDate, TableNumber = tableNumber, CustomerID = customerID, EmployeeID = employeeID 
        WHERE BookingID = bookingID;
        SELECT CONCAT("Booking ID ", bookingID, " Updated.") AS Confirmation;
    ELSEIF action = 'CANCEL' THEN
        DELETE FROM Bookings WHERE BookingID = bookingID;
        SELECT CONCAT("Booking ID ", bookingID, " Cancelled.") AS Confirmation;
    ELSE
        SELECT "Invalid Action. Use ADD, UPDATE, or CANCEL." AS Confirmation;
    END IF;
END//
DELIMITER ;

-- Call the ManageBooking procedure for various actions
CALL ManageBooking('ADD', 7, '2023-12-01', 3, 2, 1);    -- To add a new booking
CALL ManageBooking('UPDATE', 7, '2023-12-02', 4, 2, 1); -- To update an existing booking
CALL ManageBooking('CANCEL', 7, NULL, NULL, NULL, NULL); -- To cancel a booking

-- Check the Bookings table
SELECT * FROM Bookings;
