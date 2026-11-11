# Data Dictionary

All data is synthetic. Amounts are in Indian rupees (INR).

## Departments

| Column | Type | Description |
|---|---|---|
| DepartmentID | TEXT | Unique department key (for example, D01). |
| DepartmentName | TEXT | Full department name. |
| DepartmentCode | TEXT | Short department code. |
| CollectionTarget | INTEGER | Synthetic fee collection target for the department. |

## Students

| Column | Type | Description |
|---|---|---|
| StudentID | INTEGER | Unique student identifier. |
| StudentName | TEXT | Fictional student name. |
| DepartmentID | TEXT | Department key; references Departments. |
| Program | TEXT | Academic programme. |
| AdmissionYear | INTEGER | Admission year. |
| StudentType | TEXT | Hosteller or Day Scholar. |

## Invoices

| Column | Type | Description |
|---|---|---|
| InvoiceID | INTEGER | Unique invoice identifier. |
| StudentID | INTEGER | Student identifier; references Students. |
| FeeType | TEXT | Type of fee billed. |
| InvoiceDate | DATE/TEXT | Invoice issue date (ISO date in SQLite). |
| DueDate | DATE/TEXT | Invoice due date (ISO date in SQLite). |
| AmountDue | INTEGER | Amount billed in INR. |
| AcademicYear | TEXT | Academic year label. |
| Semester | TEXT | Semester label. |

## Payments

| Column | Type | Description |
|---|---|---|
| PaymentID | INTEGER | Unique payment transaction identifier. |
| InvoiceID | INTEGER | Invoice identifier; references Invoices. |
| PaymentDate | DATE/TEXT | Payment date (ISO date in SQLite). |
| AmountPaid | INTEGER | Amount received in INR. |
| PaymentMode | TEXT | UPI, Card, Online Portal, Cash or NEFT. |

## Relationship keys

- Departments.DepartmentID → Students.DepartmentID
- Students.StudentID → Invoices.StudentID
- Invoices.InvoiceID → Payments.InvoiceID
