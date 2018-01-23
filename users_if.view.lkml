view: users_if {
  sql_table_name:
    (select
       id,
      {% if average_age._in_query  %} age, {% elsif age._in_query %} age, {% endif %}
      {% if created_date._in_query %} created_at, {% endif %}
      {% if city._in_query %} city, {% endif %}
      --{% if average_age._in_query %} avg(age) as average_age, {% endif %}
     1 as dummy
     from demo_db.users
     where {% condition user_created_filter %} created_at {% endcondition %}
            AND {% condition id_filter %} id {% endcondition %}
            AND {% condition age_filter %} age {% endcondition %}
            AND {% condition city_filter %} city {% endcondition %}
    group by
      id,
      {% if age._in_query %} age, {% endif %}
      {% if created_date._in_query %} created_at, {% endif %}
      {% if city._in_query %} city, {% endif %}
      dummy
    having {% condition average_age_filter %} users_if.average_age {% endcondition %}
    )
    ;;

  filter: user_created_filter {
    type: date
  }

  filter: average_age_filter {
    type: number
  }

  filter: age_filter {
    type: number
    suggest_dimension: age
  }

  filter: city_filter {
    suggest_dimension: users_if.city
  }

  filter: id_filter {
    suggest_dimension: id
  }

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

  dimension_group: created {
    timeframes: [date]
    type: time
    sql: ${TABLE}.created_at ;;
  }

#   dimension: average_age {
#     type: number
#     hidden: yes
#     sql: ${TABLE}.average_age ;;
#   }

  measure: average_age {
    type: average
    sql: ${age} ;;
  }

}
