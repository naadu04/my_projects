# BSKY Eye Clinic Database

## Project Overview

The **BSKY Eye Clinic Database** is a relational database system designed to manage the day-to-day operations of an eye clinic.

The database stores and organizes information about patients, staff, departments, appointments, eye-care services, treatment history, prescriptions, billing, payments, feedback, and inventory.

The project was created to demonstrate how a healthcare business can use a structured SQL database to manage operational data and maintain relationships between different areas of the clinic.

---

## Objectives

The main objectives of this project are to:

* Manage patient information and medical records
* Track doctors, nurses, technicians, and administrative staff
* Organize clinic departments and offices
* Schedule and manage patient appointments
* Record treatments and prescriptions
* Manage eye-care services and their prices
* Generate and track invoices
* Record payments and payment methods
* Collect patient feedback
* Monitor clinic inventory and reorder levels
* Demonstrate relational database design using MySQL

---

## Database Structure

The database is called:

```sql
bsky_eye_clinic
```

It contains **15 related tables**:

| Table               | Purpose                                         |
| ------------------- | ----------------------------------------------- |
| `offices`           | Stores clinic rooms and office information      |
| `departments`       | Stores clinic departments and department heads  |
| `staff`             | Stores information about employees              |
| `services`          | Stores eye-care services and prices             |
| `patients`          | Stores patient information                      |
| `appointments`      | Manages patient appointments                    |
| `treatment_history` | Records diagnoses and treatments                |
| `prescriptions`     | Stores prescriptions issued to patients         |
| `payers`            | Stores information about who pays for services  |
| `invoices`          | Stores patient billing information              |
| `invoice_lines`     | Stores individual services included in invoices |
| `payments`          | Records payments made against invoices          |
| `feedback`          | Stores patient ratings and comments             |
| `inventory`         | Tracks clinic supplies and stock levels         |

---

## Key Relationships

The database uses **primary keys and foreign keys** to connect related information.

Some of the main relationships include:

* A department can have multiple staff members.
* Staff members can belong to a department and be assigned to an office.
* A patient can have multiple appointments.
* An appointment is connected to a patient, staff member, service, and office.
* An appointment can have treatment history.
* Treatments can have prescriptions.
* Patients can have invoices.
* Invoices can contain multiple invoice lines.
* Invoice lines are connected to the services provided.
* Invoices can have payments.
* Appointments can receive patient feedback.
* Departments can have inventory items assigned to them.

### Simplified Relationship Flow

```text
PATIENTS
   │
   ├── APPOINTMENTS ── STAFF
   │        │             │
   │        │             ├── DEPARTMENTS
   │        │             └── OFFICES
   │        │
   │        ├── SERVICES
   │        │
   │        ├── TREATMENT HISTORY
   │        │        │
   │        │        └── PRESCRIPTIONS
   │        │
   │        └── FEEDBACK
   │
   └── INVOICES ── PAYERS
          │
          ├── INVOICE LINES ── SERVICES
          │
          └── PAYMENTS

DEPARTMENTS
   │
   └── INVENTORY
```

---

## Technologies Used

* **MySQL** – Database management system
* **SQL** – Database creation, data insertion, relationships, and queries
* **GitHub** – Project documentation and version control

---

## Database Features

### Patient Management

The `patients` table stores important patient information including:

* Name
* Date of birth
* Gender
* Email
* Phone number
* Emergency contact
* Address
* Allergies
* Insurance number

### Staff Management

The `staff` table manages clinic employees and includes their:

* Names
* Roles
* Specialties
* Email addresses
* Availability
* Assigned office
* Department

Staff roles include:

```text
Doctor
Nurse
Technician
Admin
Support
```

### Appointment Management

The `appointments` table allows the clinic to track:

* Patient
* Staff member
* Service
* Office
* Appointment date
* Appointment time
* Appointment status
* Appointment notes

Appointment statuses include:

```text
Scheduled
Completed
Cancelled
No-Show
```

### Treatment & Prescription Management

The database records patient treatment history, including diagnoses, treatment dates, and notes.

Prescriptions are linked to specific treatments and include:

* Medication
* Dosage
* Issue date
* Instructions

### Billing & Payments

The billing section consists of:

* `payers`
* `invoices`
* `invoice_lines`
* `payments`

This allows the clinic to track the services provided, invoice amounts, insurance contributions, outstanding balances, and completed payments.

### Inventory Management

The `inventory` table allows the clinic to monitor items such as:

* Eye drops
* Lens frames
* Surgical kits

It also tracks the quantity available and the reorder level.

---

## Sample Data

The database includes sample records for:

* 4 clinic offices
* 4 departments
* 4 staff members
* 4 services
* 2 patients
* 2 appointments
* 2 treatment records
* 2 prescriptions
* 2 payers
* 2 invoices
* 2 invoice lines
* 2 payments
* 2 feedback records
* 3 inventory items

The sample data is intended for demonstration and learning purposes.

---

## Database Design Concepts Demonstrated

This project demonstrates several important relational database concepts:

* Database creation
* Table creation
* Primary keys
* Foreign keys
* Auto-incrementing IDs
* One-to-many relationships
* Referential integrity
* `ENUM` data types
* `DECIMAL` data types for financial values
* `DATE` and `TIME` data types
* `CHECK` constraints
* Unique constraints
* Relational database modelling
* Data insertion

---

## How to Run the Project

### 1. Install MySQL

Install MySQL Server and a MySQL client such as **MySQL Workbench**.

### 2. Clone the Repository

```bash
git clone https://github.com/yourusername/bsky-eye-clinic-database.git
```

### 3. Open the SQL Script

Open the SQL file in MySQL Workbench or another MySQL-compatible environment.

### 4. Run the Script

Execute the script to:

1. Create the `bsky_eye_clinic` database
2. Create the required tables
3. Establish relationships between tables
4. Insert sample data

### 5. Select the Database

```sql
USE bsky_eye_clinic;
```

You can then run SQL queries against the database.

---

## Example Queries

### View all patients

```sql
SELECT *
FROM patients;
```

### View upcoming appointments

```sql
SELECT
    a.appointment_date,
    a.appointment_time,
    p.first_name,
    p.last_name,
    s.service_name,
    st.first_name AS staff_first_name,
    st.last_name AS staff_last_name
FROM appointments a
JOIN patients p
    ON a.patient_id = p.patient_id
JOIN services s
    ON a.service_id = s.service_id
JOIN staff st
    ON a.staff_id = st.staff_id;
```

### Check inventory levels

```sql
SELECT
    item_name,
    quantity_on_hand,
    reorder_level
FROM inventory
WHERE quantity_on_hand <= reorder_level;
```

### View unpaid invoice balances

```sql
SELECT
    invoice_id,
    patient_id,
    total_amount,
    balance_due,
    invoice_status
FROM invoices
WHERE balance_due > 0;
```

---

## Project Structure

A simple GitHub repository structure can look like this:

```text
bsky-eye-clinic-database/
│
├── README.md
│
├── sql/
│   └── bsky_eye_clinic.sql
│
└── docs/
    └── database-schema.png
```

If you later add more analysis or documentation, the repository can also contain:

```text
├── queries/
│   └── analysis_queries.sql
│
└── screenshots/
    └── mysql-workbench.png
```

---

## Possible Future Improvements

The database could be expanded to include:

* User login and access control
* Detailed medical examination records
* Prescription medication tables
* Insurance claim tracking
* Supplier and purchase-order management
* Appointment reminders
* Staff schedules
* More detailed patient medical history
* Automated invoice calculations
* Views and stored procedures
* Triggers for inventory updates
* Reporting dashboards using Power BI

---

## Disclaimer

This project is a **student/demo database project** created for learning and portfolio purposes.

The patient information included in the database is fictional and should not be used as real medical data.

---

This project demonstrates practical application of SQL and relational database design to a healthcare business environment.
