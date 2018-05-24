view: order_facts {
  derived_table: {
    sql: SELECT
          order_items.order_id AS order_id
        , orders.created_at as order_date
        , COUNT(*) AS items_in_order
        , SUM(sale_price) AS order_amount
        , SUM(inventory_items.cost) AS order_cost
        , @rank := IF(@same_value= orders.user_id, @rank+1, 1) as order_sequence_number
        , @same_value := orders.user_id as dummy_dnu

      FROM order_items AS order_items
      LEFT JOIN inventory_items AS inventory_items
        ON order_items.inventory_item_id = inventory_items.id
      left join orders
        on order_items.order_id = orders.id
      GROUP BY order_items.order_id, orders.user_id, orders.created_at
      ORDER BY order_id, order_date desc
 ;;
#   indexes: ["order_id", "order_date"]
#   sql_trigger_value: select current_date ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: order_date {
    type: time
    hidden: yes
    sql: ${TABLE}.order_date ;;
  }

  dimension: items_in_order {
    type: number
    sql: ${TABLE}.items_in_order ;;
  }

  dimension: order_amount {
    type: number
    sql: ${TABLE}.order_amount ;;
  }

  dimension: order_cost {
    type: number
    sql: ${TABLE}.order_cost ;;
  }

  dimension: order_sequence_number {
    type: number
    sql: ${TABLE}.order_sequence_number ;;

  }

  dimension: is_first_order {
    type: yesno
    sql: ${order_sequence_number} = "1" ;;
  }

  measure: average_order_price {
    type: average
    sql: ${order_cost} ;;
    value_format: "$#.00"
  }
  set: detail {
    fields: [order_id, order_date_time, items_in_order, order_amount, order_cost, order_sequence_number]
  }
}
