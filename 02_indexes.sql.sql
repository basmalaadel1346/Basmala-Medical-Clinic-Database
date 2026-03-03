USE MedicalClinic;
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
