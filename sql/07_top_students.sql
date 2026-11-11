-- Top five students by total outstanding balance.
WITH PaymentSummary AS (
    SELECT InvoiceID, SUM(AmountPaid) AS TotalPaid
    FROM Payments
    GROUP BY InvoiceID
), StudentBalances AS (
    SELECT
        s.StudentID,
        s.StudentName,
        d.DepartmentName,
        SUM(i.AmountDue - COALESCE(ps.TotalPaid, 0)) AS TotalOutstanding
    FROM Students AS s
    JOIN Departments AS d ON d.DepartmentID = s.DepartmentID
    JOIN Invoices AS i ON i.StudentID = s.StudentID
    LEFT JOIN PaymentSummary AS ps ON ps.InvoiceID = i.InvoiceID
    GROUP BY s.StudentID, s.StudentName, d.DepartmentName
)
SELECT StudentID, StudentName, DepartmentName, TotalOutstanding
FROM StudentBalances
WHERE TotalOutstanding > 0
ORDER BY TotalOutstanding DESC, StudentName
LIMIT 5;
