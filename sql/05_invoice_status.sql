-- Invoice payment status based on aggregated payments per invoice.
WITH PaymentSummary AS (
    SELECT InvoiceID, SUM(AmountPaid) AS TotalPaid
    FROM Payments
    GROUP BY InvoiceID
), InvoiceBalances AS (
    SELECT
        i.InvoiceID,
        i.StudentID,
        i.AmountDue,
        COALESCE(ps.TotalPaid, 0) AS TotalPaid,
        i.AmountDue - COALESCE(ps.TotalPaid, 0) AS OutstandingBalance,
        CASE
            WHEN COALESCE(ps.TotalPaid, 0) = 0 THEN 'Unpaid'
            WHEN COALESCE(ps.TotalPaid, 0) > i.AmountDue THEN 'Overpaid'
            WHEN COALESCE(ps.TotalPaid, 0) = i.AmountDue THEN 'Fully Paid'
            ELSE 'Partially Paid'
        END AS PaymentStatus
    FROM Invoices AS i
    LEFT JOIN PaymentSummary AS ps ON ps.InvoiceID = i.InvoiceID
)
SELECT PaymentStatus, COUNT(*) AS InvoiceCount
FROM InvoiceBalances
GROUP BY PaymentStatus
ORDER BY InvoiceCount DESC;
