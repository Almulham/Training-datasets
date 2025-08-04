


----equipment_failure_type_dim

CREATE VIEW vw_oilgas_equipment_failure_type_dim AS
select eft.equipment_failure_type_desc, eft.equipment_failure_type_id from (SELECT
    failure_type equipment_failure_type_desc,
    DENSE_RANK() OVER (ORDER BY failure_type) AS equipment_failure_type_id
FROM
    equipment_failures_oilgas) eft
group by eft.equipment_failure_type_desc, eft.equipment_failure_type_id;



----equipment_equipment_failure_severity_dim

CREATE VIEW vw_oilgas_equipment_failure_severity_dim AS
select eft.equipment_failure_severity_Desc, eft.equipment_failure_severity_id from (SELECT
    severity equipment_failure_severity_Desc,
    DENSE_RANK() OVER (ORDER BY severity) AS equipment_failure_severity_id
FROM
    equipment_failures_oilgas) eft
group by eft.equipment_failure_severity_Desc, eft.equipment_failure_severity_id;


------shipment_destination_dim


CREATE VIEW vw_oilgas_shipment_destination_dim AS
SELECT
    destination AS shipment_destination_desc,
    DENSE_RANK() OVER (ORDER BY destination) AS shipment_destination_id
FROM
    transport_logs_oilgas
GROUP BY
    destination;


------shipment_transporter_dim
DROP VIEW IF EXISTS vw_oilgas_shipment_transporter_dim;

CREATE VIEW vw_oilgas_shipment_transporter_dim AS
SELECT
    transporter AS shipment_transporter_desc,
    DENSE_RANK() OVER (ORDER BY transporter) AS transporter_id
FROM
    transport_logs_oilgas
GROUP BY
    transporter;

------shipment_status_dim

CREATE VIEW vw_oilgas_shipment_status_dim AS
SELECT
    status AS shipment_status_desc,
    DENSE_RANK() OVER (ORDER BY status) AS shipment_status_id
FROM
    transport_logs_oilgas
GROUP BY
    status;



--------Maintenance_activity_dim
DROP VIEW vw_maintenance_activity_dim CASCADE;
CREATE VIEW vw_oilgas_maintenance_activity_dim AS
select 
	activity maintenance_activity,
	DENSE_RANK() OVER (ORDER BY activity) AS maintenance_activity_id
from maintenance_logs_oilgas mlo 
GROUP BY
    activity

--------Maintenance_technician_dim
DROP VIEW vw_maintenance_technician_dim CASCADE;

CREATE VIEW vw_oilgas_maintenance_technician_dim AS
select 
	technician maintenance_technician_name,
	DENSE_RANK() OVER (ORDER BY technician) AS maintenance_technician_name_id
from maintenance_logs_oilgas mlo
GROUP BY
    technician

    
-------drilling_event_type_dim
DROP VIEW vw_drilling_event_type_dim CASCADE;

CREATE VIEW vw_oilgas_drilling_event_type_dim AS
select 
	event_type drilling_event_type,
	DENSE_RANK() OVER (ORDER BY event_type) AS drilling_event_type_id
from drilling_events_oilgas
GROUP BY
    event_type

    
-----rig_type_dim
    
DROP VIEW vw_rig_type_dim CASCADE;

CREATE VIEW vw_oilgas_rig_type_dim AS  
select 
	type rig_type,
	DENSE_RANK() OVER (ORDER BY type) AS rig_type_id
from rigs_oilgas
GROUP BY
    type

    
-----rig_contractor_dim
    
DROP VIEW vw_rig_contractor_dim CASCADE;

CREATE VIEW vw_oilgas_rig_contractor_dim AS 
select 
	contractor contractor_name,
	DENSE_RANK() OVER (ORDER BY contractor) AS contractor_id
from rigs_oilgas
GROUP BY
    contractor
    
    
-----rig_contractor_dim

    
 DROP VIEW vw_rig_status_dim CASCADE;

CREATE VIEW vw_oilgas_rig_status_dim AS 
select 
	status rig_status,
	DENSE_RANK() OVER (ORDER BY status) AS rig_status_id
from rigs_oilgas
GROUP BY
    status
   
    
----wells_fields_dim
 DROP VIEW vw_wells_fields_dim CASCADE;

CREATE VIEW vw_oilgas_wells_fields_dim AS 
select wo.well_id,
	   wo.field_id,
	   wo.well_type,
	   wo.spud_date,
	   wo.completion_date,
	   wo.status well_status,
	   wo.depth_m,
	   wo.location_lat,
	   wo.location_lon,
	   fo.name field_name,
	   fo.country field_country,
	   fo.region field_region,
	   fo.discovery_date field_discovery_date,
	   fo.operator field_operator,
	   fo.total_reserves_est_bbl field_total_reserves_est_bbl,
	   fo.development_stage field_development_stage
from wells_oilgas wo
left join fields_oilgas fo on wo.field_id = fo.field_id 

 

-----rigs dim 
CREATE VIEW vw_oilgas_rigs_dim AS
select * from rigs_oilgas ro



 -----wells_production_activity_fact  

 DROP VIEW vw_wells_production_activity_fact CASCADE;

CREATE VIEW vw_oilgas_wells_production_activity_fact AS 
select  plo.well_id,
		plo.date production_date,
		plo.oil_bbl production_oil_bbl,
		plo.gas_mcf production_gas_mcf,
		plo.water_bbl production_water_bbl,
		plo.tubing_pressure_psi production_tubing_pressure_psi,
		plo.choke_size production_choke_size,
		tlo.shipment_id transport_shipment_id,
		tlo.quantity_bbl transport_quantity_bbl,
		sdm.shipment_destination_id,
		stm.transporter_id 
from training.production_logs_oilgas plo
left join training.transport_logs_oilgas tlo on plo.well_id = tlo.well_id and plo.date = tlo.date
left join training.vw_oilgas_shipment_destination_dim sdm on tlo.destination = sdm.shipment_destination_desc 
left join training.vw_oilgas_shipment_transporter_dim stm on tlo.transporter = stm.shipment_transporter_desc





-----wells_maintenance_activity_fact

DROP VIEW vw_wells_maintenance_activity_fact CASCADE;

CREATE VIEW vw_oilgas_wells_maintenance_activity_fact AS 
select mlo.well_id,
	   mlo.event_date maintenance_event_date,
	   mad.maintenance_activity_id,
	   mtd.maintenance_technician_name_id,
	   efo.equipment_id equipment_failure_id,
	   efo.downtime_hrs failure_downtime_hrs,
	   efo.repair_cost_usd failure_repair_cost_usd,
	   efo.response_time_hrs failure_response_time_hrs,
	   eftdm.equipment_failure_type_id,
	   efsm.equipment_failure_severity_id
from training.maintenance_logs_oilgas mlo
left join training.vw_oilgas_maintenance_activity_dim mad on mlo.activity = mad.maintenance_activity
left join training.vw_oilgas_maintenance_technician_dim mtd on mlo.technician = mtd.maintenance_technician_name
left join training.equipment_failures_oilgas efo on efo.well_id = mlo.well_id and efo.failure_date = mlo.event_date 
left join training.vw_oilgas_equipment_failure_type_dim eftdm on efo.failure_type = eftdm.equipment_failure_type_desc
left join training.vw_oilgas_equipment_failure_severity_dim efsm on efo.severity = efsm.equipment_failure_severity_Desc


-----daily_sensor_readings_fact

DROP VIEW vw_wells_sensor_readings_fact CASCADE;

CREATE MATERIALIZED VIEW daily_sensor_averages_oilgas AS
select sensor_id, well_id, timestamp::date as date, 
avg(pressure_psi) as avg_pressure_psi,
avg(temperature_c) as avg_temperature_c,
avg(vibration_g) as avg_vibration_g
from sensor_readings_oilgas sro  
group by sensor_id, well_id, timestamp::date;


CREATE VIEW vw_oilgas_wells_sensor_readings_fact AS 
select * 
from daily_sensor_averages_oilgas


-----drilling_fact
DROP VIEW vw_drilling_events_fact CASCADE;

CREATE VIEW vw_oilgas_drilling_events_fact AS 
select deo.well_id,
deo.rig_id,
deo.start_date,
deo.end_date,
detd.drilling_event_type_id,
deo.end_date::date - deo.start_date::date AS Drilling_duration_days
from training.drilling_events_oilgas deo
left join training.vw_oilgas_drilling_event_type_dim detd on deo.event_type = detd.drilling_event_type




    
-----wells activity fact
    
 select * from wells_oilgas wo
    
select * from production_logs_oilgas plo order by date desc
select * from transport_logs_oilgas order by date desc

select  wo.field_id,
		wo.well_id,
		efo.equipment_id,
		efo.failure_date equipment_failure_date,
		efo.downtime_hrs equipment_downtime_hrs,
		efo.repair_cost_usd equipment_repair_cost_usd,
		efo.response_time_hrs equipment_response_time_hrs,
		efo.failure_type_id equipment_failure_type_id,
		efo.severity_id equipment_failure_severity_id,
		tlo.shipment_id,
		tlo.shipment_date,
		tlo.shipmnet_quantity_bbl,
		tlo.shipment_destination_id,
		tlo.transporter_id,
		tlo.shipment_status_id
from wells_oilgas wo
left join (select 
	well_id,
	shipment_id,
	date shipment_date,
	quantity_bbl shipmnet_quantity_bbl,
	DENSE_RANK() OVER (ORDER BY destination) AS shipment_destination_id,
    DENSE_RANK() OVER (ORDER BY transporter) AS transporter_id,
    DENSE_RANK() OVER (ORDER BY status) AS shipment_status_id
from transport_logs_oilgas) tlo on tlo.well_id = wo.well_id 
left join (SELECT
    well_id,
    equipment_id,
    failure_date,
    downtime_hrs,
    repair_cost_usd,
    response_time_hrs,
    failure_type,
    severity,
    DENSE_RANK() OVER (ORDER BY failure_type) AS failure_type_id,
    DENSE_RANK() OVER (ORDER BY severity) AS severity_id
FROM
    equipment_failures_oilgas) efo on efo.well_id = wo.well_id 


    
    
    
select * from production_logs_oilgas plo order by date desc
select * from transport_logs_oilgas order by date desc


select  plo.well_id,
		plo.date production_date,
		plo.oil_bbl production_oil_bbl,
		plo.gas_mcf production_gas_mcf,
		plo.water_bbl production_water_bbl,
		plo.tubing_pressure_psi production_tubing_pressure_psi,
		plo.choke_size production_choke_size,
		tlo.shipment_id transport_shipment_id,
		tlo.quantity_bbl transport_quantity_bbl,
		sdm.shipment_destination_id,
		stm.transporter_id
from training.production_logs_oilgas plo
left join training.transport_logs_oilgas tlo on plo.well_id = tlo.well_id and plo.date = tlo.date
left join training.vw_oilgas_shipment_destination_dim sdm on tlo.destination = sdm.shipment_destination_desc 
left join training.vw_oilgas_shipment_transporter_dim stm on tlo.transporter = stm.shipment_transporter_desc

select mlo.well_id,
	   mlo.event_date maintenance_event_date,
	   mad.maintenance_activity_id,
	   mtd.maintenance_technician_name_id,
	   efo.equipment_id equipment_failure_id,
	   efo.downtime_hrs failure_downtime_hrs,
	   efo.repair_cost_usd failure_repair_cost_usd,
	   efo.response_time_hrs failure_response_time_hrs,
	   eftdm.equipment_failure_type_id,
	   efsm.equipment_failure_severity_id
from training.maintenance_logs_oilgas mlo
left join training.vw_maintenance_activity_dim mad on mlo.activity = mad.maintenance_activity
left join training.vw_maintenance_technician_dim mtd on mlo.technician = mtd.maintenance_technician_name
left join training.equipment_failures_oilgas efo on efo.well_id = mlo.well_id and efo.failure_date = mlo.event_date 
left join training.vw_oilgas_equipment_failure_type_dim eftdm on efo.failure_type = eftdm.equipment_failure_type_desc
left join training.vw_oilgas_equipment_failure_severity_dim efsm on efo.severity = efsm.equipment_failure_severity_Desc


select mlo.*, efo.* 

from maintenance_logs_oilgas mlo
left join equipment_failures_oilgas efo on mlo.well_id = efo.well_id 


select * from maintenance_logs_oilgas

select * from equipment_failures_oilgas

select * from sensor_readings_oilgas


select sensor_id, well_id, timestamp::date as date, 
avg(pressure_psi) as avg_pressure_psi,
avg(temperature_c) as avg_temperature_c,
avg(vibration_g) as avg_vibration_g
from sensor_readings_oilgas sro  
group by sensor_id, well_id, date



CREATE MATERIALIZED VIEW daily_sensor_averages_oilgas AS
select sensor_id, well_id, timestamp::date as date, 
avg(pressure_psi) as avg_pressure_psi,
avg(temperature_c) as avg_temperature_c,
avg(vibration_g) as avg_vibration_g
from sensor_readings_oilgas sro  
group by sensor_id, well_id, timestamp::date;


select  
from daily_sensor_averages_oilgas
