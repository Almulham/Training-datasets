-- Create fact table
CREATE TABLE dwh.fact_shipments (
    order_id              VARCHAR(50),
    customer_id           VARCHAR(50),
    customer_name         VARCHAR(50),
    customer_email        VARCHAR(50),
    customer_phone        VARCHAR(50),
    order_date            VARCHAR(50),
    verified              BOOLEAN,
    inventory_checked     BOOLEAN,
    processed_date        VARCHAR(50),
    package_type          VARCHAR(50),
    fragile               BOOLEAN,
    packed_date           VARCHAR(50),
    tracking_number       VARCHAR(50),
    recipient_address     VARCHAR(200),
    special_notes         VARCHAR(50),
    carrier_name          VARCHAR(50),
    shipping_cost         REAL,
    estimated_days        INTEGER,
    shipment_status       VARCHAR(50),
    shipment_last_updated VARCHAR(50),
    shipment_location     VARCHAR(50),
    delivered_date        VARCHAR(50),
    delivery_status       VARCHAR(50)
);

-- Load data into fact table from view
INSERT INTO dwh.fact_shipments (
    order_id,
    customer_id,
    customer_name,
    customer_email,
    customer_phone,
    order_date,
    verified,
    inventory_checked,
    processed_date,
    package_type,
    fragile,
    packed_date,
    tracking_number,
    recipient_address,
    special_notes,
    carrier_name,
    shipping_cost,
    estimated_days,
    shipment_status,
    shipment_last_updated,
    shipment_location,
    delivered_date,
    delivery_status
)
SELECT
    order_id,
    customer_id,
    customer_name,
    customer_email,
    customer_phone,
    order_date,
    verified,
    inventory_checked,
    processed_date,
    package_type,
    fragile,
    packed_date,
    tracking_number,
    recipient_address,
    special_notes,
    carrier_name,
    shipping_cost,
    estimated_days,
    shipment_status,
    shipment_last_updated,
    shipment_location,
    delivered_date,
    delivery_status
FROM training.vw_fact_shipments;

-- Create dim_carriers table
CREATE TABLE dwh.dim_carriers (
    carrier_name VARCHAR(50) PRIMARY KEY
);

-- Insert into dim_carriers
INSERT INTO dwh.dim_carriers
SELECT carrier_name
FROM training.vw_dim_carriers;

-- Create dim_channels table
CREATE TABLE dwh.dim_channels (
    channel VARCHAR(50) PRIMARY KEY
);

-- Insert into dim_channels
INSERT INTO dwh.dim_channels (channel)
SELECT channel
FROM training.vw_dim_channels;

-- Create dim_customers table
CREATE TABLE dwh.dim_customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    name        VARCHAR(50),
    email       VARCHAR(50),
    phone       VARCHAR(50)
);

-- Insert into dim_customers
INSERT INTO dwh.dim_customers (customer_id, name, email, phone)
SELECT customer_id, name, email, phone
FROM training.vw_dim_customers;

-- Create dim_delivery_status table
CREATE TABLE dwh.dim_delivery_status (
    delivery_status VARCHAR(50) PRIMARY KEY
);

-- Insert into dim_delivery_status
INSERT INTO dwh.dim_delivery_status (delivery_status)
SELECT delivery_status
FROM training.vw_dim_delivery_status;

-- Create dim_packaging table
CREATE TABLE dwh.dim_packaging (
    package_type VARCHAR(50) PRIMARY KEY,
    fragile      BOOLEAN
);

-- Insert into dim_packaging, avoid duplicates
INSERT INTO dwh.dim_packaging (package_type, fragile)
SELECT package_type, fragile
FROM training.vw_dim_packaging
ON CONFLICT (package_type) DO NOTHING;

-- Check row counts in dwh schema
SELECT 
    schemaname,
    relname AS table_name,
    n_live_tup AS row_count
FROM pg_stat_user_tables
WHERE schemaname = 'dwh'
ORDER BY row_count DESC;
