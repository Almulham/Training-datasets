SELECT *
FROM information_schema.tables
WHERE table_schema = 'training'
  AND table_type = 'BASE TABLE';

--------Source tables

---carrier_selection_logistics -- 1,000,000
---customers_logistics  -- 100,000
---delivery_logistics -- 1,000,000
---labeling_logistics -- 1,000,000
---order_processing_logistics -- 1,000,000
---orders_logistics -- 1,000,000
---packaging_logistics -- 1,000,000
---shipment_tracking_logistics -- 1,000,000


SELECT 'carrier_selection_logistics' AS table_name, COUNT(*) AS row_count FROM carrier_selection_logistics
UNION ALL
SELECT 'customers_logistics', COUNT(*) FROM customers_logistics
UNION ALL
SELECT 'delivery_logistics', COUNT(*) FROM delivery_logistics
UNION ALL
SELECT 'labeling_logistics', COUNT(*) FROM labeling_logistics
UNION ALL
SELECT 'order_processing_logistics', COUNT(*) FROM order_processing_logistics
UNION ALL
SELECT 'orders_logistics', COUNT(*) FROM orders_logistics
UNION ALL
SELECT 'packaging_logistics', COUNT(*) FROM packaging_logistics
UNION ALL
SELECT 'shipment_tracking_logistics', COUNT(*) FROM shipment_tracking_logistics;


--- Order channel dim ---

CREATE VIEW vw_logistics_order_channel_dim AS
SELECT 
  DENSE_RANK() OVER (ORDER BY channel) AS channel_id,
  channel
FROM (
  SELECT DISTINCT channel
  FROM orders_logistics
) AS sub;


--- Customer dim ---

CREATE VIEW vw_logistics_customers_dim AS
select name customer_name,
		email customer_email,
		phone customer_phone
from customers_logistics

------package dim

CREATE VIEW vw_logistics_package_type_dim AS
SELECT 
  DENSE_RANK() OVER (ORDER BY package_type) AS package_type_id,
  package_type
FROM (
  SELECT DISTINCT package_type
  FROM packaging_logistics
) AS sub;


-----carrier_dim

CREATE VIEW vw_logistics_carrier_dim AS
SELECT 
  DENSE_RANK() OVER (ORDER BY carrier_name) AS carrier_id,
  carrier_name
FROM (
  SELECT DISTINCT carrier_name
  FROM carrier_selection_logistics
) AS sub;



select * from carrier_selection_logistics


-----deliver dim


CREATE VIEW vw_logistics_delivery_dim AS
SELECT 
  DENSE_RANK() OVER (ORDER BY delivery_status) AS delivery_status_id,
  delivery_status
FROM (
  SELECT DISTINCT delivery_status
  FROM delivery_logistics
) AS sub;


---Shipment_tracking dim


CREATE VIEW vw_logistics_shipment_status_dim AS
SELECT 
  DENSE_RANK() OVER (ORDER BY status) AS shipment_status_id,
  status
FROM (
  SELECT DISTINCT status
  FROM shipment_tracking_logistics
) AS sub;


---Recepient


---Fact 

CREATE VIEW vw_logistics_shipping_fact AS
select  o.order_id,
		o.customer_id,
		o.order_date,
		oc.channel_id,
		op.verified ::int as order_is_verified,
		op.inventory_checked::int as order_inventory_checked,
		op.processed_date as order_processed_date,
		p.package_type_id,
		p.packed_date,
		p.fragile::int as package_is_fragile,
		c.shipping_cost as carrier_shipping_cost,
		c.carrier_id,
		c.estimated_days as shipping_estimated_days,
		d.delivered_date,
		d.delivery_status_id,
		s.shipment_status_id 
from orders_logistics o
left join vw_logistics_order_channel_dim oc on o.channel = oc.channel
left join order_processing_logistics op on o.order_id = op.order_id
left join (select t.*, vw.package_type_id from packaging_logistics t left join vw_logistics_package_type_dim vw on vw.package_type = t.package_type) p on o.order_id = p.order_id
left join (select c.*, vw.carrier_id from carrier_selection_logistics c left join vw_logistics_carrier_dim vw on vw.carrier_name = c.carrier_name) c on o.order_id = c.order_id
left join (select d.*, vw.delivery_status_id from delivery_logistics d left join vw_logistics_delivery_dim vw on vw.delivery_status = d.delivery_status) d on o.order_id = d.order_id
left join (select s.*, l.*, vw.shipment_status_id from shipment_tracking_logistics s left join labeling_logistics l on l.tracking_number = s.tracking_number left join vw_logistics_shipment_status_dim vw on vw.status = s.status) s on o.order_id = s.order_id
left join labeling_logistics l on o.order_id = l.order_id



SELECT t.*, vw.package_type_id
FROM packaging_logistics t
LEFT JOIN vw_logistics_package_type_dim vw
  ON vw.package_type = t.package_type;

select * from labeling_logistics
select * from labeling_logistics l left join shipment_tracking_logistics s on l.tracking_number = s.tracking_number 

