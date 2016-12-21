view: orders {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [time, date, week, month, year, month_name,raw]
    sql: ${TABLE}.created_at ;;
  }

  dimension: months_since_signup {
    type: number
    sql: TIMESTAMPDIFF(MONTH,${users.created_raw},${created_raw}) ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: true
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: reporting_period {
    type: string
    sql:
        CASE
          WHEN (year(${created_raw}) = year(CURRENT_DATE)
          AND ${created_raw} <= CURRENT_DATE) THEN 'This Year to Date'
          WHEN (year(${created_raw}) +1 = year(CURRENT_DATE)
          AND DAYOFYEAR(${created_raw})<= DAYOFYEAR(CURRENT_DATE)) THEN 'Last Year to Date'

      END;;
  }
  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [id, users.last_name, users.first_name, users.id, order_items.count, t1.count]
  }
}
