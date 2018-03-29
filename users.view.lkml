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

  dimension: age_tier {
    type: tier
    tiers: [20,30,40,50,60,70,80]
    style: integer
    sql: ${age} ;;
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
    timeframes: [time, date, week, month,raw, day_of_week]
    sql: ${TABLE}.created_at ;;
  }

  dimension: hour_of_day {
    group_label: "Created Date"
    type: date_hour_of_day
    sql:  ${TABLE}.created_at ;;
  }

  dimension: days_as_user {
    type: number
    sql: TIMESTAMPDIFF(DAY, ${created_raw},now()) ;;
  }

  filter: date_group {
    suggestions: ["Date", "Month", "Week", "Day of Week"]
  }

  dimension: dynamic_created_time {
    sql:
      CASE
        WHEN {% parameter date_group %} = 'Date' THEN ${created_date}
        WHEN {% parameter date_group %} = 'Week' THEN ${created_week}
        WHEN {% parameter date_group %} = 'Month' THEN ${created_month}
        WHEN {% parameter date_group %} = 'Day of Week' THEN ${created_day_of_week}
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

  dimension: gender_abbr {
    type: string
    hidden: yes
    sql: ${TABLE}.gender ;;
  }

  dimension: gender {
    type: string
    sql: CASE WHEN ${gender_abbr}='f' THEN 'Female'
              WHEN ${gender_abbr}='m' THEN 'Male'
            ELSE 'Unknown'
        END;;
    order_by_field: gender_order
  }

  dimension: gender_order {
    type: number
    hidden: yes
    sql: CASE WHEN ${gender}= 'Female' THEN 2
              WHEN ${gender}= 'Male' THEN 1
            Else 3
          END;;
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
    map_layer_name: us_states_mine
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

  measure: average_age {
    type: average
    sql: ${age} ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [id, last_name, first_name, events.count, orders.count, user_data.count]
  }
}
