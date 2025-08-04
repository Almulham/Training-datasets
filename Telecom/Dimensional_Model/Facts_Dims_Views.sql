
-----Customer dim

create view vw_telecom_customer_dim as
select 
    ct.customer_id,
    ct.first_name, --dim
    ct.last_name,  --dim
    ct.city -- dim
from customers_telecom ct

----Plan dim

create view vw_telecom_plan_dim as
select 
    pt.plan_id,
    pt.plan_name 
from plans_telecom pt

----Usage type dim

create view vw_telecom_usage_type_dim as    
SELECT
    ROW_NUMBER() OVER (ORDER BY udt.usage_type, udt.usage_unit) AS usage_type_id,
    udt.usage_type,
    udt.usage_unit
FROM
    usage_details_telecom udt
GROUP BY
    udt.usage_type,
    udt.usage_unit
    
    
-------Telecom fact

create view vw_telecom_customer_subscription_fact as    
SELECT
    -- Customer Subscription Details (Core Information)
    cst.subscription_id,
    cst.start_date,
    cst.is_active,

    -- Customer Details
    ct.customer_id,
    ct.signup_date,

    -- Plan Details
    pt.plan_id,
    pt.monthly_cost_usd,
    pt.data_gb,
    pt.voice_minutes,
    pt.sms_count,

    -- Bill Details
    bt.bill_id,
    bt.bill_date,
    bt.amount_due_usd,
    bt.is_paid,
    bt.payment_date,

    -- Usage Details
    udt.usage_id,
    udt.usage_date,
    udt.usage_value,
    udt.cost_usd,
	
    -- usage type
    tutd.usage_type_id
FROM
    customer_subscriptions_telecom cst
LEFT JOIN
    customers_telecom ct ON cst.customer_id = ct.customer_id
LEFT JOIN
    plans_telecom pt ON cst.plan_id = pt.plan_id
LEFT JOIN
    bills_telecom bt ON cst.subscription_id = bt.subscription_id
LEFT JOIN
    usage_details_telecom udt ON cst.subscription_id = udt.subscription_id
left join
	training.vw_telecom_usage_type_dim tutd on udt.usage_type = tutd.usage_type;


