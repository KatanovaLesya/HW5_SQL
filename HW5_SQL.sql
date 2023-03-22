CREATE SCHEMA MyJoinsDB;

CREATE TABLE Employees
(EmployeesID INT auto_increment,
NameEmployee VARCHAR(20),
PhoneEmployee VARCHAR(15),
PRIMARY KEY(EmployeesID)
)
;

INSERT Employees (NameEmployee, PhoneEmployee) 
VALUES 
('Lesia Katanova', '+380664380410'),
('Stas Skalozub', '+380662226070'),
('Petro Varenyk', '+380662224080');


CREATE TABLE Positions
(PositionID INT auto_increment,
EmployeesID INT,
PositionEmployee VARCHAR(30),
SalaryEmployee INT,
PRIMARY KEY(PositionID)
);

ALTER TABLE Positions ADD CONSTRAINT `FK_Emp_Pos` FOREIGN KEY (`EmployeesID`) REFERENCES `MyJoinsDB`.`Employees` (`EmployeesID`);

INSERT Positions (PositionEmployee, SalaryEmployee) 
VALUES 
('General Director', 200000),
('Manager', 50000),
('Worker', 35000);

UPDATE `MyJoinsDB`.`Positions` SET `EmployeesID` = '1' WHERE (`PositionID` = '1');
UPDATE `MyJoinsDB`.`Positions` SET `EmployeesID` = '2' WHERE (`PositionID` = '2');
UPDATE `MyJoinsDB`.`Positions` SET `EmployeesID` = '3' WHERE (`PositionID` = '3');

ALTER TABLE `MyJoinsDB`.`Positions` ADD CONSTRAINT `FR_Pers`FOREIGN KEY (`PersonalID`) REFERENCES `MyJoinsDB`.`Personal` (`PersonalID`);

CREATE TABLE Personal
(PersonalID INT auto_increment,
EmployeesID INT,
MaritalStatus VARCHAR(20),
BirthDay date NOT NULL,
Adress VARCHAR(30),
PRIMARY KEY (PersonalID)
)
;
ALTER TABLE Personal ADD CONSTRAINT `FK_Employees` FOREIGN KEY (`EmployeesID`) REFERENCES `MyJoinsDB`.`Employees` (`EmployeesID`);
  
INSERT Personal (MaritalStatus, BirthDay, Adress) 
VALUES 
('married', '1982-09-24', 'KYIV'),
('married', '1981-11-30', 'TERNOPIL'),
('unmarried', '2000-01-13', 'TERNOPIL');

UPDATE `MyJoinsDB`.`Personal` SET `EmployeesID` = '1' WHERE (`PersonalID` = '1');
UPDATE `MyJoinsDB`.`Personal` SET `EmployeesID` = '2' WHERE (`PersonalID` = '2');
UPDATE `MyJoinsDB`.`Personal` SET `EmployeesID` = '3' WHERE (`PersonalID` = '3');

ALTER TABLE Personal ADD CONSTRAINT `FK_Pos`FOREIGN KEY (`PositionsID`) REFERENCES `MyJoinsDB`.`Positions` (`PositionID`);
UPDATE `MyJoinsDB`.`Personal` SET `PositionsID` = '1' WHERE (`PersonalID` = '1');
UPDATE `MyJoinsDB`.`Personal` SET `PositionsID` = '2' WHERE (`PersonalID` = '2');
UPDATE `MyJoinsDB`.`Personal` SET `PositionsID` = '3' WHERE (`PersonalID` = '3');

-- 1) Получите контактные данные сотрудников (номера телефонов, место жительства).
	-- метод JOIN
		SELECT Employees.NameEmployee, Employees.PhoneEmployee, Adress 
		FROM Employees
		JOIN Personal
		ON Employees.EmployeesID = Personal.EmployeesID; 
	
    -- метод вкладенного запиту
SELECT (SELECT NameEmployee FROM Employees 
	    WHERE Employees.EmployeesID = Personal.EmployeesID) AS NameEmployee,
	   (SELECT  PhoneEmployee FROM Employees 
	    WHERE Employees.EmployeesID = Personal.EmployeesID) AS PhoneEmployee, Adress
FROM Personal;

-- 2) Получите информацию о дате рождения всех холостых сотрудников и их номера.
-- метод JOIN
		SELECT Employees.NameEmployee, Employees.PhoneEmployee, Personal.MaritalStatus, Personal.BirthDay 
		FROM Employees
		JOIN Personal
		ON Employees.EmployeesID = Personal.EmployeesID
        WHERE Personal.MaritalStatus = 'married';
        
-- метод вкладенного запиту
SELECT (SELECT NameEmployee FROM Employees 
	    WHERE Employees.EmployeesID = Personal.EmployeesID) AS NameEmployee,
	   (SELECT  PhoneEmployee FROM Employees 
	    WHERE Employees.EmployeesID = Personal.EmployeesID) AS PhoneEmployee, Personal.MaritalStatus, Personal.BirthDay
FROM Personal
WHERE Personal.MaritalStatus = 'married';

-- 3) Получите информацию обо всех менеджерах компании: дату рождения и номер телефона. 
-- метод JOIN
		SELECT Employees.NameEmployee, Employees.PhoneEmployee, Personal.BirthDay, Positions.PositionEmployee 
		FROM Employees
			JOIN Personal
			ON Employees.EmployeesID = Personal.EmployeesID
        
			JOIN Positions
			ON Employees.EmployeesID = Positions.EmployeesID
        
			WHERE Positions.PositionEmployee = 'manager';
            
-- метод вкладенного запиту
SELECT (SELECT NameEmployee FROM Employees 
	    WHERE Employees.EmployeesID = 
		(SELECT EmployeesID FROM Personal WHERE Personal.PersonalID = Positions.PersonalID)
) AS NameEmployee, 
	   (SELECT  PhoneEmployee FROM Employees 
	    WHERE Employees.EmployeesID = 
        (SELECT EmployeesID FROM Personal WHERE Personal.PersonalID = Positions.PersonalID)
) AS PhoneEmployee, Positions.PositionEmployee,
		(SELECT BirthDay FROM Personal 
	    WHERE Personal.EmployeesID = 
		(SELECT EmployeesID FROM Personal WHERE Personal.PersonalID = Positions.PersonalID)
) AS BirthDay
FROM Positions
WHERE Positions.PositionEmployee = 'manager';
