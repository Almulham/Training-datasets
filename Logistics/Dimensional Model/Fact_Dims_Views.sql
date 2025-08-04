-- Create view combining order facts with related dimension data into a single fact view
CREATE OR REPLACE VIEW vw_fact_shipments AS
WITH base_orders AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_date
    FROM orders o
),

customers_cte AS (
    SELECT
        customer_id,
        name,
        email,
        phone
    FROM customers
),

order_processing_cte AS (
    SELECT
        order_id,
        verified,
        inventory_checked,
        processed_date
    FROM order_processing
),

packaging_cte AS (
    SELECT
        order_id,
        package_type,
        fragile,
        packed_date
    FROM packaging
),

labeling_cte AS (
    SELECT
        order_id,
        tracking_number,
        recipient_address,
        special_notes
    FROM labeling
),

carrier_cte AS (
    SELECT
        order_id,
        carrier_name,
        shipping_cost,
        estimated_days
    FROM carrier_selection
),

delivery_cte AS (
    SELECT
        order_id,
        delivered_date,
        delivery_status
    FROM delivery
),

latest_tracking_cte AS (
    SELECT DISTINCT ON (tracking_number)
        tracking_number,
        status,
        last_updated,
        location
    FROM shipment_tracking
    ORDER BY tracking_number, last_updated DESC
)

SELECT
    bo.order_id,
    bo.customer_id,
    c.name               AS customer_name,
    c.email              AS customer_email,
    c.phone              AS customer_phone,
    bo.order_date,

    op.verified,
    op.inventory_checked,
    op.processed_date,

    pk.package_type,
    pk.fragile,
    pk.packed_date,

    lb.tracking_number,
    lb.recipient_address,
    lb.special_notes,

    cs.carrier_name,
    cs.shipping_cost,
    cs.estimated_days,

    st.status            AS shipment_status,
    st.last_updated      AS shipment_last_updated,
    st.location          AS shipment_location,

    d.delivered_date,
    d.delivery_status

FROM base_orders bo
LEFT JOIN customers_cte       c   ON bo.customer_id = c.customer_id
LEFT JOIN order_processing_cte op ON bo.order_id    = op.order_id
LEFT JOIN packaging_cte       pk  ON bo.order_id    = pk.order_id
LEFT JOIN labeling_cte        lb  ON bo.order_id    = lb.order_id
LEFT JOIN carrier_cte         cs  ON bo.order_id    = cs.order_id
LEFT JOIN delivery_cte        d   ON bo.order_id    = d.order_id
LEFT JOIN latest_tracking_cte st  ON lb.tracking_number = st.tracking_number;


-- Dimension view for customers
CREATE OR REPLACE VIEW vw_dim_customers AS
SELECT
    customer_id,
    name,
    email,
    phone
FROM customers
;


-- Dimension view for carriers (unique carrier names)
CREATE OR REPLACE VIEW vw_dim_carriers AS
SELECT DISTINCT
    carrier_name
FROM carrier_selection
;


-- Dimension view for delivery statuses
CREATE OR REPLACE VIEW vw_dim_delivery_status AS
SELECT DISTINCT
    delivery_status
FROM delivery
;


-- Dimension view for packaging types
CREATE OR REPLACE VIEW vw_dim_packaging AS
SELECT DISTINCT
    package_type,
    fragile
FROM packaging
;


-- Dimension view for order channels
CREATE OR REPLACE VIEW vw_dim_channels AS
SELECT DISTINCT
    channel
FROM orders
;

