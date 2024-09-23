-- view for Appointments Deatails
CREATE OR ALTER VIEW Vw_AppointmentsDeatails
AS
SELECT a.AppointmentID,
a.AppointmentDATETIME,
p.FirstName+' '+p.LastName AS patientsName,
p.NationalCode,
p.gender,
d.FirstName+' '+d.LastName AS DoctorName,
d.Expertise,
d1.DepartmentName
 FROM Appointment a
  INNER JOIN patients p ON a.PatinentID = p.PatinentID
  INNER JOIN Doctors d ON a.DoctorID = d.DoctorID
  INNER JOIN Department d1 ON d.DoctorID = d1.DoctorID

----------------------------------------------------------------------------------------------------------------
-- view for Financial Transaction
CREATE OR ALTER VIEW Vw_FinancialVisits
AS
  SELECT 
  v.VisitsDate,
  v.Diagnosis,
  v.Prescription,
  p.FirstName+' '+p.LastName AS patientsName,
  d.FirstName+' '+d.LastName AS DoctorName,
  ft.TransactionType,
  ft.Amount,
  ft.TransactionDate
  FROM Visits v
  INNER JOIN patients p ON v.PatinentID = p.PatinentID
  INNER JOIN Doctors d ON v.DoctorID = d.DoctorID
  INNER JOIN FinancialTransaction ft ON v.VisitsID = ft.VisitsID
  -------------------------------------------------------------------
  -- view for Invoice Payment
  CREATE OR ALTER VIEW Vw_InvoicePayment
AS
  SELECT i.PatinentID,
  p1.FirstName,
  p1.LastName,
  p1.NationalCode,
  i.InovicesDate,
  i.TotalAmount,
  i.ISpaid,
  p.PaymantDate,
  p.Amount
  FROM Inovices i
  LEFT JOIN Payments p ON i.InovicesID = p.InovicesID
  LEFT JOIN patients p1 ON i.PatinentID = p1.PatinentID
  GO
  ----------------------------------------------------------------------
  --view for patiens info
CREATE OR ALTER VIEW Vw_PatinentInfo
AS
SELECT p.PatinentID,p.FirstName,p.LastName,p.NationalCode,p.BirthDate,p.gender,p.Phone FROM patients p
GO
------------------------------------------------------------------------
--view for doctors info
CREATE OR ALTER VIEW Vw_DoctorsInfo
AS
SELECT d.DoctorID,d.FirstName,d.LastName,d.Expertise, d.Phone, d.Email, d.HireDate FROM Doctors d
GO
-----------------------------------------------------------------
--view for visits info
CREATE OR ALTER VIEW Vw_Visits
AS
SELECT v.VisitsID,
v.PatinentID,
p.FirstName+' '+p.LastName AS patinentName,
 v.DoctorID,
 d.FirstName+' '+d.LastName AS DoctorName,
 v.VisitsDate, v.Diagnosis, v.Prescription,d1.DepartmentName FROM Visits v
INNER JOIN patients p ON v.PatinentID = p.PatinentID
INNER JOIN Doctors d ON v.DoctorID = d.DoctorID
INNER JOIN Department d1 ON d.DoctorID = d1.DoctorID
GO
------------------------------------------------------------
--view for patiens visits
CREATE OR ALTER VIEW Vw_GetLastVisits
AS
SELECT p.FirstName,p.LastName,p.NationalCode,
count(v.VisitsID) AS NumberOfVisits,
max(v.VisitsDate) AS LastVisitDate
FROM Visits v
INNER JOIN patients p ON v.PatinentID = p.PatinentID
GROUP BY p.FirstName,
         p.LastName,
         p.NationalCode
GO
---------------------------------------------------------------
--view for patiens payment and tax
CREATE OR ALTER VIEW Vw_PatiensTotalPayment
AS
SELECT p.PatinentID
      ,p.FirstName
      ,p.LastName
      ,p.NationalCode
      ,sum(p1.Amount) AS TotalPayment
      ,sum(ti.TaxAmount) AS TotalTax
      
FROM patients p
INNER JOIN Payments p1 ON p.PatinentID = p1.PatinentID
INNER JOIN Inovices i ON p.PatinentID = i.PatinentID
INNER JOIN TaxInvoices ti ON i.InovicesID = ti.InvoicesID
GROUP BY p.PatinentID
        ,p.FirstName
        ,p.LastName
        ,p.NationalCode
go
-----------------------------------------------------------------
--view for hospital staff
CREATE OR ALTER VIEW Vw_DepartmentStaff
AS
  SELECT d.DepartmentName ,
  count(s.StaffID) AS NumberOFstaff
  FROM Department d
  INNER JOIN Staff s ON d.DepartmentID = s.DepartmentID
  GROUP BY d.DepartmentName
  GO
  ----------------------------------------------------------------
--view for department incom
CREATE OR ALTER VIEW Vw_DepartmentIncom
AS
SELECT d.DepartmentName,
sum(i.TotalAmount) AS TotalIncom
FROM Department d
INNER JOIN Visits v ON d.DepartmentID = v.DepartmentID
INNER JOIN Inovices i ON v.PatinentID = i.PatinentID
WHERE i.ISpaid = 0
GROUP BY d.DepartmentName
GO
  ----------------------------------------------------------------
--view for medicine expire
ALTER TABLE MedicineincomeInvices ADD expirationDate DATETIME
ALTER TABLE MedicineincomeInvices ADD MedicineID INT FOREIGN KEY REFERENCES Medicines(MedicinesID)
--------------------------------------------------------------------
--view for medicine expire less than 3 month
CREATE OR ALTER VIEW Vw_medicineexpirationDate
AS  
  SELECT m.MedicinesID
        ,m.MedicinesName
        ,m.Manufacture
        ,m.UnitePrice
        ,mi.expirationDate
  FROM  Medicines m
INNER JOIN MedicineincomeInvices mi ON m.MedicinesID = mi.MedicineID
WHERE mi.expirationDate <= DATEADD(MONTH,3,GETDATE())
GO
--------------------------------------------------------------------
--view for medicine doctor visits
CREATE OR ALTER VIEW Vw_patientsVisits
AS
SELECT 
       d.FirstName
      ,d.LastName
      ,count(v.VisitsID) AS patientsVisits
FROM Doctors d
INNER JOIN Visits v ON d.DoctorID = v.DoctorID
WHERE MONTH(v.VisitsDate)= MONTH(GETDATE()) AND year(v.VisitsDate)=YEAR(GETDATE()) --get visits count for this month
GROUP BY d.FirstName
        ,d.LastName
GO
--------------------------------------------------------------------
ALTER TABLE Medicines
ADD MedicineManufacturesID INT FOREIGN KEY REFERENCES MedicineManufactures(MedicineManufacturesID)



--------------------------------------------------------------------

--view for medicine factory
CREATE OR ALTER VIEW Vw_MedicineManufacture
AS
SELECT m.MedicinesID
      ,m.MedicinesName
      ,m.UnitePrice
      ,mm.facturesName
      
FROM Medicines m
INNER JOIN MedicineManufactures mm ON m.MedicineManufacturesID = mm.MedicineManufacturesID
WHERE m.Deleted=0
GO
--------------------------------------------------------------------
--view for staffs Experience
CREATE OR ALTER VIEW Vw_SttafExperience
AS
SELECT s.StaffID
      ,s.FirstName
      ,s.LastName
      ,d.DepartmentName
      ,DATEDIFF(YEAR,s.HireDate,GETDATE())AS yearsOFwork
FROM Staff s
INNER JOIN Department d ON s.DepartmentID = d.DepartmentID
WHERE DATEDIFF(YEAR,s.HireDate,GETDATE())>1
--------------------------------------------------------------------

--view for Emergency Patients
CREATE OR ALTER VIEW Vw_EmergencyPatients
AS
SELECT p.PatinentID
      ,p.FirstName
      ,p.LastName
      ,p.NationalCode
      ,p.gender
      ,p.Phone
      ,v.VisitsDate
      

FROM patients p
INNER JOIN Visits v ON p.PatinentID = v.PatinentID
LEFT JOIN Department d ON v.DepartmentID = d.DepartmentID
INNER JOIN PatinentFeedback pf ON p.PatinentID = pf.PatinentID
WHERE d.DepartmentName='emergency' AND pf.FeedbackText IS NOT NULL
go
--------------------------------------------------------------------
--view for invoices tax 
CREATE OR ALTER VIEW Vw_TaxinviceDeatail
AS
SELECT ti.TaxInvoicesID
      ,ti.TaxAmount
      ,ti.TaxRate
      ,i.InovicesID
      ,i.TotalAmount
      ,pt.PaymentDate
      ,pt.Amount
FROM TaxInvoices ti
INNER JOIN Inovices i ON ti.InvoicesID = i.InovicesID
LEFT JOIN PaidTaxes pt ON ti.TaxInvoicesID = pt.TaxInvoicesID
WHERE i.ISpaid = 0
GO
---------------------------------------------------------------------
--view for medicine incomingdeatails
CREATE OR ALTER VIEW Vw_MedicineIncomingDeatails
AS
SELECT mi.MedicineincomeInvicesID
      ,m.MedicinesName
      ,mi.UnitPrice
      ,mi.StockQuantity
      ,mi.ReciveDate
      ,mi.expirationDate
      ,ip.InovicesDate
      ,ip.Type
FROM MedicineincomeInvices mi
INNER JOIN Medicines m ON mi.MedicineID = m.MedicinesID
INNER JOIN InovicesPurchase ip ON mi.MedicineManufacturesID = ip.MedicineManufacturesID 
go
---------------------------------------------------------------------
