-- Executive financial KPIs. Payment totals are pre-aggregated per invoice
-- to prevent invoice amounts being duplicated for instalment payments.
WITH PaymentSummary AS (
    SELECT InvoiceID, SUM(AmountPaid) AS TotalPaid
    FROM Payments
    GROUP BY InvoiceID
)
SELECT
    SUM(i.AmountDue) AS TotalFeesBilled,
    SUM(COALESCE(ps.TotalPaid, 0)) AS TotalFeesCollected,
    SUM(i.AmountDue - COALESCE(ps.TotalPaid, 0)) AS TotalOutstanding,
    ROUND(
        100.0 * SUM(COALESCE(ps.TotalPaid, 0)) / NULLIF(SUM(i.AmountDue), 0),
        2
    ) AS CollectionRatePercent
FROM Invoices AS i
LEFT JOIN PaymentSummary AS ps ON ps.InvoiceID = i.InvoiceID;
