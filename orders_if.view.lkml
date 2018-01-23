view: orders_if {
  sql_table_name:
     (select
        {% if order_id._in_query %} id, {% endif %}
         user_id,
        1 as dummy --takes care of trailing comma
      from demo_db.orders
      where {% condition order_id_filter %} id {% endcondition %}
        and {% condition user_id_filter %} user_id {% endcondition %}
      group by
        {% if order_id._in_query %} id, {% endif %}
        user_id,
        dummy
    )
    ;;

  filter: order_id_filter {
    type: string
#     suggest_dimension: order_items_if.id
  }

  filter: user_id_filter {
    type: string
    suggest_dimension: user_id
  }

  dimension: order_id {
    sql: ${TABLE}.id ;;
  }

  dimension: user_id {
    sql: ${TABLE}.user_id ;;
  }
}
