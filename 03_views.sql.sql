USE MedicalClinic;
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