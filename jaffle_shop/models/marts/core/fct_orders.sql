with payments as (
    select * from {{ ref('stg_payments') }}
),
orders as (

    select * from {{ ref ('stg_orders') }}
),

successfull_oders as (
    select
        order_id,
        sum(case when status = 'success' then amount end) as amount

    from payments
    group by 1

),
final as (
    select
    orders.order_id,
    orders.customer_id,
    orders.order_date,
    coalesce(successfull_oders.amount, 0) as amount
from orders 
left join successfull_oders using (order_id)
)
select * from final
