view: orders {
  sql_table_name: demo_db.orders ;;


  dimension: logo {
    type: string
    sql: 1=1 ;;
    html: <img src="https://assets.pcmag.com/media/images/510734-looker-logo.jpg" width="500" height="500" center/>  ;;
  }
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

### DYNAMIC DATE FILTER ###
  filter: date_filter{
    type: date
  }

  dimension: filter_return {
    type: string
#     hidden: yes
    sql: 1=1 ;;
    html: {{ _filters['orders.date_filter']}} ;;
  }

  dimension_group: filter_start_date {
    type: time
    timeframes: [raw, date]
    sql: CASE WHEN ${filter_return} = 'NULL' THEN TIMESTAMP(0)
          WHEN {% date_start date_filter %} IS NULL THEN '1970-01-01'
          ELSE TIMESTAMP(NULLIF({% date_start date_filter %}, 0))
         END;;
  }

  dimension_group: filter_end_date {
    type: time
    timeframes: [raw, date]
    sql: CASE WHEN ${filter_return} = 'NULL' THEN TIMESTAMP(0)
            WHEN {% date_end date_filter %} IS NULL THEN NOW()
            ELSE TIMESTAMP(NULLIF({% date_end date_filter %}, 0))
         END;;
  }

  dimension: interval {
    type: number
    sql: TIMESTAMPDIFF(second, ${filter_end_date_raw}, ${filter_start_date_raw});;
  }

  dimension: previous_start_date {
    type: date
    sql: DATE_ADD(${filter_start_date_raw}, interval ${interval} second) ;;
  }

  dimension: timeframes {
    suggestions: ["period","previous period"]
    type: string
    sql:
      CASE
        WHEN ${created_raw} BETWEEN ${filter_start_date_raw} AND  ${filter_end_date_raw} THEN "period"
        WHEN ${created_raw} BETWEEN ${previous_start_date} AND ${filter_start_date_raw} THEN "previous Period"
        else "not in time period"
      END ;;
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
