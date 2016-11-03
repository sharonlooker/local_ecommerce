view: user_order_facts {
  derived_table: {
    sql: SELECT
        users.id as user_id
        , COUNT(DISTINCT orders.id) AS lifetime_orders
        , SUM(sale_price) AS lifetime_revenue
        , MIN(NULLIF(orders.created_at,0)) AS first_order
        , MAX(NULLIF(orders.created_at,0)) AS latest_order
        , COUNT(DISTINCT Month(NULLIF(orders.created_at,0))) AS number_of_distinct_months_with_orders
FROM users
left join orders
on orders.user_id = users.id
left join order_items
on orders.id = order_items.order_id
GROUP BY user_id
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order {
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: latest_order {
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.latest_order ;;
  }

  dimension: days_as_customer {
    description: "Days between first and latest order"
    type: number
    sql: DATEDIFF('day', ${first_order_date}, ${latest_order_date})+1 ;;
  }

  dimension: days_as_customer_tiered {
    type: tier
    tiers: [0, 1, 7, 14, 21, 28, 30, 60, 90, 120]
    sql: ${days_as_customer} ;;
    style: integer
  }

  dimension: number_of_distinct_months_with_orders {
    type: number
    sql: ${TABLE}.number_of_distinct_months_with_orders ;;
  }

  measure: average_lifetime_value {
    type: average
    sql: ${lifetime_revenue} ;;
  }

  set: detail {
    fields: [user_id, lifetime_orders, lifetime_revenue, first_order_date, latest_order_date, number_of_distinct_months_with_orders]
  }
}
