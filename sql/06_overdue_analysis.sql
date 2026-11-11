-- Reproducible overdue analysis as of 10 November 2026.
-- Change the date literal to use another reporting date.
WITH PaymentSummary AS (
    SELECT InvoiceID, SUM(AmountPaid) AS TotalPaid
    FROM Payments
    GROUP BY InvoiceID
), InvoiceBalances AS (
    SELECT
        i.InvoiceID,
        i.StudentID,
        i.DueDate,
        i.AmountDue,
        COALESCE(ps.TotalPaid, 0) AS TotalPaid,
        i.AmountDue - COALESCE(ps.TotalPaid, 0) AS OutstandingBalance
    FROM Invoices AS i
    LEFT JOIN PaymentSummary AS ps ON ps.InvoiceID = i.InvoiceID
)
SELECT
    COUNT(*) AS OverdueInvoiceCount,
    SUM(OutstandingBalance) AS TotalOverdueAmount
FROM InvoiceBalances
WHERE date(DueDate) < date('2026-11-10')
  AND OutstandingBalance > 0;

-- Overdue amount by department
WITH PaymentSummary AS (
    SELECT InvoiceID, SUM(AmountPaid) AS TotalPaid
    FROM Payments
    GROUP BY InvoiceID
)
SELECT
    d.DepartmentName,
    SUM(i.AmountDue - COALESCE(ps.TotalPaid, 0)) AS OverdueAmount
FROM Departments AS d
JOIN Students AS s ON s.DepartmentID = d.DepartmentID
JOIN Invoices AS i ON i.StudentID = s.StudentID
LEFT JOIN PaymentSummary AS ps ON ps.InvoiceID = i.InvoiceID
WHERE date(i.DueDate) < date('2026-11-10')
  AND i.AmountDue > COALESCE(ps.TotalPaid, 0)
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY OverdueAmount DESC;
