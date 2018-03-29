view: inner_query {
  derived_table: {
    sql: select
          {% if user_id._in_query %} users.id as user_id, {% endif %}
          {% if order_id._in_query %} orders.id as order_id, {% endif %}
          count(order_items.id) as total_orders
      from users
      inner join orders on users.id = orders.user_id
      inner join order_items on orders.id = order_items.order_id
      group by 1
       ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: total_orders {
    type: string
    sql: ${TABLE}.total_orders ;;
  }

}

view: outer_query  {
  derived_table: {
    sql:
      select
        {% if order_id._in_query %} count(order_id) as count {% endif %}
        {% if user_id._in_query %} count(user_id) as count {% endif %}
      from ${inner_query.SQL_TABLE_NAME}
        ;;
  }

  dimension: count {
    type: number
  }

}
