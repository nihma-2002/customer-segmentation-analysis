-- Customer-level RFM base table
SELECT
    CustomerID,
    MAX(InvoiceDate) AS last_purchase_date,
    COUNT(DISTINCT InvoiceNo) AS frequency,
    SUM(Quantity * UnitPrice) AS monetary
FROM transactions
WHERE Quantity > 0
  AND UnitPrice > 0
  AND CustomerID IS NOT NULL
GROUP BY CustomerID;


-- RFM segmentation logic (conceptual)
SELECT
    CustomerID,
    CASE
        WHEN recency_score >= 3 AND frequency_score >= 3 AND monetary_score >= 3
            THEN 'Champions'
        WHEN recency_score >= 3 AND frequency_score >= 2
            THEN 'Loyal Customers'
        WHEN recency_score >= 2 AND frequency_score >= 2
            THEN 'Potential Loyalists'
        WHEN recency_score <= 2 AND frequency_score >= 2
            THEN 'At Risk'
        ELSE 'Lost Customers'
    END AS customer_segment
FROM rfm_scores;


-- Segment-level summary
SELECT
    customer_segment,
    AVG(recency) AS avg_recency,
    AVG(frequency) AS avg_frequency,
    AVG(monetary) AS avg_monetary
FROM customer_segments
GROUP BY customer_segment
ORDER BY avg_monetary DESC;
