/* =====================================================================
   Web-Based E-Channeling System - MS SQL Server Schema
   Run this whole script in SQL Server Management Studio (SSMS) or
   Azure Data Studio BEFORE starting the Spring Boot application.
   ===================================================================== */

IF DB_ID('EChannelDB') IS NULL
BEGIN
    CREATE DATABASE EChannelDB;
END
GO

USE EChannelDB;
GO

-- ========================= 1. USERS ========================= --
-- Every login (patient, doctor, reception, pharmacist, ops manager, admin) is a row here.
-- Drop child tables first to avoid Foreign Key constraint errors
IF OBJECT_ID('dbo.notifications', 'U') IS NOT NULL DROP TABLE dbo.notifications;
IF OBJECT_ID('dbo.feedback', 'U') IS NOT NULL DROP TABLE dbo.feedback;
IF OBJECT_ID('dbo.prescriptions', 'U') IS NOT NULL DROP TABLE dbo.prescriptions;
IF OBJECT_ID('dbo.health_records', 'U') IS NOT NULL DROP TABLE dbo.health_records;
IF OBJECT_ID('dbo.appointments', 'U') IS NOT NULL DROP TABLE dbo.appointments;
IF OBJECT_ID('dbo.patients', 'U') IS NOT NULL DROP TABLE dbo.patients;
IF OBJECT_ID('dbo.doctor_schedule', 'U') IS NOT NULL DROP TABLE dbo.doctor_schedule;
IF OBJECT_ID('dbo.doctors', 'U') IS NOT NULL DROP TABLE dbo.doctors;
IF OBJECT_ID('dbo.rooms', 'U') IS NOT NULL DROP TABLE dbo.rooms;
IF OBJECT_ID('dbo.branches', 'U') IS NOT NULL DROP TABLE dbo.branches;

-- Now drop the parent users table
IF OBJECT_ID('dbo.users', 'U') IS NOT NULL DROP TABLE dbo.users;

CREATE TABLE users (
    user_id      INT IDENTITY(1,1) PRIMARY KEY,
    username     VARCHAR(50)  NOT NULL UNIQUE,
    password     VARCHAR(255) NOT NULL,          -- BCrypt hash
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(100) NULL,
    phone        VARCHAR(20)  NULL,
    role         VARCHAR(30)  NOT NULL            -- PATIENT, DOCTOR, RECEPTION, PHARMACIST, OPERATIONS_MANAGER, ADMIN
        CHECK (role IN ('PATIENT','DOCTOR','RECEPTION','PHARMACIST','OPERATIONS_MANAGER','ADMIN')),
    is_active    BIT NOT NULL DEFAULT 1,
    created_at   DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- ========================= 2. BRANCHES ========================= --
IF OBJECT_ID('dbo.branches', 'U') IS NOT NULL DROP TABLE dbo.branches;
CREATE TABLE branches (
    branch_id    INT IDENTITY(1,1) PRIMARY KEY,
    branch_name  VARCHAR(100) NOT NULL,
    address      VARCHAR(200) NULL,
    phone        VARCHAR(20)  NULL
);
GO

-- ========================= 3. ROOMS ========================= --
IF OBJECT_ID('dbo.rooms', 'U') IS NOT NULL DROP TABLE dbo.rooms;
CREATE TABLE rooms (
    room_id      INT IDENTITY(1,1) PRIMARY KEY,
    branch_id    INT NOT NULL FOREIGN KEY REFERENCES branches(branch_id),
    room_number  VARCHAR(20) NOT NULL,
    department   VARCHAR(50) NULL,
    status       VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE','INACTIVE')),
    CONSTRAINT uq_room_per_branch UNIQUE (branch_id, room_number)
);
GO

-- ========================= 4. DOCTORS ========================= --
IF OBJECT_ID('dbo.doctors', 'U') IS NOT NULL DROP TABLE dbo.doctors;
CREATE TABLE doctors (
    doctor_id    INT IDENTITY(1,1) PRIMARY KEY,
    user_id      INT NOT NULL UNIQUE FOREIGN KEY REFERENCES users(user_id),
    specialty    VARCHAR(100) NOT NULL,
    branch_id    INT NOT NULL FOREIGN KEY REFERENCES branches(branch_id)
);
GO

-- ========================= 5. DOCTOR SCHEDULE ========================= --
IF OBJECT_ID('dbo.doctor_schedule', 'U') IS NOT NULL DROP TABLE dbo.doctor_schedule;
CREATE TABLE doctor_schedule (
    schedule_id    INT IDENTITY(1,1) PRIMARY KEY,
    doctor_id      INT NOT NULL FOREIGN KEY REFERENCES doctors(doctor_id),
    room_id        INT NOT NULL FOREIGN KEY REFERENCES rooms(room_id),
    schedule_date  DATE NOT NULL,
    start_time     TIME NOT NULL,
    end_time       TIME NOT NULL,
    max_patients   INT NOT NULL DEFAULT 20,
    status         VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE' CHECK (status IN ('AVAILABLE','FULL','CANCELLED'))
);
GO

-- ========================= 6. PATIENTS ========================= --
IF OBJECT_ID('dbo.patients', 'U') IS NOT NULL DROP TABLE dbo.patients;
CREATE TABLE patients (
    patient_id   INT IDENTITY(1,1) PRIMARY KEY,
    user_id      INT NULL UNIQUE FOREIGN KEY REFERENCES users(user_id),  -- NULL allowed for reception walk-in patients with no login
    nic          VARCHAR(20) NULL,
    dob          DATE NULL,
    address      VARCHAR(200) NULL
);
GO

-- ========================= 7. APPOINTMENTS ========================= --
IF OBJECT_ID('dbo.appointments', 'U') IS NOT NULL DROP TABLE dbo.appointments;
CREATE TABLE appointments (
    appointment_id  INT IDENTITY(1,1) PRIMARY KEY,
    patient_id      INT NOT NULL FOREIGN KEY REFERENCES patients(patient_id),
    schedule_id     INT NOT NULL FOREIGN KEY REFERENCES doctor_schedule(schedule_id),
    token_no        INT NOT NULL,
    status          VARCHAR(20) NOT NULL DEFAULT 'BOOKED' CHECK (status IN ('BOOKED','RESCHEDULED','CANCELLED','ATTENDED','NO_SHOW')),
    booked_at       DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- ========================= 8. HEALTH RECORDS ========================= --
IF OBJECT_ID('dbo.health_records', 'U') IS NOT NULL DROP TABLE dbo.health_records;
CREATE TABLE health_records (
    record_id       INT IDENTITY(1,1) PRIMARY KEY,
    patient_id      INT NOT NULL FOREIGN KEY REFERENCES patients(patient_id),
    doctor_id       INT NOT NULL FOREIGN KEY REFERENCES doctors(doctor_id),
    appointment_id  INT NULL FOREIGN KEY REFERENCES appointments(appointment_id),
    diagnosis       VARCHAR(MAX) NULL,
    treatment       VARCHAR(MAX) NULL,
    notes           VARCHAR(MAX) NULL,
    created_at      DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- ========================= 9. PRESCRIPTIONS ========================= --
IF OBJECT_ID('dbo.prescriptions', 'U') IS NOT NULL DROP TABLE dbo.prescriptions;
CREATE TABLE prescriptions (
    prescription_id  INT IDENTITY(1,1) PRIMARY KEY,
    health_record_id INT NULL FOREIGN KEY REFERENCES health_records(record_id),
    patient_id       INT NOT NULL FOREIGN KEY REFERENCES patients(patient_id),
    doctor_id        INT NOT NULL FOREIGN KEY REFERENCES doctors(doctor_id),
    medicines        VARCHAR(MAX) NOT NULL,
    status           VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING','FULFILLED')),
    issued_at        DATETIME NOT NULL DEFAULT GETDATE(),
    fulfilled_at     DATETIME NULL
);
GO

-- ========================= 10. FEEDBACK ========================= --
IF OBJECT_ID('dbo.feedback', 'U') IS NOT NULL DROP TABLE dbo.feedback;
CREATE TABLE feedback (
    feedback_id     INT IDENTITY(1,1) PRIMARY KEY,
    appointment_id  INT NOT NULL FOREIGN KEY REFERENCES appointments(appointment_id),
    patient_id      INT NOT NULL FOREIGN KEY REFERENCES patients(patient_id),
    doctor_id       INT NOT NULL FOREIGN KEY REFERENCES doctors(doctor_id),
    rating          INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review          VARCHAR(MAX) NULL,
    is_flagged      BIT NOT NULL DEFAULT 0,
    created_at      DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- ========================= 11. NOTIFICATIONS ========================= --
IF OBJECT_ID('dbo.notifications', 'U') IS NOT NULL DROP TABLE dbo.notifications;
CREATE TABLE notifications (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id         INT NOT NULL FOREIGN KEY REFERENCES users(user_id),
    message         VARCHAR(300) NOT NULL,
    is_read         BIT NOT NULL DEFAULT 0,
    created_at      DATETIME NOT NULL DEFAULT GETDATE()
);
GO

/* =====================================================================
   VIEW - used by Reception Staff "View Daily Appointment List"
   ===================================================================== */
IF OBJECT_ID('dbo.vw_daily_appointments', 'V') IS NOT NULL DROP VIEW dbo.vw_daily_appointments;
GO
CREATE VIEW dbo.vw_daily_appointments AS
SELECT
    a.appointment_id,
    a.token_no,
    a.status,
    ds.schedule_date,
    ds.start_time,
    ds.end_time,
    p.patient_id,
    up.full_name  AS patient_name,
    d.doctor_id,
    ud.full_name  AS doctor_name,
    d.specialty,
    r.room_number,
    b.branch_name
FROM appointments a
JOIN doctor_schedule ds ON a.schedule_id = ds.schedule_id
JOIN patients p         ON a.patient_id = p.patient_id
LEFT JOIN users up      ON p.user_id = up.user_id
JOIN doctors d          ON ds.doctor_id = d.doctor_id
JOIN users ud           ON d.user_id = ud.user_id
JOIN rooms r            ON ds.room_id = r.room_id
JOIN branches b         ON r.branch_id = b.branch_id;
GO

/* =====================================================================
   STORED PROCEDURE - dispensing a prescription (Pharmacist "confirm order fulfilment")
   Demonstrates calling a stored procedure from the Spring Boot app (see
   PrescriptionRepository.fulfil()) instead of a raw UPDATE statement.
   ===================================================================== */
IF OBJECT_ID('dbo.sp_fulfil_prescription', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_fulfil_prescription;
GO
CREATE PROCEDURE dbo.sp_fulfil_prescription
    @PrescriptionId INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE prescriptions
    SET status = 'FULFILLED', fulfilled_at = GETDATE()
    WHERE prescription_id = @PrescriptionId AND status = 'PENDING';
END
GO

/* =====================================================================
   TRIGGER - automatically notifies the patient once their prescription
   is fulfilled (supports the "In-App Notifications" minor function).
   ===================================================================== */
IF OBJECT_ID('dbo.trg_prescription_fulfilled', 'TR') IS NOT NULL DROP TRIGGER dbo.trg_prescription_fulfilled;
GO
CREATE TRIGGER dbo.trg_prescription_fulfilled
ON dbo.prescriptions
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO notifications (user_id, message)
    SELECT pt.user_id, 'Your prescription #' + CAST(i.prescription_id AS VARCHAR) + ' has been dispensed and is ready.'
    FROM inserted i
    JOIN deleted d ON i.prescription_id = d.prescription_id
    JOIN patients pt ON i.patient_id = pt.patient_id
    WHERE i.status = 'FULFILLED' AND d.status = 'PENDING' AND pt.user_id IS NOT NULL;
END
GO

/* =====================================================================
   SEED DATA - one branch, one room, one admin login, one sample doctor
   Password for every seeded account is: Passw0rd!   (BCrypt hash below)
   ===================================================================== */
INSERT INTO branches (branch_name, address, phone) VALUES
('SLIIT General Hospital - Malabe', '10 New Kandy Road, Malabe', '0112345678');

INSERT INTO rooms (branch_id, room_number, department) VALUES
(1, 'R101', 'General Consultation'),
(1, 'R102', 'Cardiology');

-- BCrypt hash of "Passw0rd!"
INSERT INTO users (username, password, full_name, email, phone, role) VALUES
('admin',   '$2a$10$7EqJtq98hPqEX7fNZaFWoOhi5vAyrJ0j1XwqK8bpCU8WM5XyUFqk2', 'System Administrator', 'admin@echannel.lk',   '0770000000', 'ADMIN'),
('drperera','$2a$10$7EqJtq98hPqEX7fNZaFWoOhi5vAyrJ0j1XwqK8bpCU8WM5XyUFqk2', 'Dr. Nimal Perera',      'perera@echannel.lk',  '0770000001', 'DOCTOR'),
('reception1','$2a$10$7EqJtq98hPqEX7fNZaFWoOhi5vAyrJ0j1XwqK8bpCU8WM5XyUFqk2','Reception Staff 1',    'reception@echannel.lk','0770000002','RECEPTION'),
('pharmacy1','$2a$10$7EqJtq98hPqEX7fNZaFWoOhi5vAyrJ0j1XwqK8bpCU8WM5XyUFqk2','Pharmacist 1',          'pharmacy@echannel.lk', '0770000003','PHARMACIST'),
('opsmgr1', '$2a$10$7EqJtq98hPqEX7fNZaFWoOhi5vAyrJ0j1XwqK8bpCU8WM5XyUFqk2', 'Operations Manager 1', 'ops@echannel.lk',      '0770000004','OPERATIONS_MANAGER'),
('patient1','$2a$10$7EqJtq98hPqEX7fNZaFWoOhi5vAyrJ0j1XwqK8bpCU8WM5XyUFqk2', 'Kasun Silva',           'kasun@example.com',    '0770000005','PATIENT');

INSERT INTO doctors (user_id, specialty, branch_id) VALUES
((SELECT user_id FROM users WHERE username='drperera'), 'Cardiology', 1);

INSERT INTO patients (user_id, nic, dob, address) VALUES
((SELECT user_id FROM users WHERE username='patient1'), '200012345678', '2000-05-12', 'No 5, Colombo');

INSERT INTO doctor_schedule (doctor_id, room_id, schedule_date, start_time, end_time, max_patients) VALUES
(1, 2, CAST(GETDATE() AS DATE), '09:00', '12:00', 20);

PRINT 'EChannelDB schema, view, procedure, trigger and seed data created successfully.';
GO

UPDATE Users SET password = 'admin' WHERE user_id = 1;
UPDATE Users SET password = 'Doctor' WHERE user_id = 2;
UPDATE Users SET password = 'Reception' WHERE user_id = 3;
UPDATE Users SET password = 'pharmacy' WHERE user_id = 4;
UPDATE Users SET password = 'op123' WHERE user_id = 5;
UPDATE Users SET password = 'patient' WHERE user_id = 6;

UPDATE Users SET username = 'admin' WHERE user_id = 1;
UPDATE Users SET username = 'Doctor' WHERE user_id = 2;
UPDATE Users SET username = 'Reception' WHERE user_id = 3;
UPDATE Users SET username = 'pharmacy' WHERE user_id = 4;
UPDATE Users SET username = 'opsmgr' WHERE user_id = 5;
UPDATE Users SET username = 'patient' WHERE user_id = 6;

SELECT * FROM EChannelDB.dbo.users