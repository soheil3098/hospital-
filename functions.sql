CREATE OR ALTER FUNCTION dbo.Fn_GettotalTaxByMonth(@Month INT , @Year INT)
RETURNS DECIMAL(18,2)
AS
	BEGIN
		DECLARE @Amount DECIMAL(18,2)
    	SELECT @Amount = SUM(pt.Amount) FROM PaidTaxes pt
		WHERE YEAR(pt.PaymentDate )= @Year AND MONTH(pt.PaymentDate) = @Month
		RETURN @Amount
    END
-------------------------------------------------------------------------------
CREATE OR ALTER FUNCTION dbo.fn_GetAppointmetCount(@DoctorID INT)
RETURNS INT
AS
BEGIN
  DECLARE @Appointmet int
	SELECT @Appointmet= COUNT(*) 
  FROM Appointment a
  INNER JOIN Doctors d ON a.DoctorID = d.DoctorID
  WHERE a.DoctorID = @DoctorID
  RETURN @Appointmet
END
-------------------------------------------------------------------------------
CREATE OR ALTER FUNCTION dbo.fn_CalculatePatients(@PatientsID INT)
RETURNS DECIMAL(18,2)
AS
	BEGIN
		DECLARE @TotalAmount DECIMAL(18,2)
		DECLARE @Amount DECIMAL(18,2)

    	SELECT @TotalAmount = i.TotalAmount FROM Inovices i
		WHERE i.PatinentID = @PatientsID


		SELECT @Amount = p.Amount FROM Payments p
		WHERE p.PatinentID = @PatientsID

		RETURN (@TotalAmount - @Amount)--patients debt
    END
-------------------------------------------------------------------------------
CREATE OR ALTER FUNCTION dbo.Fn_GetPatientsAge(@PatientsID INT)
RETURNS INT
AS
	BEGIN
		DECLARE @DateOfBirth DATE
		DECLARE @Age INT
    	SELECT @DateOfBirth = p.BirthDate FROM patients p
		WHERE p.PatinentID = @PatientsID

		SET @Age = DATEDIFF(YEAR , @DateOfBirth , GETDATE())
		RETURN @Age
    END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------