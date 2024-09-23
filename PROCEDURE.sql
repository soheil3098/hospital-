-- PROCEDURE for payment
CREATE OR ALTER PROCEDURE PRC_PayInvoice
@InovicesID int,
@Amount DECIMAL(18,2),
@PATINENTID int
AS
BEGIN
	UPDATE Inovices SET ISpaid =1
  WHERE InovicesID=@InovicesID--update ispaid


  INSERT INTO Payments(PatinentID, InovicesID, PaymantDate, Amount)
  VALUES(@PATINENTID,@InovicesID,GETDATE(),@Amount)
  --insert payment details to payment table

END
----------------------------------------------------------------------------
--PROCEDURE for images reports
CREATE OR ALTER PROCEDURE PRC_AddImage
@PATINENTID int,
@VisitsID int,
@IamgeType NVARCHAR(40),
@ImageData VARBINARY(max),
@ImageDate DATETIME
AS
BEGIN
	 INSERT INTO Images(PatinentID, VisitsID, IamgeType, ImageData,ImageDate)
   VALUES(@PATINENTID,@VisitsID,@IamgeType,@ImageData,GETDATE())
   --add image report to image table
END
----------------------------------------------------------------------------
--PROCEDURE for invoice tax
CREATE OR ALTER PROCEDURE PRC_calculateTaxforInvoice
@InovicesID INT
AS
BEGIN
	  
    DECLARE @TotalAmount DECIMAL(18,2)
    DECLARE @Taxrate DECIMAL(18,2)
    DECLARE @TaxAmount DECIMAL(18,2)
    SELECT @TotalAmount= i.TotalAmount
    FROM Inovices i
    WHERE i.InovicesID=@InovicesID --get total amount from invoice table

    SET @Taxrate=0.1
    SET @taxAmount=@Taxrate*@TotalAmount --calculat tax amount

    INSERT INTO TaxInvoices (InvoicesID, TaxAmount, TaxRate)
     VALUES (@InovicesID, @taxAmount, @Taxrate);

END
----------------------------------------------------------------------------
--PROCEDURE for sell medicine
CREATE OR ALTER PROCEDURE PRC_Sellmedicine
@PATINENTID int,
@MedicinesID int,
@quantity int
AS
BEGIN
	    DECLARE @UnitPrice DECIMAL(18,2)
      DECLARE @TotalAmount DECIMAL(18,2)

      SELECT @UnitPrice=m.UnitePrice 
      FROM Medicines m
      WHERE m.MedicinesID=@MedicinesID


      SET @TotalAmount =@UnitPrice*@quantity


      INSERT INTO MedicinesOutgoingInvoice (PatinentID, IssueDate, TotalAmount)
                  VALUES (@PATINENTID, GETDATE(), @TotalAmount);


      INSERT INTO MedicinesOutgoingInvoiceDetails (InvoiceID, MedicinesID, Quantity, TotalAmount)
                  VALUES (SCOPE_IDENTITY(), @MedicinesID, @quantity, @TotalAmount);


      UPDATE Medicines SET Stockquantity = Stockquantity-@quantity
      WHERE MedicinesID = @MedicinesID;

END
----------------------------------------------------------------------------
CREATE OR ALTER PROC PRC_GetPatientsAppointmetsDetails
@PatientsID INT , 
@StartDate  DATETIME , 
@EndDate DATETIME , 
@ISComplete BIT
AS
	BEGIN
    	SELECT 
		p.FirstName + ' ' + p.LastName AS PatientsName , 
		a.AppointmetsDateTime, 
		a.IsCompleted , 
		p1.PaymentDate , 
		v.VisitDate
		FROM Appointmets a
		INNER JOIN Patients p ON a.PatientsID = p.PatientsID
		LEFT JOIN Payments p1 ON p.PatientsID = p1.PatientsID
		LEFT JOIN Visits v ON p.PatientsID = v.PatientsID
		WHERE a.PatientsID = @PatientsID AND a.AppointmetsDateTime BETWEEN @StartDate AND @EndDate AND a.IsCompleted = @ISComplete
    END
----------------------------------------------------------------------------
--prc for FindPatiensWithMostVisit
CREATE OR ALTER PROC PRC_FindPatiensWithMostVisit
@Top INT = 10
AS
	BEGIN
    	WITH PatiensVisitCount AS 
        (
        	SELECT  FirstName + ' ' +  LastName AS PatiensName , 
			COUNT(v.VisitsID) AS VisitCount
        	FROM patients p    
			INNER JOIN Visits v ON p.PatinentID = v.PatinentID
			GROUP BY FirstName , LastName
        )
        SELECT TOP (@Top) PatiensName ,  VisitCount
        FROM PatiensVisitCount
		ORDER BY VisitCount DESC
        
    END
    ----------------------------------------------------------------------------
CREATE OR ALTER PROC PRC_SearchPatients
@FirstName NVARCHAR(30) = NULL ,
@LastName NVARCHAR(30) = NULL , 
@NationalCode BIGINT = NULL , 
@Gender NVARCHAR(15) = NULL
AS
	BEGIN
    	SET NOCOUNT ON
		SELECT p.PatinentID, p.FirstName, p.LastName, p.NationalCode, p.BirthDate, p.Gender, p.PatinentID, p.Addres FROM patients p
		WHERE (p.FirstName LIKE '%' + @FirstName + '%')
		AND (p.LastName LIKE '%' + @LastName + '%')
		AND(p.NationalCode = @NationalCode)
		AND(p.Gender = @Gender)
    END

----------------------------------------------------------------------------
CREATE OR ALTER PROC PRC_GetVisitCountByDay
@StartDate DATE , 
@EndDate DATE
AS
	BEGIN
    	SELECT 
		DATENAME(WEEKDAY ,AppointmetsDateTime )AS DayOfWeek, 
		COUNT(AppointmetID) AS VisitCount
		FROM Appointmets a
		WHERE a.AppointmetsDateTime BETWEEN @StartDate AND @EndDate
		GROUP BY DATENAME(WEEKDAY ,AppointmetsDateTime )
		ORDER BY VisitCount DESC
    END
----------------------------------------------------------------------------
CREATE OR ALTER PROC PRC_ReportIncomeExpense
@StartDate DATETIME, 
@EndDate DATETIME
AS
	BEGIN
    	SELECT(SELECT SUM(ft.Amount) FROM FinaicialTranstions ft WHERE ft.TranstionDate BETWEEN @StartDate AND @EndDate
		AND ft.TranstionType = 'Income') as TotalIncome , 
		(SELECT SUM(ft.Amount) FROM FinaicialTranstions ft WHERE ft.TranstionDate BETWEEN @StartDate AND @EndDate
		AND ft.TranstionType = 'Expense') as TotalExpense 
    END
----------------------------------------------------------------------------
CREATE OR ALTER PROC PRC_ReportMedicinesUsage
AS
	BEGIN
    	SELECT m.MedicineName , 
		COUNT(moid.MedicineID) AS UsageCount
		FROM Medicines m
		INNER JOIN MedicineOutgoingInvoiceDetails moid 
		ON m.MedicineID = moid.MedicineID
		GROUP BY m.MedicineName
    END
----------------------------------------------------------------------------
CREATE OR ALTER PROC PRC_MedicineExpairation
AS
	BEGIN
    	SELECT 
		mii.MedicineID, 
		m.MedicineName,
		mii.Expairationdate
		FROM MedicineIncomingInovices mii
		INNER JOIN Medicines m ON mii.MedicineID = m.MedicineID
		WHERE Expairationdate <= DATEADD(MONTH , 1 , GETDATE())
    END
GO
----------------------------------------------------------------------------
CREATE OR ALTER PROC PRC_DoctorByDepartment
@DepartmentID INT 
AS
	BEGIN
    	SELECT 
		d.DoctorID,
		d.FirstName, 
		d.LastName,
		d.Specialiization  ,
		d1.DepartmentName
		FROM Doctors d
		INNER JOIN Departments d1 ON d.DoctorID = d1.DoctorID
		WHERE d1.DepartmentID = @DepartmentID
    END
----------------------------------------------------------------------------
CREATE OR ALTER PROC PRC_GetPaidInovicesPatients
@PatientsID INT
AS
	BEGIN
    	SELECT i.InovicesID, i.PatinentID, i.InovicesDate, i.TotalAmount , p.PaymantDate FROM Inovices i
		INNER JOIN Payments p ON i.InovicesID = p.InovicesID
		WHERE i.PatinentID = @PatientsID AND i.IsPaid =1
    END
GO
----------------------------------------------------------------------------
CREATE OR ALTER PROC PRC_GetTestResultByDoctor
@DoctorID INT
AS	
	BEGIN
    	SELECT tr.TestID, tr.PatinentID, tr.ResultDetails FROM TestResult tr
		WHERE tr.DoctorID = @DoctorID
    END








