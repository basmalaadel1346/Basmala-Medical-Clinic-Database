# **🏥 Basmala-Medical-Clinic-Database**



##### This repository represents the Database Architecture Layer of a Medical Clinic System. The primary focus of this phase is to establish a highly normalized, robust, and safe data foundation implementing ACID properties, proper indexing, and concurrency control, paving the way for future Backend API integration.

##### 

##### A fully normalized, robust, and scalable relational database designed to manage the core operations of a medical clinic. This project focuses on applying advanced Data Engineering concepts, ensuring high data integrity, and optimizing performance.

##### 

##### This project was built as a practical implementation of the concepts learned in the "15 - Database Level 1 - SQL" course provided by ProgrammingAdvices.



## 🚀 Key Features \& Engineering Practices

###### Clean Architecture: Separation of concerns by dividing the project into distinct DDL (Schema, Indexes, Views) and DML/DQL (Data, Reports) scripts.

###### 

###### Data Integrity \& Normalization: Eliminated data redundancy using proper normalization techniques. Implemented UNIQUE constraints with Foreign Keys to enforce strict 1:1 relationships (e.g., separating the base Persons table from Doctors and Patients).

###### 

###### Performance Optimization: Strategic implementation of NONCLUSTERED INDEXES on frequently queried Foreign Key columns to significantly speed up JOIN operations.

###### 

###### Robust Transactions (ACID Properties): Utilized BEGIN TRANSACTION paired with TRY...CATCH blocks to ensure data consistency and atomicity during complex, multi-table insertion processes.

###### 

###### Dynamic Data Insertion: Leveraged the SCOPE\_IDENTITY() function to safely retrieve and bind auto-generated IDs in real-time without hardcoding, making the script deployment-ready and concurrency-safe.



📂 Project Structure

---

###### The repository is organized following Best Practices for database deployment:

###### 

###### 01\_schema.sql: Contains the core table creations, Primary Keys, and Foreign Key constraints (ON DELETE CASCADE).

###### 

###### 02\_indexes.sql: Contains performance tuning scripts using idempotent operations (IF NOT EXISTS) to create non-clustered indexes.

###### 

###### 03\_views.sql: Encapsulates complex JOIN logic into a clean, reusable VIEW (vw\_AppointmentsDetails) to simplify frontend integration.

###### 

###### 04\_SQLQuery4.sql: Contains transactional mock data insertion and comprehensive test queries (Business Reports) utilizing GROUP BY, COUNT, and SUM.


📊 Entity Relationship Diagram (ERD)
---

###### 

⚙️ How to Run

---

###### To execute this project locally on SQL Server (SSMS):

###### 

###### Execute 01\_schema.sql to build the foundational architecture.

###### 

###### Execute 02\_indexes.sql to apply performance optimizations.

###### 

###### Execute 03\_views.sql to construct the reporting layers.

###### 

###### Execute 04\_SQLQuery4.sql to populate the database safely and view the automated business reports.

###### 

###### Developed with love and Engineering Mindset by Basmala Adel 💻✨

