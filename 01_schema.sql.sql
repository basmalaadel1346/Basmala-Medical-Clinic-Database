USE MedicalClinic;
GO


CREATE TABLE dbo.Persons (
PersonID INT IDENTITY(1,1) PRIMARY KEY,
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
DateOfBirth DATE NOT NULL,
PhoneNumber VARCHAR(20),
Email VARCHAR(100) UNIQUE
);
GO

CREATE TABLE dbo.Doctors (
DoctorID INT IDENTITY(1,1) PRIMARY KEY,
PersonID INT NOT NULL UNIQUE,
Specialty NVARCHAR(100) NOT NULL,
CONSTRAINT FK_Doctors_Persons FOREIGN KEY (PersonID) REFERENCES dbo.Persons(PersonID) ON DELETE CASCADE
);
GO


CREATE TABLE dbo.Patients (
PatientID INT IDENTITY(1,1) PRIMARY KEY,
PersonID INT NOT NULL UNIQUE,
CONSTRAINT FK_Patients_Persons FOREIGN KEY (PersonID) REFERENCES dbo.Persons(PersonID) ON DELETE CASCADE
);
GO


CREATE TABLE dbo.Appointments (
AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
DoctorID INT NOT NULL,
PatientID INT NOT NULL,
AppointmentDate DATETIME NOT NULL,
Reason NVARCHAR(255),
AppointmentStatus NVARCHAR(50) DEFAULT 'Pending',
CONSTRAINT CHK_AppointmentStatus CHECK (AppointmentStatus IN ('Pending', 'Confirmed', 'Completed', 'Cancelled', 'No Show')),
CONSTRAINT FK_Appointments_Doctors FOREIGN KEY (DoctorID) REFERENCES dbo.Doctors(DoctorID),
CONSTRAINT FK_Appointments_Patients FOREIGN KEY (PatientID) REFERENCES dbo.Patients(PatientID)
);
GO


CREATE TABLE dbo.MedicalRecords (
RecordID INT IDENTITY(1,1) PRIMARY KEY,
AppointmentID INT NOT NULL UNIQUE,
VisitDate DATETIME DEFAULT GETDATE(),
Diagnosis NVARCHAR(MAX) NOT NULL,
Treatment NVARCHAR(MAX),
CONSTRAINT FK_MedicalRecords_Appointments FOREIGN KEY (AppointmentID) REFERENCES dbo.Appointments(AppointmentID)
);
GO


CREATE TABLE dbo.Prescriptions (
PrescriptionID INT IDENTITY(1,1) PRIMARY KEY,
RecordID INT NOT NULL,
Medication NVARCHAR(100) NOT NULL,
Dosage NVARCHAR(50),
Frequency NVARCHAR(50),
CONSTRAINT FK_Prescriptions_MedicalRecords FOREIGN KEY (RecordID) REFERENCES dbo.MedicalRecords(RecordID) ON DELETE CASCADE
);
GO


CREATE TABLE dbo.Payments (
PaymentID INT IDENTITY(1,1) PRIMARY KEY,
AppointmentID INT NOT NULL UNIQUE,
Amount DECIMAL(10, 2) NOT NULL,
PaymentDate DATETIME DEFAULT GETDATE(),
Method NVARCHAR(50) NOT NULL,
CONSTRAINT FK_Payments_Appointments FOREIGN KEY (AppointmentID) REFERENCES dbo.Appointments(AppointmentID)
);
GO