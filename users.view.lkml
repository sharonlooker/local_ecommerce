view: users {
  sql_table_name: demo_db.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    type: time
    timeframes: [time, date, week, month,raw]
    sql: ${TABLE}.created_at ;;
  }

  dimension: days_as_user {
    type: number
    sql: TIMESTAMPDIFF(DAY, ${created_raw},now()) ;;
  }

  filter: date_group {
    suggestions: ["Date", "Month", "Week"]
  }

  dimension: dynamic_created_time {
    sql:
      CASE
        WHEN {% parameter date_group %} = 'Date' THEN ${created_date}
        WHEN {% parameter date_group %} = 'Week' THEN ${created_week}
        WHEN {% parameter date_group %} = 'Month' THEN ${created_month}
      END ;;
  }
  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: full_name {
    type:  string
    sql: CONCAT(${first_name}," ", ${last_name}) ;;
  }
  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [id, last_name, first_name, events.count, orders.count, user_data.count]
  }
}
