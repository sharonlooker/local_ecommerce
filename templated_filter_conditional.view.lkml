view: templated_filter_conditional {
  derived_table: {
    sql: SELECT * FROM demo_db.users
      WHERE
          {% if state_filter._is_filtered == '1=1' %}
          {% condition state_filter %} state {% endcondition %}
          {% else %}
             state = 'Texas'
          {% endif %}
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  filter: state_filter {
    suggest_explore: users
    suggest_dimension: users.state
  }

  dimension: id {
    type: number
    primary_key: yes
    sql: ${TABLE}.id ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension_group: created_at {
    type: time
    sql: ${TABLE}.created_at ;;
  }

  dimension: zip {
    type: number
    sql: ${TABLE}.zip ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  set: detail {
    fields: [
      id,
      email,
      first_name,
      last_name,
      gender,
      created_at_time,
      zip,
      country,
      state,
      city,
      age
    ]
  }
}
