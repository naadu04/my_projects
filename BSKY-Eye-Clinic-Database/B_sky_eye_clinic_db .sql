-- CREATE DATABASE
CREATE DATABASE IF NOT EXISTS bsky_eye_clinic;
USE `bsky_eye_clinic`;

-- CREATE TABLE
CREATE TABLE offices (
    office_id INT AUTO_INCREMENT PRIMARY KEY,
    room_name VARCHAR(100) NOT NULL,
    floor_number INT DEFAULT 1,
    notes TEXT
);


-- DEPARTMENTS- 'teams'
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL, 
    department_head INT,
    description TEXT
);

-- linking department heads after tables exists
    ALTER TABLE departments
    ADD CONSTRAINT fk_head
    FOREIGN KEY (department_head) REFERENCES staff(staff_id);
    
-- STAFF "who works there"
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role ENUM('Doctor','Nurse','Technician','Admin','Support') NOT NULL,
    specialty VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    availability ENUM('Available','Unavailable') DEFAULT 'Available',
    office_id INT,
    department_id INT,
    FOREIGN KEY (office_id) REFERENCES offices(office_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);


-- services 'wall menue'
CREATE TABLE services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(255) NOT NULL,
    service_description TEXT,
    price DECIMAL(10,2) NOT NULL DEFAULT 0.00
);


-- paitents 'people to be treated'
CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    date_of_birth DATE,
    gender ENUM('Male','Female','Other'),
    email VARCHAR(255),
    phone VARCHAR(20),
    emergency_contact  VARCHAR(20),
    address TEXT,
    allergies TEXT,
    insurance_no VARCHAR(100)
);


-- appointment 'sloting people in'
CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    staff_id INT,
    service_id INT,
    office_id INT,
    appointment_date DATE,
    appointment_time TIME,
    status ENUM('Scheduled','Completed','Cancelled','No-Show') DEFAULT 'Scheduled',
    notes TEXT,
FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
FOREIGN KEY (service_id) REFERENCES services(service_id),
FOREIGN KEY (office_id) REFERENCES offices(office_id)
);


-- treatmement history
CREATE TABLE treatment_history (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    patient_id INT NOT NULL,
    diagnosis TEXT,
    treatment_date DATE,
    notes TEXT,
  FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id),
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);


-- prescriptions 
CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    treatment_id INT,
    medication VARCHAR(255),
    dosage VARCHAR(255),
    issue_date DATE,
    instructions TEXT,
 FOREIGN KEY (treatment_id) REFERENCES treatment_history(treatment_id)
);


-- payers
CREATE TABLE payers (
   payer_id INT AUTO_INCREMENT PRIMARY KEY,
   payer_type ENUM('Patient','Insurance','Other') NOT NULL,
   payer_name VARCHAR(255),
   payer_details TEXT
);

-- invoices 'tab'
CREATE TABLE invoices (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    payer_id INT,
    invoice_date DATE,
    due_date DATE,
    invoice_status ENUM('Paid','Pending','Overdue') DEFAULT 'Pending',
    total_amount DECIMAL(10,2) DEFAULT 0.00,
    balance_due DECIMAL(10,2) DEFAULT 0.00,
    notes TEXT,
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
  FOREIGN KEY (payer_id)   REFERENCES payers(payer_id)
);


-- invoice_lines 
CREATE TABLE invoice_lines (
    line_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT,
    service_id INT,
    quantity INT DEFAULT 1,
    unit_price DECIMAL(10,2),
    line_total DECIMAL(10,2),
FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id),
FOREIGN KEY (service_id) REFERENCES services(service_id)
);


-- payments 
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT,
    payment_method ENUM('Cash','Card','Insurance','Bank Transfer'),
    payment_date DATE,
    amount DECIMAL(10,2),
    payment_status ENUM('Completed','Pending','Failed') DEFAULT 'Completed',
 FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id)
);


-- feedback
CREATE TABLE feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    feedback_date DATE,
    comments TEXT,
FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);


-- inventory
CREATE TABLE inventory (
  item_id          INT AUTO_INCREMENT PRIMARY KEY,
  item_name        VARCHAR(255),
  item_code        VARCHAR(100),
  department_id    INT,
  quantity_on_hand INT DEFAULT 0,
  reorder_level    INT DEFAULT 5,
FOREIGN KEY (department_id) REFERENCES departments(department_id)
);




-- inserting data into tables

INSERT INTO offices 
(room_name, floor_number, notes) VALUES
('General Consultation Room', 1, 'Walk-ins allowed'),
('Eye Testing Room', 2, 'Equipped with autorefractor'),
('Surgery & Treatment Room', 2, 'Sterile precautions'),
('Reception & Record Desk', 1, 'Front desk operations');

INSERT INTO departments 
(department_name, department_head, description) VALUES
('Ophthalmology', NULL, 'Handles full eye examinations and vision care'),
('Optometry', NULL, 'Lens, prescriptions, refraction tests'),
('Surgery', NULL, 'Eye-related surgical procedures'),
('Administration', NULL, 'Clinic management, bookings & finance');

INSERT INTO staff 
(first_name, last_name, role, specialty, email, availability, office_id, department_id) VALUES
('Ama','Mensah','Doctor','Cataract & Glaucoma','ama.mensah@bsky.com','Available',1,1),
('Kwesi','Boateng','Nurse','Post-surgery care','kwesi.boateng@bsky.com','Available',3,3),
('Linda','Owusu','Technician','Eye Equipment Handling','linda.owusu@bsky.com','Available',2,2),
('Daniel','Ofori','Admin','Front Desk & Billing','daniel.ofori@bsky.com','Available',4,4);

INSERT INTO services 
(service_name, service_description, price) VALUES
('General Eye Examination','Vision testing & diagnosis',150.00),
('Lens Prescription','Refraction test + prescription slip',90.00),
('Cataract Surgery','Complete cataract removal procedure',5000.00),
('Eyeglass Fitting','Lens + frame fitting and adjustments',180.00);

INSERT INTO patients 
(first_name,last_name,date_of_birth,gender,email,phone,emergency_contact,address,allergies,insurance_no) VALUES
('Kojo','Appiah','1988-04-10','Male','kojo.appiah@example.com','0245002001','0249003300','Accra, Ghana','None','INS-001'),
('Abena','Sarpong','1995-11-21','Female','abena.sarpong@example.com','0556001222','0573003445','Tema, Ghana','Penicillin','INS-074');

INSERT INTO appointments
 (patient_id, staff_id, service_id, office_id, appointment_date, appointment_time, status, notes) VALUES
(1,1,1,1,'2025-01-15','10:00:00','Scheduled','Routine check-up'),
(2,3,2,2,'2025-01-16','13:30:00','Completed','Prescription review');

INSERT INTO treatment_history
(appointment_id, patient_id, diagnosis, treatment_date, notes) VALUES
(1,1,'Myopia detected','2025-01-15','Recommended prescription lenses'),
(2,2,'Mild dry eyes','2025-01-16','Lubrication eyedrops issued');

INSERT INTO prescriptions 
(treatment_id, medication, dosage, issue_date, instructions) VALUES
(1,'Prescription Glasses','Use daily as needed','2025-01-15','Wear for reading and screen use'),
(2,'Refresh Eye Drops','2 drops, twice daily','2025-01-16','Avoid dust exposure');

INSERT INTO payers 
(payer_type, payer_name, payer_details) VALUES
('Patient','Kojo Appiah','Self-funded cash payments'),
('Insurance','Metropolitan Health','Insurance coverage up to 60%');

INSERT INTO invoices 
(patient_id, payer_id, invoice_date, due_date, invoice_status, total_amount, balance_due, notes) VALUES
(1,1,'2025-01-15','2025-01-20','Pending',150.00,150.00,'Consultation only'),
(2,2,'2025-01-16','2025-01-25','Pending',90.00,36.00,'Insurance covers 60%');

INSERT INTO invoice_lines 
(invoice_id, service_id, quantity, unit_price, line_total) VALUES
(1,1,1,150.00,150.00),
(2,2,1,90.00,90.00);

INSERT INTO payments 
(invoice_id, payment_method, payment_date, amount, payment_status) VALUES
(1,'Cash','2025-01-15',150.00,'Completed'),
(2,'Insurance','2025-01-17',54.00,'Completed');

INSERT INTO feedback 
(appointment_id,rating,feedback_date,comments) VALUES
(1,5,'2025-01-15','Doctor was patient and helpful'),
(2,4,'2025-01-16','Quick service, satisfied');

INSERT INTO inventory 
(item_name,item_code,department_id,quantity_on_hand,reorder_level) VALUES
('Eye Drops','MED-E01',2,40,10),
('Lens Frames','LNS-F10',2,25,5),
('Sterile Surgical Kits','SRG-K20',3,10,3);

