view: order_items {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: true
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: true
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    value_format: "$#.00;($#.00)"
  }

  measure: count {
    type: count
    drill_fields: [id, orders.id, inventory_items.id]
  }

  measure: average_sale_price {
    type: average
    value_format: "$#.00;($#.00)"
    sql: ${sale_price} ;;
  }

  measure: sum_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format: "$#.00;($#.00)"
  }

  measure: first_order_count {
    type: count_distinct
    sql: ${order_id} ;;
    filters: {
      field: order_facts.is_first_order
      value: "Yes"
    }
  }
}