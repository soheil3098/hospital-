CREATE TABLE patients
(
	ID INT PRIMARY KEY IDENTITY,
  FirstName NVARCHAR(30),
  LastName NVARCHAR(30),
  NationalCode BIGINT,
  BirthDate DATETIME,
  gender NVARCHAR(8),
  Phone NVARCHAR(15),
  Addres NVARCHAR(200),
  RegisterDate DATETIME

)
GO

CREATE TABLE Doctors
(
	DoctorID INT PRIMARY KEY,
  FirstName NVARCHAR(30),
  LastName NVARCHAR(30),
  Expertise NVARCHAR(30),
  Phone NVARCHAR(15),
  Email NVARCHAR(30),
  HireDate DATETIME
)
GO

CREATE TABLE Appointment
(
	AppointmentID INT PRIMARY KEY IDENTITY,
  DoctorID INT,
  PatinentID INT,
  AppointmentDATETIME DATETIME,
  IsComplited bit
)
GO
CREATE TABLE Department
(
	DepartmentID int,
  DepartmentName NVARCHAR(30),
  FloorNumber int,
  DoctorID int
)
GO

ALTER TABLE Department ADD FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID) ---add foreign key


CREATE TABLE Staff
(
	StaffID INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30),
  LastName NVARCHAR(30),
  Position NVARCHAR(30),
  DepartmentID INT  ,
  email NVARCHAR(30),
  HireDate DATETIME
)
GO
ALTER TABLE Staff ADD FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)



CREATE TABLE StaffBox
(
	StaffBoxID INT PRIMARY KEY IDENTITY,
  massage NVARCHAR(200),
  SendDate DATETIME,
  IsRead BIT,
  StaffID INT FOREIGN KEY REFERENCES Staff(StaffID) ,
)
GO

CREATE TABLE JobInformation
(
	JobInformationID int PRIMARY KEY IDENTITY,
  JobTitle NVARCHAR(30),
  StaffID INT FOREIGN KEY REFERENCES Staff(StaffID),
  DepartmentID INT FOREIGN KEY REFERENCES Department(DepartmentID),
  Hiredate DATETIME
)
GO
CREATE TABLE StaffFeedback
(
	StaffFeedbackID INT PRIMARY KEY IDENTITY,
  StaffID INT FOREIGN KEY REFERENCES Staff(StaffID),
  FeedbackText NVARCHAR(200),
  FeedbackDate DATETIME
)
GO

CREATE TABLE Medicines
(
	MedicinesID INT PRIMARY KEY IDENTITY,
  MedicinesName NVARCHAR(60),
  Manufacture NVARCHAR(60),
  UnitePrice DECIMAL(18,2),
  Stockquantity INT

)
GO
CREATE TABLE MedicinesOutgoingInvoice
(
  InvoiceID INT PRIMARY KEY IDENTITY,
  PatinentID INT FOREIGN KEY REFERENCES patients(PatinentID),
  IssueDate DATETIME,
  TotalAmount DECIMAL(18,2),


)
GO

CREATE TABLE MedicinesOutgoingInvoiceDetails
(
  DetailsID INT PRIMARY KEY IDENTITY,
  InvoiceID INT FOREIGN KEY REFERENCES MedicinesOutgoingInvoice(InvoiceID),
  MedicinesID INT FOREIGN KEY REFERENCES Medicines(MedicinesID),
  Quantity INT,
  TotalAmount DECIMAL(18,2)
)
GO

CREATE TABLE MedicalDocument
(
	MedicalDocumentID INT PRIMARY KEY IDENTITY,
  PatinentID int FOREIGN KEY REFERENCES patients(PatinentID),
  MedicalType NVARCHAR(100),
  MedicalDate DATETIME,
  MedicalContent NVARCHAR(300)

)
GO
CREATE TABLE SpecialReport
(
  SpicialReportID INT PRIMARY KEY IDENTITY,
  patinentID int FOREIGN KEY REFERENCES patients(PatinentID),
  ReportType NVARCHAR(200),
  ReportDate DATETIME,
  ReportContent NVARCHAR(300)

)GO

CREATE TABLE Inovices
(
  InovicesID INT PRIMARY KEY IDENTITY,
  PatinentID int FOREIGN KEY REFERENCES patients(PatinentID),
  InovicesDate DATETIME,
  TotalAmount DECIMAL(18,2),
  ISpaid BIT
)
GO



CREATE TABLE Payments
(
	PaymentID INT PRIMARY KEY IDENTITY,
	PatinentID int FOREIGN KEY REFERENCES patients(PatinentID),
  InovicesID INT FOREIGN KEY REFERENCES Inovices(InovicesID),
  PaymantDate DATETIME,
  Amount DECIMAL(18,2)

)
GO

CREATE TABLE PatinentFeedback
(
	PatinentFeedbackID INT PRIMARY KEY IDENTITY,
  FeedbackText NVARCHAR(300),
  PatinentID int FOREIGN KEY REFERENCES patients(PatinentID),
  FeedbackDate DATETIME
	
)
GO

CREATE TABLE TaxInvoices
(
	TaxInvoicesID INT PRIMARY KEY IDENTITY,
  InvoicesID INT FOREIGN KEY REFERENCES Inovices(InovicesID),
  TaxAmount DECIMAL(18,2),
  TaxRate DECIMAL(5,2),
)
GO

CREATE TABLE PaidTaxes
(
	PaidTaxesID INT PRIMARY KEY IDENTITY,
  TaxInvoicesID INT FOREIGN KEY REFERENCES TaxInvoices(TaxInvoicesID),
  PaymentDate DATETIME,
  Amount DECIMAL(18,2),
  
)
GO

CREATE TABLE Hospital
(
	HospitalID INT PRIMARY KEY IDENTITY,
	HospitalNAme NVARCHAR(30),
  Addres NVARCHAR(150),
  PhoneNumber NVARCHAR(20)

)
GO
CREATE TABLE Users
(
  UsersID INT PRIMARY KEY IDENTITY,
  FirstName NVARCHAR(30),
  LastName NVARCHAR(30),
  LoginName NVARCHAR(30),
  HashPassword NVARCHAR(50),
  Email NVARCHAR(30),
  Phonenumber NVARCHAR(30),
  Address NVARCHAR(100),
  IsActive bit

)
GO
CREATE TABLE Roles
(
	RolesID INT PRIMARY KEY IDENTITY,
  RolesName NVARCHAR(30)
	
)
GO

CREATE TABLE UsersRoles
( 
  UsersRolesID INT PRIMARY KEY IDENTITY,
  UsersID INT FOREIGN KEY REFERENCES Users(UsersID),
  RolesID INT FOREIGN KEY REFERENCES Roles(RolesID)
  )
  go

CREATE TABLE Visits
(
	VisitsID INT PRIMARY KEY IDENTITY,
	PatinentID INT FOREIGN KEY REFERENCES patients(PatinentID),
  DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),
  DepartmentID int FOREIGN KEY REFERENCES Department(DepartmentID),
  VisitsDate DATETIME,
  Diagnosis NVARCHAR (200),
  Prescription NVARCHAR(200),

)
GO

CREATE TABLE Tests
(
	TestID INT PRIMARY KEY IDENTITY,
	TestName NVARCHAR(100),
  Description NVARCHAR(200),
  Price DECIMAL(18,2)
)
GO

CREATE TABLE TestResult
(
	TestResultID INT PRIMARY KEY IDENTITY,
	TestID INT FOREIGN KEY REFERENCES Tests(TestID),
  PatinentID INT FOREIGN KEY REFERENCES patients(PatinentID),
  ResultDetails NVARCHAR(200),
  CreatDate DATETIME,
  VisitsID INT FOREIGN KEY REFERENCES Visits(VisitsID),
  DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),

)
GO

CREATE TABLE FinancialTransaction
(
  FinancialTransactionID INT PRIMARY KEY IDENTITY,
  VisitsID INT FOREIGN KEY REFERENCES Visits(VisitsID),
  TransactionType NVARCHAR(200),
  Amount DECIMAL(18,2),
  TransactionDate DATETIME

)
GO

CREATE TABLE Images
(
  ImagesID INT PRIMARY KEY IDENTITY,
  VisitsID INT FOREIGN KEY REFERENCES Visits(VisitsID),
  PatinentID INT FOREIGN KEY REFERENCES patients(PatinentID),
  IamgeType NVARCHAR(50),
  ImageData NVARCHAR(200),
  ImageDate DATETIME

)
GO
 ALTER TABLE Images
 ALTER COLUMN ImageData NVARCHAR(300)


CREATE TABLE ImageingComment
(
  ImageingCommentID INT PRIMARY KEY IDENTITY,
  ImagesID INT FOREIGN KEY REFERENCES Images(ImagesID),
  CommentText NVARCHAR(200),
  CommentDate DATETIME

)
GO

CREATE TABLE VisitSchedule
(
  VisitScheduleID INT PRIMARY KEY IDENTITY,
  DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),
  DepartmentID int FOREIGN KEY REFERENCES Department(DepartmentID),
  DayofWeek NVARCHAR(50),
  StartTime TIME,
  EndTime TIME

)
GO

CREATE TABLE MedicineManufactures
(
	MedicineManufacturesID INT PRIMARY KEY IDENTITY,
	facturesName NVARCHAR(30),
  Addres NVARCHAR(150),
  PhoneNumber NVARCHAR(20),
  Email NVARCHAR(40)

)
GO

CREATE TABLE MedicineDeatails
(
	MedicineDeatailsID INT PRIMARY KEY IDENTITY,
	MedicineName NVARCHAR(50),
  MedicineManufacturesID INT FOREIGN KEY REFERENCES MedicineManufactures(MedicineManufacturesID),
  Formulation NVARCHAR(200),
  UnitPrice DECIMAL(18,2),
  StockQuantity INT
)
GO

CREATE TABLE MedicineincomeInvices
(
  MedicineincomeInvicesID INT PRIMARY KEY IDENTITY,
	ReciveDate DATETIME,
  UnitPrice DECIMAL(18,2),
  StockQuantity INT,
  TotalAmount DECIMAL(18,2),
  MedicineManufacturesID INT FOREIGN KEY REFERENCES MedicineManufactures(MedicineManufacturesID),

)
GO

ALTER TABLE Inovices
ADD Quntity INT
go



CREATE TABLE InovicesPurchase
(
  InovicesPurchaseID INT PRIMARY KEY IDENTITY,
  MedicinesName NVARCHAR(40),
  Type NVARCHAR(30),
  InovicesDate DATETIME,
  Quntity INT,
  UnitPrice DECIMAL (18,2),
  TotalAmount DECIMAL (18,2),
  MedicineManufacturesID INT FOREIGN KEY REFERENCES MedicineManufactures(MedicineManufacturesID)

)
GO
