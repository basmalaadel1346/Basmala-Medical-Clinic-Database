USE MedicalClinic;
GO

BEGIN TRANSACTION;
BEGIN TRY

DECLARE @DoctorPersonID1 INT, @DoctorPersonID2 INT;
DECLARE @DoctorID1 INT, @DoctorID2 INT;

INSERT INTO dbo.Persons (FirstName, LastName, DateOfBirth, PhoneNumber, Email)
VALUES (N'محمد', N'عادل', '1992-05-07', '01000771984', 'mohammed.adel@gmail.com');
SET @DoctorPersonID1 = SCOPE_IDENTITY();

INSERT INTO dbo.Persons (FirstName, LastName, DateOfBirth, PhoneNumber, Email)
VALUES (N'آية', N'عادل', '2000-02-29', '01100771986', 'aya.adel@gmail.com');
SET @DoctorPersonID2 = SCOPE_IDENTITY();

INSERT INTO dbo.Doctors (Specialty, PersonID)
VALUES ('Cardiology', @DoctorPersonID1);
SET @DoctorID1 = SCOPE_IDENTITY();

INSERT INTO dbo.Doctors (Specialty, PersonID)
VALUES ('Neurology', @DoctorPersonID2);
SET @DoctorID2 = SCOPE_IDENTITY();

DECLARE @PatientPersonID1 INT, @PatientPersonID2 INT;
DECLARE @PatientID1 INT, @PatientID2 INT;

INSERT INTO dbo.Persons (FirstName, LastName, DateOfBirth, PhoneNumber, Email)
VALUES (N'بسملة', N'عادل', '2007-02-21', '01550771988', 'basmala.adel@gmail.com');
SET @PatientPersonID1 = SCOPE_IDENTITY();

INSERT INTO dbo.Persons (FirstName, LastName, DateOfBirth, PhoneNumber, Email)
VALUES (N'سارة', N'علي', '1995-12-15', '01200771981', 'sara.ali@gmail.com');
SET @PatientPersonID2 = SCOPE_IDENTITY();

INSERT INTO dbo.Patients (PersonID) VALUES (@PatientPersonID1);
SET @PatientID1 = SCOPE_IDENTITY();

INSERT INTO dbo.Patients (PersonID) VALUES (@PatientPersonID2);
SET @PatientID2 = SCOPE_IDENTITY();

DECLARE @ApptID1 INT, @ApptID2 INT, @ApptID3 INT;

INSERT INTO dbo.Appointments (DoctorID, PatientID, AppointmentDate, Reason, AppointmentStatus)
VALUES (@DoctorID1, @PatientID1, '2024-07-01 10:00:00', 'Regular Checkup', 'Pending');
SET @ApptID1 = SCOPE_IDENTITY();

INSERT INTO dbo.Appointments (DoctorID, PatientID, AppointmentDate, Reason, AppointmentStatus)
VALUES (@DoctorID2, @PatientID2, '2024-07-02 11:00:00', 'Headache', 'Confirmed');
SET @ApptID2 = SCOPE_IDENTITY();

INSERT INTO dbo.Appointments (DoctorID, PatientID, AppointmentDate, Reason, AppointmentStatus)
VALUES (@DoctorID1, @PatientID2, '2024-07-03 09:00:00', 'Follow-up', 'Pending');
SET @ApptID3 = SCOPE_IDENTITY();

DECLARE @RecordID1 INT, @RecordID2 INT;

INSERT INTO dbo.MedicalRecords (AppointmentID, VisitDate, Diagnosis, Treatment)
SELECT @ApptID1, AppointmentDate, 'General Checkup', 'All normal'
FROM dbo.Appointments WHERE AppointmentID = @ApptID1;
SET @RecordID1 = SCOPE_IDENTITY();

INSERT INTO dbo.MedicalRecords (AppointmentID, VisitDate, Diagnosis, Treatment)
SELECT @ApptID2, AppointmentDate, 'Headache', 'Painkillers'
FROM dbo.Appointments WHERE AppointmentID = @ApptID2;
SET @RecordID2 = SCOPE_IDENTITY();

INSERT INTO dbo.Prescriptions (RecordID, Medication, Dosage, Frequency)
VALUES
(@RecordID1, 'Vitamins', '100mg', 'Once daily'),
(@RecordID2, 'Ibuprofen', '200mg', 'Twice daily');

INSERT INTO dbo.Payments (AppointmentID, Amount, PaymentDate, Method)
VALUES
(@ApptID1, 100.00, GETDATE(), 'Cash'),
(@ApptID2, 150.00, GETDATE(), 'Credit Card');

COMMIT TRANSACTION;

END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
THROW;
END CATCH;

GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Appointments_DoctorID' AND object_id = OBJECT_ID('dbo.Appointments'))
BEGIN
CREATE NONCLUSTERED INDEX IX_Appointments_DoctorID ON dbo.Appointments (DoctorID);
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Appointments_PatientID' AND object_id = OBJECT_ID('dbo.Appointments'))
BEGIN
CREATE NONCLUSTERED INDEX IX_Appointments_PatientID ON dbo.Appointments (PatientID);
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Payments_AppointmentID' AND object_id = OBJECT_ID('dbo.Payments'))
BEGIN
CREATE NONCLUSTERED INDEX IX_Payments_AppointmentID ON dbo.Payments (AppointmentID);
END
GO

CREATE OR ALTER VIEW vw_AppointmentsDetails AS
SELECT
A.AppointmentID,
CONCAT(PatP.FirstName, ' ', PatP.LastName) AS PatientName,
CONCAT(DocP.FirstName, ' ', DocP.LastName) AS DoctorName,
A.AppointmentDate,
A.AppointmentStatus
FROM dbo.Appointments A
JOIN dbo.Patients Pat ON A.PatientID = Pat.PatientID
JOIN dbo.Persons PatP ON Pat.PersonID = PatP.PersonID
JOIN dbo.Doctors Doc ON A.DoctorID = Doc.DoctorID
JOIN dbo.Persons DocP ON Doc.PersonID = DocP.PersonID;
GO

SELECT * FROM vw_AppointmentsDetails;

SELECT Doc.DoctorID, CONCAT(P.FirstName,' ',P.LastName) AS DoctorName, COUNT(A.AppointmentID) AS TotalAppointments
FROM dbo.Doctors Doc
JOIN dbo.Persons P ON Doc.PersonID = P.PersonID
LEFT JOIN dbo.Appointments A ON Doc.DoctorID = A.DoctorID
GROUP BY Doc.DoctorID, P.FirstName, P.LastName;

SELECT Pat.PatientID, CONCAT(P.FirstName,' ',P.LastName) AS PatientName, ISNULL(SUM(Pay.Amount), 0) AS TotalPayments
FROM dbo.Patients Pat
JOIN dbo.Persons P ON Pat.PersonID = P.PersonID
LEFT JOIN dbo.Appointments A ON Pat.PatientID = A.PatientID
LEFT JOIN dbo.Payments Pay ON A.AppointmentID = Pay.AppointmentID
GROUP BY Pat.PatientID, P.FirstName, P.LastName;

