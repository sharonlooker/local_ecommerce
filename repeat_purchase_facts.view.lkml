view: repeat_purchase_facts {
  derived_table: {
    sql: SELECT
        orders.order_id,
        orders.created_at as created
        , COUNT(DISTINCT repeat_orders.order_id) AS number_subsequent_orders
        , MIN(repeat_orders.created_at) AS next_order_date
        , MIN(repeat_orders.order_id) AS next_order_id
      FROM
        (select user_id, orders.id as order_id, orders.created_at, sum(sale_price) as amount_spent
        from order_items
        inner join orders
        on order_items.order_id = orders.id
        group by 1,2,3) orders
      LEFT JOIN
        (select user_id, orders.id as order_id, orders.created_at, sum(sale_price) as amount_spent
        from order_items
        inner join orders
        on order_items.order_id = orders.id
        group by 1,2,3) repeat_orders
      ON orders.user_id = repeat_orders.user_id AND orders.created_at < repeat_orders.created_at
      GROUP BY 1,2
       ;;
  }

  measure: count {
    type: count
  }

  dimension: order_id {
    type: number
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension: number_subsequent_orders {
    type: number
    sql: ${TABLE}.number_subsequent_orders ;;
  }

  dimension: has_subsequent_order {
    type: yesno
    sql:${number_subsequent_orders} >0 ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
    timeframes: [date, month, week, year, raw]
    sql: ${TABLE}.next_order_date ;;
  }

  dimension_group: next_order {
    type: time
    timeframes: [date, month, week, year, raw]
    sql: ${TABLE}.next_order_date ;;
  }

  dimension: next_order_id {
    type: number
    sql: ${TABLE}.next_order_id ;;
  }
  dimension: days_until_next_order {
    type: number
    sql: TIMESTAMPDIFF(DAY,${orders.created_raw},${next_order_raw}) ;;
  }

  dimension: repeat_orders_within_30d {
    type: yesno
    sql: ${days_until_next_order} <= 30 ;;
  }

  measure: count_with_repeat_purchase_within_30d {
    type: count
    filters: {
      field: repeat_orders_within_30d
      value: "Yes"
    }
  }

  measure: 30_day_repeat_purchase_rate {
    description: "The percentage of customers who purchase again within 30 days"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${count_with_repeat_purchase_within_30d} / NULLIF(${orders.count},0) ;;
    drill_fields: [products.brand, orders.count, count_with_repeat_purchase_within_30d]
  }
}
