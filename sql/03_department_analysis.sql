-- Department-wise billed, collected and outstanding amounts.
WITH PaymentSummary AS (
    SELECT InvoiceID, SUM(AmountPaid) AS TotalPaid
    FROM Payments
    GROUP BY InvoiceID
)
SELECT
    d.DepartmentName,
    SUM(i.AmountDue) AS TotalFeesBilled,
    SUM(COALESCE(ps.TotalPaid, 0)) AS TotalFeesCollected,
    SUM(i.AmountDue - COALESCE(ps.TotalPaid, 0)) AS OutstandingBalance
FROM Departments AS d
JOIN Students AS s ON s.DepartmentID = d.DepartmentID
JOIN Invoices AS i ON i.StudentID = s.StudentID
LEFT JOIN PaymentSummary AS ps ON ps.InvoiceID = i.InvoiceID
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY OutstandingBalance DESC;
