CREATE TABLE campaigns (
    campaign_id VARCHAR(20),
    campaign_name VARCHAR(150),
    channel VARCHAR(50),
    start_date DATE,
    end_date DATE,
    marketing_spend NUMERIC(14, 2),
    impressions INTEGER,
    clicks INTEGER,
    campaign_objective VARCHAR(100),
    target_segment VARCHAR(100),
    campaign_status VARCHAR(30),
    region VARCHAR(100)
);

--

CREATE TABLE customers (
    customer_id VARCHAR(20),
    customer_segment VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    acquisition_date DATE,
    acquisition_channel VARCHAR(50),
    customer_status VARCHAR(30),
    age_group VARCHAR(20),
    total_previous_orders INTEGER,
    lifetime_value NUMERIC(14, 2)
);

--

CREATE TABLE conversions (
    conversion_id VARCHAR(20),
    campaign_id VARCHAR(20),
    customer_id VARCHAR(20),
    conversion_date DATE,
    conversion_type VARCHAR(50),
    revenue NUMERIC(14, 2),
    order_value NUMERIC(14, 2),
    product_category VARCHAR(100),
    device_type VARCHAR(30),
    payment_method VARCHAR(50),
    conversion_status VARCHAR(30),
    is_new_customer VARCHAR(10)
);

--

SELECT 'campaigns' AS table_name, COUNT(*) AS row_count
FROM campaigns

UNION ALL

SELECT 'customers', COUNT(*)
FROM customers

UNION ALL

SELECT 'conversions', COUNT(*)
FROM conversions;

--

SELECT * FROM campaigns LIMIT 5;

--

SELECT * FROM customers LIMIT 5;

--

SELECT * FROM conversions LIMIT 5;

--

SELECT
    campaign_id,
    COUNT(*) AS duplicate_count
FROM campaigns
GROUP BY campaign_id
HAVING COUNT(*) > 1;

--

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

--

SELECT
    conversion_id,
    COUNT(*) AS duplicate_count
FROM conversions
GROUP BY conversion_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

--

SELECT
    COUNT(*) FILTER (WHERE campaign_id IS NULL OR TRIM(campaign_id) = '') AS missing_campaign_id,
    COUNT(*) FILTER (WHERE campaign_name IS NULL OR TRIM(campaign_name) = '') AS missing_campaign_name,
    COUNT(*) FILTER (WHERE channel IS NULL OR TRIM(channel) = '') AS missing_channel,
    COUNT(*) FILTER (WHERE start_date IS NULL) AS missing_start_date,
    COUNT(*) FILTER (WHERE end_date IS NULL) AS missing_end_date,
    COUNT(*) FILTER (WHERE marketing_spend IS NULL) AS missing_marketing_spend,
    COUNT(*) FILTER (WHERE impressions IS NULL) AS missing_impressions,
    COUNT(*) FILTER (WHERE clicks IS NULL) AS missing_clicks
FROM campaigns;

--

SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL OR TRIM(customer_id) = '') AS missing_customer_id,
    COUNT(*) FILTER (WHERE customer_segment IS NULL OR TRIM(customer_segment) = '') AS missing_customer_segment,
    COUNT(*) FILTER (WHERE city IS NULL OR TRIM(city) = '') AS missing_city,
    COUNT(*) FILTER (WHERE state IS NULL OR TRIM(state) = '') AS missing_state,
    COUNT(*) FILTER (WHERE acquisition_date IS NULL) AS missing_acquisition_date,
    COUNT(*) FILTER (
        WHERE acquisition_channel IS NULL
           OR TRIM(acquisition_channel) = ''
    ) AS missing_acquisition_channel,
    COUNT(*) FILTER (WHERE customer_status IS NULL OR TRIM(customer_status) = '') AS missing_customer_status,
    COUNT(*) FILTER (WHERE lifetime_value IS NULL) AS missing_lifetime_value
FROM customers;

--

SELECT
    COUNT(*) FILTER (WHERE conversion_id IS NULL OR TRIM(conversion_id) = '') AS missing_conversion_id,
    COUNT(*) FILTER (WHERE campaign_id IS NULL OR TRIM(campaign_id) = '') AS missing_campaign_id,
    COUNT(*) FILTER (WHERE customer_id IS NULL OR TRIM(customer_id) = '') AS missing_customer_id,
    COUNT(*) FILTER (WHERE conversion_date IS NULL) AS missing_conversion_date,
    COUNT(*) FILTER (WHERE conversion_type IS NULL OR TRIM(conversion_type) = '') AS missing_conversion_type,
    COUNT(*) FILTER (WHERE revenue IS NULL) AS missing_revenue,
    COUNT(*) FILTER (WHERE order_value IS NULL) AS missing_order_value,
    COUNT(*) FILTER (
        WHERE payment_method IS NULL
           OR TRIM(payment_method) = ''
    ) AS missing_payment_method,
    COUNT(*) FILTER (
        WHERE conversion_status IS NULL
           OR TRIM(conversion_status) = ''
    ) AS missing_conversion_status
FROM conversions;

--

SELECT *
FROM campaigns
WHERE marketing_spend < 0
   OR impressions < 0
   OR clicks < 0
   OR clicks > impressions
   OR end_date < start_date;

--

SELECT *
FROM customers
WHERE total_previous_orders < 0
   OR lifetime_value < 0
   OR acquisition_date > CURRENT_DATE;

--

SELECT *
FROM conversions
WHERE revenue < 0
   OR order_value < 0
   OR conversion_date > DATE '2025-12-31';

--

SELECT
    c.conversion_id,
    c.campaign_id,
    c.customer_id,
    c.conversion_date
FROM conversions c
LEFT JOIN campaigns ca
    ON c.campaign_id = ca.campaign_id
WHERE ca.campaign_id IS NULL;

--

SELECT
    c.conversion_id,
    c.campaign_id,
    c.customer_id,
    c.conversion_date
FROM conversions c
LEFT JOIN customers cu
    ON c.customer_id = cu.customer_id
WHERE cu.customer_id IS NULL;

--

SELECT
    channel,
    COUNT(*) AS record_count
FROM campaigns
GROUP BY channel
ORDER BY channel;

--

SELECT
    acquisition_channel,
    COUNT(*) AS record_count
FROM customers
GROUP BY acquisition_channel
ORDER BY acquisition_channel;

--

SELECT
    customer_segment,
    COUNT(*) AS record_count
FROM customers
GROUP BY customer_segment
ORDER BY customer_segment;

--

SELECT
    conversion_type,
    COUNT(*) AS record_count
FROM conversions
GROUP BY conversion_type
ORDER BY conversion_type;

--

SELECT
    conversion_status,
    COUNT(*) AS record_count
FROM conversions
GROUP BY conversion_status
ORDER BY conversion_status;

--

 SELECT *
FROM conversions
WHERE conversion_status = 'Completed'
  AND conversion_type = 'Purchase'
  AND revenue <= 0;

--

SELECT *
FROM conversions
WHERE conversion_status = 'Cancelled'
  AND revenue > 0;

--

SELECT
    conversion_id,
    conversion_type,
    conversion_status,
    revenue,
    order_value,
    order_value - revenue AS difference
FROM conversions
WHERE revenue <> order_value
ORDER BY ABS(order_value - revenue) DESC;

--

SELECT
    'Duplicate conversion IDs' AS check_name,
    COUNT(*) AS issue_count
FROM (
    SELECT conversion_id
    FROM conversions
    GROUP BY conversion_id
    HAVING COUNT(*) > 1
) x

UNION ALL

SELECT
    'Missing campaign channels',
    COUNT(*)
FROM campaigns
WHERE channel IS NULL OR TRIM(channel) = ''

UNION ALL

SELECT
    'Clicks greater than impressions',
    COUNT(*)
FROM campaigns
WHERE clicks > impressions

UNION ALL

SELECT
    'Missing customer segments',
    COUNT(*)
FROM customers
WHERE customer_segment IS NULL
   OR TRIM(customer_segment) = ''

UNION ALL

SELECT
    'Negative customer lifetime value',
    COUNT(*)
FROM customers
WHERE lifetime_value < 0

UNION ALL

SELECT
    'Invalid campaign references',
    COUNT(*)
FROM conversions c
LEFT JOIN campaigns ca
    ON c.campaign_id = ca.campaign_id
WHERE ca.campaign_id IS NULL

UNION ALL

SELECT
    'Invalid customer references',
    COUNT(*)
FROM conversions c
LEFT JOIN customers cu
    ON c.customer_id = cu.customer_id
WHERE cu.customer_id IS NULL

UNION ALL

SELECT
    'Negative conversion revenue',
    COUNT(*)
FROM conversions
WHERE revenue < 0

UNION ALL

SELECT
    'Conversions outside reporting period',
    COUNT(*)
FROM conversions
WHERE conversion_date < DATE '2025-01-01'
   OR conversion_date > DATE '2025-12-31'

UNION ALL

SELECT
    'Missing payment methods',
    COUNT(*)
FROM conversions
WHERE payment_method IS NULL
   OR TRIM(payment_method) = '';

--

CREATE TABLE campaigns_clean AS

WITH ranked_campaigns AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY campaign_id
            ORDER BY start_date, campaign_name
        ) AS row_num
    FROM campaigns
)

SELECT
    TRIM(campaign_id) AS campaign_id,
    TRIM(campaign_name) AS campaign_name,

    CASE
        WHEN channel IS NULL OR TRIM(channel) = ''
            THEN 'Unknown'
        WHEN LOWER(TRIM(channel)) = 'paid search'
            THEN 'Paid Search'
        WHEN LOWER(TRIM(channel)) = 'social media'
            THEN 'Social Media'
        WHEN LOWER(TRIM(channel)) = 'display ads'
            THEN 'Display Ads'
        WHEN LOWER(TRIM(channel)) = 'email'
            THEN 'Email'
        WHEN LOWER(TRIM(channel)) = 'affiliate'
            THEN 'Affiliate'
        WHEN LOWER(TRIM(channel)) = 'referral'
            THEN 'Referral'
        ELSE INITCAP(TRIM(channel))
    END AS channel,

    start_date,
    end_date,
    marketing_spend,
    impressions,

    CASE
        WHEN clicks > impressions THEN impressions
        ELSE clicks
    END AS clicks,

    TRIM(campaign_objective) AS campaign_objective,
    TRIM(target_segment) AS target_segment,
    TRIM(campaign_status) AS campaign_status,
    TRIM(region) AS region

FROM ranked_campaigns

WHERE row_num = 1
  AND campaign_id IS NOT NULL
  AND TRIM(campaign_id) <> ''
  AND marketing_spend >= 0
  AND impressions >= 0
  AND clicks >= 0
  AND start_date IS NOT NULL
  AND end_date IS NOT NULL
  AND end_date >= start_date;


--

CREATE TABLE customers_clean AS

WITH ranked_customers AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY acquisition_date, customer_id
        ) AS row_num
    FROM customers
)

SELECT
    TRIM(customer_id) AS customer_id,

    CASE
        WHEN customer_segment IS NULL
          OR TRIM(customer_segment) = ''
            THEN 'Unknown'
        ELSE INITCAP(TRIM(customer_segment))
    END AS customer_segment,

    INITCAP(TRIM(city)) AS city,
    INITCAP(TRIM(state)) AS state,
    acquisition_date,

    CASE
        WHEN acquisition_channel IS NULL
          OR TRIM(acquisition_channel) = ''
            THEN 'Unknown'
        WHEN LOWER(TRIM(acquisition_channel)) = 'paid search'
            THEN 'Paid Search'
        WHEN LOWER(TRIM(acquisition_channel)) = 'social media'
            THEN 'Social Media'
        WHEN LOWER(TRIM(acquisition_channel)) = 'display ads'
            THEN 'Display Ads'
        WHEN LOWER(TRIM(acquisition_channel)) = 'email'
            THEN 'Email'
        WHEN LOWER(TRIM(acquisition_channel)) = 'affiliate'
            THEN 'Affiliate'
        WHEN LOWER(TRIM(acquisition_channel)) = 'referral'
            THEN 'Referral'
        ELSE INITCAP(TRIM(acquisition_channel))
    END AS acquisition_channel,

    INITCAP(TRIM(customer_status)) AS customer_status,
    TRIM(age_group) AS age_group,

    CASE
        WHEN total_previous_orders < 0 THEN 0
        ELSE total_previous_orders
    END AS total_previous_orders,

    CASE
        WHEN lifetime_value < 0 THEN NULL
        ELSE lifetime_value
    END AS lifetime_value

FROM ranked_customers

WHERE row_num = 1
  AND customer_id IS NOT NULL
  AND TRIM(customer_id) <> ''
  AND acquisition_date IS NOT NULL
  AND acquisition_date <= DATE '2025-12-31';

--

DROP TABLE IF EXISTS conversions_clean;

CREATE TABLE conversions_clean AS

WITH ranked_conversions AS (
    SELECT
        c.*,

        ROW_NUMBER() OVER (
            PARTITION BY c.conversion_id
            ORDER BY c.conversion_date, c.campaign_id, c.customer_id
        ) AS row_num

    FROM conversions c
)

SELECT
    TRIM(rc.conversion_id) AS conversion_id,
    TRIM(rc.campaign_id) AS campaign_id,
    TRIM(rc.customer_id) AS customer_id,
    rc.conversion_date,

    INITCAP(TRIM(rc.conversion_type)) AS conversion_type,

    CASE
        WHEN INITCAP(TRIM(rc.conversion_status))
             IN ('Cancelled', 'Refunded')
            THEN 0
        ELSE rc.revenue
    END AS revenue,

    CASE
        WHEN INITCAP(TRIM(rc.conversion_status))
             IN ('Cancelled', 'Refunded')
            THEN 0
        ELSE rc.order_value
    END AS order_value,

    INITCAP(TRIM(rc.product_category)) AS product_category,
    INITCAP(TRIM(rc.device_type)) AS device_type,

    CASE
        WHEN rc.payment_method IS NULL
          OR TRIM(rc.payment_method) = ''
            THEN 'Unknown'
        ELSE INITCAP(TRIM(rc.payment_method))
    END AS payment_method,

    INITCAP(TRIM(rc.conversion_status)) AS conversion_status,

    CASE
        WHEN LOWER(TRIM(rc.is_new_customer)) = 'yes'
            THEN 'Yes'
        WHEN LOWER(TRIM(rc.is_new_customer)) = 'no'
            THEN 'No'
        ELSE 'Unknown'
    END AS is_new_customer

FROM ranked_conversions rc

INNER JOIN campaigns_clean ca
    ON TRIM(rc.campaign_id) = ca.campaign_id

INNER JOIN customers_clean cu
    ON TRIM(rc.customer_id) = cu.customer_id

WHERE rc.row_num = 1
  AND rc.conversion_id IS NOT NULL
  AND TRIM(rc.conversion_id) <> ''
  AND rc.conversion_date BETWEEN DATE '2025-01-01'
                             AND DATE '2025-12-31'
  AND rc.revenue >= 0
  AND rc.order_value >= 0;

--

CREATE TABLE conversions_clean AS

WITH ranked_conversions AS (
    SELECT
        c.*,

        ROW_NUMBER() OVER (
            PARTITION BY c.conversion_id
            ORDER BY c.conversion_date, c.campaign_id, c.customer_id
        ) AS row_num

    FROM conversions c
)

SELECT
    TRIM(rc.conversion_id) AS conversion_id,
    TRIM(rc.campaign_id) AS campaign_id,
    TRIM(rc.customer_id) AS customer_id,
    rc.conversion_date,

    INITCAP(TRIM(rc.conversion_type)) AS conversion_type,

    CASE
        WHEN INITCAP(TRIM(rc.conversion_status))
             IN ('Cancelled', 'Refunded')
            THEN 0
        ELSE rc.revenue
    END AS revenue,

    CASE
        WHEN INITCAP(TRIM(rc.conversion_status))
             IN ('Cancelled', 'Refunded')
            THEN 0
        ELSE rc.order_value
    END AS order_value,

    INITCAP(TRIM(rc.product_category)) AS product_category,
    INITCAP(TRIM(rc.device_type)) AS device_type,

    CASE
        WHEN rc.payment_method IS NULL
          OR TRIM(rc.payment_method) = ''
            THEN 'Unknown'
        ELSE INITCAP(TRIM(rc.payment_method))
    END AS payment_method,

    INITCAP(TRIM(rc.conversion_status)) AS conversion_status,

    CASE
        WHEN LOWER(TRIM(rc.is_new_customer)) = 'yes'
            THEN 'Yes'
        WHEN LOWER(TRIM(rc.is_new_customer)) = 'no'
            THEN 'No'
        ELSE 'Unknown'
    END AS is_new_customer

FROM ranked_conversions rc

INNER JOIN campaigns_clean ca
    ON TRIM(rc.campaign_id) = ca.campaign_id

INNER JOIN customers_clean cu
    ON TRIM(rc.customer_id) = cu.customer_id

WHERE rc.row_num = 1
  AND rc.conversion_id IS NOT NULL
  AND TRIM(rc.conversion_id) <> ''
  AND rc.conversion_date BETWEEN DATE '2025-01-01'
                             AND DATE '2025-12-31'
  AND rc.revenue >= 0
  AND rc.order_value >= 0;

--

DELETE FROM conversions_clean
WHERE conversion_status = 'Completed'
  AND conversion_type = 'Purchase'
  AND revenue <= 0;

--

ALTER TABLE campaigns_clean
ADD CONSTRAINT pk_campaigns_clean
PRIMARY KEY (campaign_id);

--


ALTER TABLE customers_clean
ADD CONSTRAINT pk_customers_clean
PRIMARY KEY (customer_id);

--

ALTER TABLE conversions_clean
ADD CONSTRAINT pk_conversions_clean
PRIMARY KEY (conversion_id);

--

ALTER TABLE conversions_clean
ADD CONSTRAINT fk_conversions_campaign
FOREIGN KEY (campaign_id)
REFERENCES campaigns_clean(campaign_id);

--

ALTER TABLE conversions_clean
ADD CONSTRAINT fk_conversions_customer
FOREIGN KEY (customer_id)
REFERENCES customers_clean(customer_id);

--

SELECT
    'campaigns' AS dataset,
    (SELECT COUNT(*) FROM campaigns) AS raw_rows,
    (SELECT COUNT(*) FROM campaigns_clean) AS clean_rows,
    (SELECT COUNT(*) FROM campaigns)
      - (SELECT COUNT(*) FROM campaigns_clean) AS removed_rows

UNION ALL

SELECT
    'customers',
    (SELECT COUNT(*) FROM customers),
    (SELECT COUNT(*) FROM customers_clean),
    (SELECT COUNT(*) FROM customers)
      - (SELECT COUNT(*) FROM customers_clean)

UNION ALL

SELECT
    'conversions',
    (SELECT COUNT(*) FROM conversions),
    (SELECT COUNT(*) FROM conversions_clean),
    (SELECT COUNT(*) FROM conversions)
      - (SELECT COUNT(*) FROM conversions_clean);

--

SELECT
    conversion_id,
    COUNT(*) AS record_count
FROM conversions_clean
GROUP BY conversion_id
HAVING COUNT(*) > 1;

--

CREATE VIEW monthly_kpi_summary AS

WITH campaign_monthly AS (
    SELECT
        DATE_TRUNC('month', start_date)::DATE AS report_month,

        SUM(marketing_spend) AS total_marketing_spend,
        SUM(impressions) AS total_impressions,
        SUM(clicks) AS total_clicks,
        COUNT(DISTINCT campaign_id) AS total_campaigns

    FROM campaigns_clean

    GROUP BY
        DATE_TRUNC('month', start_date)::DATE
),

conversion_monthly AS (
    SELECT
        DATE_TRUNC('month', conversion_date)::DATE AS report_month,

        COUNT(DISTINCT conversion_id)
            FILTER (
                WHERE conversion_status = 'Completed'
            ) AS total_conversions,

        COUNT(DISTINCT customer_id)
            FILTER (
                WHERE conversion_status = 'Completed'
                  AND is_new_customer = 'Yes'
            ) AS new_customers,

        SUM(revenue)
            FILTER (
                WHERE conversion_status = 'Completed'
            ) AS total_revenue,

        AVG(revenue)
            FILTER (
                WHERE conversion_status = 'Completed'
                  AND conversion_type = 'Purchase'
                  AND revenue > 0
            ) AS average_order_value

    FROM conversions_clean

    GROUP BY
        DATE_TRUNC('month', conversion_date)::DATE
),

all_months AS (
    SELECT report_month
    FROM campaign_monthly

    UNION

    SELECT report_month
    FROM conversion_monthly
)

SELECT
    m.report_month,

    COALESCE(cm.total_campaigns, 0) AS total_campaigns,

    ROUND(
        COALESCE(cm.total_marketing_spend, 0),
        2
    ) AS total_marketing_spend,

    COALESCE(cm.total_impressions, 0) AS total_impressions,

    COALESCE(cm.total_clicks, 0) AS total_clicks,

    COALESCE(cv.total_conversions, 0) AS total_conversions,

    COALESCE(cv.new_customers, 0) AS new_customers,

    ROUND(
        COALESCE(cv.total_revenue, 0),
        2
    ) AS total_revenue,

    ROUND(
        COALESCE(cv.average_order_value, 0),
        2
    ) AS average_order_value,

    ROUND(
        COALESCE(cm.total_clicks, 0)::NUMERIC
        / NULLIF(cm.total_impressions, 0)
        * 100,
        2
    ) AS ctr_percentage,

    ROUND(
        COALESCE(cv.total_conversions, 0)::NUMERIC
        / NULLIF(cm.total_clicks, 0)
        * 100,
        2
    ) AS conversion_rate_percentage,

    ROUND(
        COALESCE(cm.total_marketing_spend, 0)
        / NULLIF(cv.new_customers, 0),
        2
    ) AS customer_acquisition_cost,

    ROUND(
        COALESCE(cv.total_revenue, 0)
        / NULLIF(cm.total_marketing_spend, 0),
        2
    ) AS roas,

    ROUND(
        COALESCE(cm.total_marketing_spend, 0)
        / NULLIF(cm.total_clicks, 0),
        2
    ) AS cost_per_click

FROM all_months m

LEFT JOIN campaign_monthly cm
    ON m.report_month = cm.report_month

LEFT JOIN conversion_monthly cv
    ON m.report_month = cv.report_month;

--

SELECT *
FROM monthly_kpi_summary
ORDER BY report_month;

--

WITH campaign_totals AS (
    SELECT
        SUM(marketing_spend) AS total_spend,
        SUM(impressions) AS total_impressions,
        SUM(clicks) AS total_clicks
    FROM campaigns_clean
),

conversion_totals AS (
    SELECT
        COUNT(DISTINCT conversion_id)
            FILTER (
                WHERE conversion_status = 'Completed'
            ) AS total_conversions,

        COUNT(DISTINCT customer_id)
            FILTER (
                WHERE conversion_status = 'Completed'
                  AND is_new_customer = 'Yes'
            ) AS new_customers,

        SUM(revenue)
            FILTER (
                WHERE conversion_status = 'Completed'
            ) AS total_revenue,

        AVG(revenue)
            FILTER (
                WHERE conversion_status = 'Completed'
                  AND conversion_type = 'Purchase'
                  AND revenue > 0
            ) AS average_order_value

    FROM conversions_clean
)

SELECT
    ROUND(ct.total_spend, 2) AS total_marketing_spend,

    ct.total_impressions,

    ct.total_clicks,

    cv.total_conversions,

    cv.new_customers,

    ROUND(cv.total_revenue, 2) AS total_revenue,

    ROUND(
        ct.total_clicks::NUMERIC
        / NULLIF(ct.total_impressions, 0)
        * 100,
        2
    ) AS ctr_percentage,

    ROUND(
        cv.total_conversions::NUMERIC
        / NULLIF(ct.total_clicks, 0)
        * 100,
        2
    ) AS conversion_rate_percentage,

    ROUND(
        ct.total_spend
        / NULLIF(cv.new_customers, 0),
        2
    ) AS customer_acquisition_cost,

    ROUND(
        cv.total_revenue
        / NULLIF(ct.total_spend, 0),
        2
    ) AS roas,

    ROUND(
        ct.total_spend
        / NULLIF(ct.total_clicks, 0),
        2
    ) AS cost_per_click,

    ROUND(
        cv.average_order_value,
        2
    ) AS average_order_value

FROM campaign_totals ct
CROSS JOIN conversion_totals cv;

--

SELECT
    SUM(marketing_spend) AS campaigns_table_spend
FROM campaigns_clean;

SELECT
    SUM(total_marketing_spend) AS monthly_view_spend
FROM monthly_kpi_summary;

--

CREATE VIEW channel_performance AS

WITH campaign_channel AS (
    SELECT
        channel,
        SUM(marketing_spend) AS total_spend,
        SUM(impressions) AS total_impressions,
        SUM(clicks) AS total_clicks,
        COUNT(DISTINCT campaign_id) AS total_campaigns
    FROM campaigns_clean
    GROUP BY channel
),

conversion_channel AS (
    SELECT
        ca.channel,

        COUNT(DISTINCT c.conversion_id)
            FILTER (
                WHERE c.conversion_status = 'Completed'
            ) AS total_conversions,

        COUNT(DISTINCT c.customer_id)
            FILTER (
                WHERE c.conversion_status = 'Completed'
                  AND c.is_new_customer = 'Yes'
            ) AS new_customers,

        SUM(c.revenue)
            FILTER (
                WHERE c.conversion_status = 'Completed'
            ) AS total_revenue,

        AVG(c.revenue)
            FILTER (
                WHERE c.conversion_status = 'Completed'
                  AND c.conversion_type = 'Purchase'
                  AND c.revenue > 0
            ) AS average_order_value

    FROM conversions_clean c

    JOIN campaigns_clean ca
        ON c.campaign_id = ca.campaign_id

    GROUP BY ca.channel
)

SELECT
    cc.channel,

    cc.total_campaigns,

    ROUND(cc.total_spend, 2) AS total_marketing_spend,

    cc.total_impressions,

    cc.total_clicks,

    COALESCE(vc.total_conversions, 0) AS total_conversions,

    COALESCE(vc.new_customers, 0) AS new_customers,

    ROUND(
        COALESCE(vc.total_revenue, 0),
        2
    ) AS total_revenue,

    ROUND(
        cc.total_clicks::NUMERIC
        / NULLIF(cc.total_impressions, 0)
        * 100,
        2
    ) AS ctr_percentage,

    ROUND(
        COALESCE(vc.total_conversions, 0)::NUMERIC
        / NULLIF(cc.total_clicks, 0)
        * 100,
        2
    ) AS conversion_rate_percentage,

    ROUND(
        cc.total_spend
        / NULLIF(vc.new_customers, 0),
        2
    ) AS customer_acquisition_cost,

    ROUND(
        COALESCE(vc.total_revenue, 0)
        / NULLIF(cc.total_spend, 0),
        2
    ) AS roas,

    ROUND(
        cc.total_spend
        / NULLIF(cc.total_clicks, 0),
        2
    ) AS cost_per_click,

    ROUND(
        COALESCE(vc.average_order_value, 0),
        2
    ) AS average_order_value

FROM campaign_channel cc

LEFT JOIN conversion_channel vc
    ON cc.channel = vc.channel;

--

SELECT *
FROM channel_performance
ORDER BY total_revenue DESC;

--

