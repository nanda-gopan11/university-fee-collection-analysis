# University Fee Collection & Payment Analysis

An end-to-end data analytics portfolio project using **Excel, SQL (SQLite), Power BI and DAX**. The project explores a fictional university's fee invoices and payment transactions to understand collections, outstanding balances, payment behaviour and overdue invoices.

> **Dataset notice:** All records and names in this project are synthetic and were created for learning and portfolio demonstration. They do not represent real students or institutional financial records.

## Business problem

University management needs a clear view of how much has been billed, how much has been collected, what remains outstanding, which departments have the largest balances, and how payment patterns vary over time and payment method.

## Questions explored

1. What is the total amount billed, collected and outstanding?
2. What is the fee collection rate?
3. Which departments have the highest billed amount, collection and outstanding balance?
4. Which payment methods contribute the most collection value?
5. How does collection vary month by month?
6. How many invoices are fully paid, partially paid or unpaid?
7. Which invoices are overdue, and what is their outstanding value?
8. Which students have the largest outstanding balances?

## Tools and skills

- **Excel:** data inspection, `COUNTIF`, `SUMIF`, outstanding balance calculation and invoice status classification.
- **SQLite / SQL:** joins, aggregate functions, `GROUP BY`, CTEs, `LEFT JOIN`, `COALESCE`, date grouping and ranking.
- **Power BI:** Power Query, data modelling, one-to-many relationships, DAX measures, calculated columns, slicers and report visuals.
- **GitHub:** project organisation, documentation and version control.

## Dataset overview

| Table | Rows | Purpose |
|---|---:|---|
| Departments | 4 | Department lookup and collection targets |
| Students | 20 | Student and department details |
| Invoices | 80 | Fee amounts billed to students |
| Payments | 90 | Payment transactions against invoices |

There are more payment transactions than invoices because some invoices are paid in instalments. The `Payments` table does not contain a transaction-status field; every row is treated as a recorded successful payment for this project.

## Data model

The model uses these one-to-many relationships:

```text
Departments (1) ─── (*) Students (1) ─── (*) Invoices (1) ─── (*) Payments
     DepartmentID             StudentID               InvoiceID
```

- `Departments.DepartmentID` → `Students.DepartmentID`
- `Students.StudentID` → `Invoices.StudentID`
- `Invoices.InvoiceID` → `Payments.InvoiceID`

## Key findings

The following results were validated against the supplied SQLite database:

| Metric | Result |
|---|---:|
| Total fees billed | ₹27,51,500 |
| Total fees collected | ₹22,79,500 |
| Total outstanding | ₹4,72,000 |
| Collection rate | 82.85% |
| Fully paid invoices | 50 (62.5%) |
| Partially paid invoices | 20 (25.0%) |
| Unpaid invoices | 10 (12.5%) |
| Overpaid invoices | 0 |

### Department performance

| Department | Billed | Collected | Outstanding |
|---|---:|---:|---:|
| Computer Science | ₹7,11,500 | ₹6,13,500 | ₹98,000 |
| Electronics and Communication | ₹7,02,250 | ₹5,59,300 | ₹1,42,950 |
| Electrical Engineering | ₹6,82,750 | ₹5,42,500 | ₹1,40,250 |
| Mechanical Engineering | ₹6,55,000 | ₹5,64,200 | ₹90,800 |

Electronics and Communication has the largest outstanding balance. Electronics and Communication and Electrical Engineering together account for 60% of total outstanding fees.

### Payment method performance

| Payment mode | Amount collected | Share of collection |
|---|---:|---:|
| UPI | ₹6,81,250 | 29.89% |
| Card | ₹6,43,750 | 28.24% |
| Online Portal | ₹6,00,000 | 26.32% |
| Cash | ₹2,42,000 | 10.62% |
| NEFT | ₹1,12,500 | 4.94% |

UPI contributes the largest collection value in this dataset.

### Monthly collection

| Month | Amount collected |
|---|---:|
| January 2026 | ₹5,99,000 |
| February 2026 | ₹6,00,000 |
| March 2026 | ₹1,59,750 |
| April 2026 | ₹46,250 |
| July 2026 | ₹8,39,500 |
| September 2026 | ₹17,500 |
| October 2026 | ₹17,500 |

July 2026 is the highest collection month in the dataset. All July transactions are for Semester 2 tuition fees in this synthetic sample.

### Overdue analysis

Using **10 November 2026** as the analysis date, 30 invoices have passed their due date and still have a balance. Their combined outstanding balance is ₹4,72,000. The overdue result is date-dependent; the Power BI measures using `TODAY()` will update as the report is refreshed on a later date.

## Recommendations

1. Prioritise follow-up for departments with larger outstanding balances, especially Electronics and Communication and Electrical Engineering.
2. Review the 30 overdue invoices and plan student-level reminders based on outstanding amount and due date.
3. Monitor monthly collection patterns and investigate unusually high or low months.
4. Continue supporting commonly used digital payment methods while monitoring the collection mix.
5. Track fully paid, partially paid and unpaid invoice counts as part of a regular finance review.

## Repository structure

```text
University-Fee-Analysis/
├── data/
│   ├── departments.csv
│   ├── students.csv
│   ├── invoices.csv
│   ├── payments.csv
│   └── University_Fee_Analysis_Data.xlsx
├── database/
│   └── university_fee_analysis.db
├── sql/
│   ├── 01_data_validation.sql
│   ├── 02_executive_kpis.sql
│   ├── 03_department_analysis.sql
│   ├── 04_payment_analysis.sql
│   ├── 05_invoice_status.sql
│   ├── 06_overdue_analysis.sql
│   └── 07_top_students.sql
├── powerbi/
│   ├── University_Fee_Analysis.pbix   # Add your saved PBIX here
│   └── screenshots/                   # Add exported report-page images here
├── docs/
│   ├── data_dictionary.md
│   └── dax_measures.md
└── README.md
```

## Reproducing the analysis

1. Open `database/university_fee_analysis.db` with a SQLite-compatible editor, or import the CSV files into a database.
2. Run the SQL scripts in the numbered order. They are written for SQLite.
3. Open `data/University_Fee_Analysis_Data.xlsx` in Power BI, or connect Power BI to the CSV files.
4. In Power Query, verify the column types. Set `InvoiceDate`, `DueDate` and `PaymentDate` to Date.
5. Create the three one-to-many relationships described in the Data Model section.
6. Use the DAX reference in `docs/dax_measures.md` to reproduce the measures and invoice calculated columns.
7. Save your report as `powerbi/University_Fee_Analysis.pbix` and add screenshots of the report pages to `powerbi/screenshots/`.

## Notes and limitations

- This is a compact synthetic training dataset, not a statistical sample of a real university.
- The project has no payment transaction status field, so failed or reversed transactions cannot be analysed.
- The overdue count and amount use 10 November 2026 as the reproducible SQL snapshot date. Power BI's `TODAY()`-based measures are dynamic.
- The top-five student view ranks outstanding amounts at student level after aggregating each student's invoice balances. The fifth position contains a tie in the supplied data.
