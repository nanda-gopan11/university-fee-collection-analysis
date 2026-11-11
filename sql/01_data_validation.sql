-- Basic row counts
SELECT 'Departments' AS table_name, COUNT(*) AS row_count FROM Departments
UNION ALL SELECT 'Students', COUNT(*) FROM Students
UNION ALL SELECT 'Invoices', COUNT(*) FROM Invoices
UNION ALL SELECT 'Payments', COUNT(*) FROM Payments;

-- Check invoices with no matching payment transaction
SELECT i.InvoiceID, i.StudentID, i.FeeType, i.AmountDue
FROM Invoices AS i
LEFT JOIN Payments AS p ON p.InvoiceID = i.InvoiceID
WHERE p.PaymentID IS NULL
ORDER BY i.InvoiceID;

-- Check payment records that do not map to an invoice (expected: no rows)
SELECT p.*
FROM Payments AS p
LEFT JOIN Invoices AS i ON i.InvoiceID = p.InvoiceID
WHERE i.InvoiceID IS NULL;
