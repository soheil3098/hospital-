CREATE OR ALTER PROCEDURE PRC_Users_INS
  @FirstName NVARCHAR(30),
  @LastName NVARCHAR(30),
  @LoginName NVARCHAR(30),
  @HashPassword NVARCHAR(50),
  @Email NVARCHAR(30),
  @Phonenumber NVARCHAR(30),
  @Address NVARCHAR(100),
  @IsActive bit,
  @Deleted BIT
AS
INSERT INTO Users (FirstName, LastName, LoginName, HashPassword, Email, Phonenumber, Address, IsActive, Deleted)
  VALUES (@FirstName, @LastName, @LoginName, @HashPassword, @Email, @Phonenumber, @Address, 0, DEFAULT);
GO
--------------------------------------------------------------------
--منطقی حذف
CREATE OR ALTER PROCEDURE PRC_Users_Del
  @UserID INT
  AS
    UPDATE Users SET Deleted=1
    WHERE UsersID=@UserID

GO
---------------------------------------------------------------------
CREATE OR ALTER PROCEDURE PRC_Users_Update
  @UserID INT,
  @FirstName NVARCHAR(30),
  @LastName NVARCHAR(30),
  @LoginName NVARCHAR(30),
  @HashPassword NVARCHAR(50),
  @Email NVARCHAR(30),
  @Phonenumber NVARCHAR(30),
  @Address NVARCHAR(100)
  AS

UPDATE Users 
SET FirstName = @FirstName
   ,LastName = @LastName
   ,LoginName = @LoginName
   ,HashPassword = @HashPassword
   ,Email = @Email
   ,Phonenumber = @Phonenumber
   ,Address = @Address
   
WHERE UsersID = @UserID;

DECLARE @GetIP VARCHAR(15) ---- get user IP address
SELECT @GetIP=CONVERT(VARCHAR,CONNECTIONPROPERTY('client_net_address'))

INSERT INTO UserLog (UsersID, FirstName, LastName, LoginName, HashPassword, Email, Phonenumber, Address, DELETED, Updated, ClientIP)
  VALUES (@UserID, @FirstName, @LastName, @LoginName, @HashPassword, @Email, @Phonenumber, @Address, 0, DEFAULT, @GetIP);
------------------------------------------------------------------------
CREATE TABLE UserLog
(
  UserLog INT PRIMARY KEY IDENTITY,
  UsersID INT ,
  FirstName NVARCHAR(30),
  LastName NVARCHAR(30),
  LoginName NVARCHAR(30),
  HashPassword NVARCHAR(50),
  Email NVARCHAR(30),
  Phonenumber NVARCHAR(30),
  Address NVARCHAR(100),
  DELETED BIT,
  Updated DATETIME DEFAULT GETDATE(),
  ClientIP VARCHAR(20)

)
GO
-----------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE PRC_Patients_INS
  @FirstName NVARCHAR(30),
  @LastName NVARCHAR(30),
  @NationalCode BIGINT,
  @BirthDate DATETIME,
  @gender NVARCHAR(8),
  @Phone NVARCHAR(15),
  @Addres NVARCHAR(200)
  AS 
      INSERT INTO Patients(FirstName,LastName,NationalCode,BirthDate,gender,Phone,Addres,RegisterDate)
      VALUES(@FirstName,@LastName,@NationalCode,@BirthDate,@gender,@Phone,@Addres,GETDATE())
    

CREATE OR ALTER PROCEDURE PRC_Patients_Del
  @PatinentID INT
  AS
    UPDATE patients SET Deleted=1
    WHERE PatinentID=@PatinentID

GO

CREATE OR ALTER PROCEDURE PRC_Patients_Update
  @PatinentID INT,
  @FirstName NVARCHAR(30),
  @LastName NVARCHAR(30),
  @NationalCode BIGINT,
  @BirthDate DATETIME,
  @gender NVARCHAR(8),
  @Phone NVARCHAR(15),
  @Addres NVARCHAR(200)
  AS 
  UPDATE patients 
SET FirstName = @FirstName
   ,LastName = @LastName
   ,NationalCode = @NationalCode
   ,BirthDate = @BirthDate
   ,gender = @gender
   ,Phone = @Phone
   ,Addres = @Addres
  
WHERE PatinentID = @PatinentID
 INSERT INTO Patients(PatinentID,FirstName,LastName,NationalCode,BirthDate,gender,Phone,Addres,RegisterDate)
      VALUES(@PatinentID,@FirstName,@LastName,@NationalCode,@BirthDate,@gender,@Phone,@Addres,GETDATE())







CREATE TABLE PatientsLog
(
  PatientsLog INT PRIMARY KEY IDENTITY,
  PatientsID INT ,
  FirstName NVARCHAR(30),
  LastName NVARCHAR(30),
  NationalCode BIGINT,
  BirthDate DATETIME,
  gender NVARCHAR(8),
  Phone NVARCHAR(15),
  Addres NVARCHAR(200),
  RegisterDate DATETIME)
---------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROC PRC_Medicines_INS
@MedicinesName NVARCHAR(100) , 
@Manufacture NVARCHAR(100) , 
@UnitePrice DECIMAL(18 , 2) , 
@StockQuantity INT
AS
	INSERT INTO Medicines (MedicinesName, Manufacture, UnitePrice, StockQuantity)
VALUES(@MedicinesName, @Manufacture, @UnitePrice, @StockQuantity);

GO



CREATE OR ALTER PROC PRC_Medicines_Del
@MedicinesID INT 
AS
	UPDATE Medicines SET DELETED = 1 
	WHERE MedicinesID = @MedicinesID

GO

CREATE OR ALTER PROC PRC_Medicines_Up
@MedicineID INT , 
@MedicinesName NVARCHAR(100) , 
@Manufacture NVARCHAR(100) , 
@UnitePrice DECIMAL(18 , 2) , 
@StockQuantity INT 
AS
	UPDATE Medicines 
SET MedicinesName = @MedicinesName, Manufacture = @Manufacture, UnitePrice = @UnitePrice, StockQuantity = @StockQuantity
WHERE MedicinesID = @MedicineID;