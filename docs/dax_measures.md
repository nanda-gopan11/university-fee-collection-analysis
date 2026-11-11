# Power BI DAX Reference

Create the financial calculations as **New measures** (not New columns), unless explicitly labelled as a calculated column below.

## Numeric measures

```dax
Total Fees Billed =
SUM(Invoices[AmountDue])

Total Fees Collected =
SUM(Payments[AmountPaid])

Total Outstanding Fees =
[Total Fees Billed] - [Total Fees Collected]

Collection Rate =
DIVIDE([Total Fees Collected], [Total Fees Billed], 0)

Total Invoice Count =
COUNTROWS(Invoices)

Billed Amount Numeric =
SUM(Invoices[AmountDue])

Collected Amount Numeric =
SUM(Payments[AmountPaid])

Outstanding Amount Numeric =
[Total Fees Billed] - [Total Fees Collected]
```

Format `Collection Rate` as Percentage with two decimal places.

## Calculated columns in Invoices

```dax
Invoice Total Paid =
COALESCE(
    SUMX(RELATEDTABLE(Payments), Payments[AmountPaid]),
    0
)

Invoice Payment Status =
SWITCH(
    TRUE(),
    Invoices[Invoice Total Paid] = 0, "Unpaid",
    Invoices[Invoice Total Paid] > Invoices[AmountDue], "Overpaid",
    Invoices[Invoice Total Paid] = Invoices[AmountDue], "Fully Paid",
    "Partially Paid"
)
```

## Overdue measures

These measures use `TODAY()`, so their values change as the report is refreshed over time.

```dax
Overdue Invoice Count =
COUNTROWS(
    FILTER(
        Invoices,
        Invoices[DueDate] < TODAY()
            && Invoices[Invoice Total Paid] < Invoices[AmountDue]
    )
)

Total Overdue Amount =
SUMX(
    FILTER(
        Invoices,
        Invoices[DueDate] < TODAY()
            && Invoices[Invoice Total Paid] < Invoices[AmountDue]
    ),
    Invoices[AmountDue] - Invoices[Invoice Total Paid]
)
```

## Display-only measures for KPI Cards

`FORMAT()` returns text. Use these measures only when a Card needs Indian currency grouping. Use the numeric measures above in charts and calculations.

```dax
Total Fees Billed Display =
FORMAT([Total Fees Billed], "₹#,##,##0", "en-IN")

Total Fees Collected Display =
FORMAT([Total Fees Collected], "₹#,##,##0", "en-IN")

Total Outstanding Display =
FORMAT([Total Outstanding Fees], "₹#,##,##0", "en-IN")

Total Overdue Amount Display =
FORMAT([Total Overdue Amount], "₹#,##,##0", "en-IN")
```

## Model relationships

- Departments[DepartmentID] (1) → Students[DepartmentID] (*)
- Students[StudentID] (1) → Invoices[StudentID] (*)
- Invoices[InvoiceID] (1) → Payments[InvoiceID] (*)

Use single-direction filtering from the lookup/parent side to the child side.
