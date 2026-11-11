-- Collection by payment mode
SELECT
    PaymentMode,
    SUM(AmountPaid) AS TotalCollected,
    ROUND(100.0 * SUM(AmountPaid) / (SELECT SUM(AmountPaid) FROM Payments), 2) AS SharePercent
FROM Payments
GROUP BY PaymentMode
ORDER BY TotalCollected DESC;

-- Monthly payment collection
SELECT
    strftime('%Y-%m', PaymentDate) AS PaymentMonth,
    SUM(AmountPaid) AS TotalCollected
FROM Payments
GROUP BY strftime('%Y-%m', PaymentDate)
ORDER BY PaymentMonth;
