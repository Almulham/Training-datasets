# Database Schema Overview

---

## Logistics

### `carrier_selection`
* **order_id**: A unique identifier for the order, linking it to other tables.
* **carrier_name**: The name of the shipping carrier selected for the order.
* **shipping_cost**: The cost associated with shipping the order.
* **estimated_days**: The estimated number of days for the order to be delivered.

### `customers`
* **customer_id**: A unique identifier for each customer.
* **name**: The full name of the customer.
* **email**: The email address of the customer.
* **phone**: The phone number of the customer.

### `delivery`
* **order_id**: A unique identifier for the order, linking it to other tables.
* **delivered_date**: The date when the order was successfully delivered.
* **delivery_status**: The current status of the delivery (e.g., delivered, in transit, etc.).

### `labeling`
* **order_id**: A unique identifier for the order, linking it to other tables.
* **recipient_address**: The full shipping address of the recipient.
* **tracking_number**: A unique number used to track the shipment.
* **special_notes**: Any special instructions or notes for the delivery.

### `order_processing`
* **order_id**: A unique identifier for the order, linking it to other tables.
* **verified**: A boolean indicating whether the order has been verified.
* **inventory_checked**: A boolean indicating whether the inventory for the order has been checked.
* **processed_date**: The date when the order was processed.

### `orders`
* **order_id**: A unique identifier for each order.
* **customer_id**: A unique identifier for the customer who placed the order.
* **order_date**: The date when the order was placed.
* **channel**: The sales channel through which the order was placed (e.g., website, app, etc.).

### `packaging`
* **order_id**: A unique identifier for the order, linking it to other tables.
* **package_type**: The type of packaging used for the order (e.g., box, envelope, etc.).
* **fragile**: A boolean indicating whether the contents of the package are fragile.
* **packed_date**: The date when the order was packed.

### `shipment_tracking`
* **tracking_number**: A unique number used to track the shipment.
* **status**: The current status of the shipment (e.g., in transit, out for delivery, etc.).
* **last_updated**: The timestamp of the last update to the shipment status.
* **location**: The current location of the shipment.

---

## Oil & Gas

### `drilling_events`
* **well_id**: A unique identifier for the well, linking it to other tables.
* **rig_id**: A unique identifier for the rig used, linking it to the 'rigs' table.
* **event_type**: The type of drilling event (e.g., spud, drilling, completion).
* **start_date**: The start date of the drilling event.
* **end_date**: The end date of the drilling event.

### `equipment_failures`
* **equipment_id**: A unique identifier for the specific piece of equipment that failed.
* **well_id**: A unique identifier for the well where the equipment failure occurred.
* **failure_type**: The type of equipment failure (e.g., pump failure, power loss).
* **failure_date**: The date when the equipment failure occurred.
* **downtime_hrs**: The duration of the downtime in hours resulting from the failure.
* **severity**: The severity level of the failure (e.g., low, medium, high).
* **repair_cost_usd**: The cost of repairing the equipment in US dollars.
* **response_time_hrs**: The time in hours it took to respond to the failure.

### `fields`
* **field_id**: A unique identifier for each oil or gas field.
* **name**: The name of the field.
* **country**: The country where the field is located.
* **region**: The specific region or state where the field is located.
* **discovery_date**: The date when the field was discovered.
* **operator**: The name of the company operating the field.
* **total_reserves_est_bbl**: The estimated total reserves of the field in barrels.
* **development_stage**: The current development stage of the field (e.g., exploration, production).

### `maintenance_logs`
* **well_id**: A unique identifier for the well where maintenance was performed.
* **event_date**: The date of the maintenance event.
* **activity**: A description of the maintenance activity performed.
* **technician**: The name or ID of the technician who performed the maintenance.
* **duration_hrs**: The duration of the maintenance activity in hours.
* **cost_usd**: The cost of the maintenance activity in US dollars.

### `prices`
* **date**: The date for which the prices are recorded.
* **oil_price_usd_bbl**: The price of oil per barrel in US dollars on that date.
* **gas_price_usd_mcf**: The price of natural gas per thousand cubic feet in US dollars on that date.
* **water_disposal_cost_usd_bbl**: The cost of disposing of a barrel of water in US dollars.

### `production_logs`
* **well_id**: A unique identifier for the well where production is logged.
* **date**: The date of the production log entry.
* **oil_bbl**: The volume of oil produced in barrels on that date.
* **gas_mcf**: The volume of gas produced in thousand cubic feet on that date.
* **water_bbl**: The volume of water produced in barrels on that date.
* **choke_size**: The size of the choke used during production.
* **tubing_pressure_psi**: The tubing pressure in pounds per square inch.

### `rigs`
* **rig_id**: A unique identifier for each drilling rig.
* **type**: The type of rig (e.g., land rig, offshore rig).
* **contractor**: The name of the company that owns or operates the rig.
* **capacity_unit**: The unit of measurement for the rig's capacity.
* **capacity**: The capacity of the rig.
* **status**: The current operational status of the rig (e.g., active, idle, maintenance).
* **last_inspection_date**: The date of the last inspection of the rig.

### `sensor_readings`
* **sensor_id**: A unique identifier for the sensor.
* **well_id**: A unique identifier for the well where the sensor is located.
* **timestamp**: The date and time when the sensor reading was taken.
* **pressure_psi**: The pressure reading in pounds per square inch.
* **temperature_c**: The temperature reading in degrees Celsius.
* **vibration_g**: The vibration reading in units of gravitational acceleration.

### `transport_logs`
* **shipment_id**: A unique identifier for the shipment of produced fluids.
* **well_id**: A unique identifier for the well from which the fluids were transported.
* **date**: The date of the shipment.
* **quantity_bbl**: The quantity of fluids shipped in barrels.
* **destination**: The destination of the shipment (e.g., refinery, storage tank).
* **transporter**: The name of the company responsible for the transport.
* **status**: The current status of the shipment (e.g., in transit, delivered).

### `wells`
* **well_id**: A unique identifier for each well.
* **field_id**: A unique identifier for the field to which the well belongs.
* **well_type**: The type of well (e.g., production, injection, exploration).
* **spud_date**: The date drilling commenced on the well.
* **completion_date**: The date drilling was completed and the well was prepared for production.
* **status**: The current operational status of the well (e.g., active, shut-in, abandoned).
* **depth_m**: The total depth of the well in meters.
* **location_lat**: The latitude of the well's location.
* **location_lon**: The longitude of the well's location.

---

## Telecom

### `bills`
* **bill_id**: A unique identifier for each customer bill.
* **subscription_id**: A unique identifier for the customer's subscription, linking the bill to a specific service.
* **bill_date**: The date when the bill was issued.
* **amount_due_usd**: The total amount due for the bill in US dollars.
* **is_paid**: A boolean indicating whether the bill has been paid.
* **payment_date**: The date when the bill was paid, if applicable.

### `customer_subscriptions`
* **subscription_id**: A unique identifier for each customer's subscription.
* **customer_id**: A unique identifier for the customer, linking the subscription to a specific customer.
* **plan_id**: A unique identifier for the plan, linking the subscription to a specific service plan.
* **start_date**: The date when the subscription started.
* **is_active**: A boolean indicating whether the subscription is currently active.

### `customers`
* **customer_id**: A unique identifier for each customer.
* **first_name**: The first name of the customer.
* **last_name**: The last name of the customer.
* **email**: The email address of the customer.
* **signup_date**: The date when the customer signed up for services.
* **city**: The city where the customer resides.

### `plans`
* **plan_id**: A unique identifier for each service plan.
* **plan_name**: The name of the service plan (e.g., "Basic", "Premium").
* **monthly_cost_usd**: The monthly cost of the plan in US dollars.
* **data_gb**: The amount of data included in the plan in gigabytes.
* **voice_minutes**: The number of voice minutes included in the plan.
* **sms_count**: The number of SMS messages included in the plan.

### `usage_details`
* **usage_id**: A unique identifier for each usage event.
* **subscription_id**: A unique identifier for the customer's subscription, linking the usage to a specific service.
* **usage_date**: The date when the usage occurred.
* **usage_type**: The type of usage (e.g., data, voice, SMS).
* **usage_value**: The numerical value of the usage (e.g., 500 for minutes, 1.5 for GB).
* **usage_unit**: The unit of measurement for the usage value (e.g., "minutes", "GB", "SMS").
* **cost_usd**: The cost incurred for this specific usage event in US dollars.