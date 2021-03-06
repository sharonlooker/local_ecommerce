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

  dimension: hyperlink_test {
    type: string
    html: <a href="https://google.com">https://google.com</a> ;;
    sql: "https://google.com" ;;
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

  filter: days_ago {
    type: string
  }

  dimension: returned_period {
    type: string
    sql: CASE WHEN ${returned_date} = SUBDATE(current_date, cast({% parameter days_ago %} AS decimal)) THEN 'Day This Week'
            WHEN ${returned_date} = SUBDATE(current_date, (cast({% parameter days_ago %} AS decimal) + 7)) THEN 'Same Day Last Week'
            END;;
  }

  dimension: sale_price {
    type: number
#     hidden: yes
    sql: ${TABLE}.sale_price ;;
    value_format: "$#.00;($#.00)"
  }

  filter: select_measure {
    suggestions: ["Item Count", "Average Sale Price", "Total Sale Price"]
    default_value: "Item Count"
  }

  measure: dynamic_measure {
    type: number
#   label: "{{_filters['select_measure']}}"
    sql: CASE
        WHEN {% parameter select_measure %} = 'Item Count' THEN ${count}
        WHEN {% parameter select_measure %} = 'Average Sale Price' THEN ${average_sale_price}
        WHEN {% parameter select_measure %} = 'Total Sale Price' THEN ${sum_sale_price}
        ELSE ${count}
      END
  ;;
  }

  measure: count {
    type: count
    drill_fields: [products.category, products.department, count]
    link: {
      label: "Show by Categroy and Department"
      url: "{{ link }}&pivots=products.department&sorts=order_items.count+desc+0,products.department&limit=500&vis_config=%7B%22stacking%22%3A%22normal%22%2C%22show_value_labels%22%3Afalse%2C%22label_density%22%3A25%2C%22legend_position%22%3A%22center%22%2C%22x_axis_gridlines%22%3Afalse%2C%22y_axis_gridlines%22%3Atrue%2C%22show_view_names%22%3Atrue%2C%22limit_displayed_rows%22%3Afalse%2C%22y_axis_combined%22%3Atrue%2C%22show_y_axis_labels%22%3Atrue%2C%22show_y_axis_ticks%22%3Atrue%2C%22y_axis_tick_density%22%3A%22default%22%2C%22y_axis_tick_density_custom%22%3A5%2C%22show_x_axis_label%22%3Atrue%2C%22show_x_axis_ticks%22%3Atrue%2C%22x_axis_scale%22%3A%22auto%22%2C%22y_axis_scale_mode%22%3A%22linear%22%2C%22ordering%22%3A%22none%22%2C%22show_null_labels%22%3Afalse%2C%22show_totals_labels%22%3Afalse%2C%22show_silhouette%22%3Afalse%2C%22totals_color%22%3A%22%23808080%22%2C%22type%22%3A%22looker_column%22%2C%22show_row_numbers%22%3Atrue%2C%22truncate_column_names%22%3Afalse%2C%22hide_totals%22%3Afalse%2C%22hide_row_totals%22%3Afalse%2C%22table_theme%22%3A%22editable%22%2C%22enable_conditional_formatting%22%3Afalse%2C%22conditional_formatting_include_totals%22%3Afalse%2C%22conditional_formatting_include_nulls%22%3Afalse%2C%22series_types%22%3A%7B%7D%7D"
    }

  }

  measure: average_sale_price {
    type: average
    value_format: "$#.00;($#.00)"
    sql: ${sale_price} ;;
  }

  parameter: sales_budget {
    type: number
  }

  measure: budget {
    type: number
    sql: {% parameter sales_budget %} ;;
    value_format_name: usd
  }
  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: sum_sale_price {
    type: string
    sql: CASE WHEN ${total_sale_price} >= 100 THEN concat((${total_sale_price}/100.0::text), ' TB')
              WHEN ${total_sale_price} >= 10 THEN ${total_sale_price}/10.0
          ELSE ${total_sale_price}
        END
    ;;
    value_format: "$#.00;($#.00)"
  }

  measure: sale_price_div_10 {
    type: number
    value_format: "$#.00;($#.00)"
    sql: ${total_sale_price}/10.0 ;;
  }

  measure: sale_price_div_100 {
    type: number
    value_format: "$#.00;($#.00)"
    sql: ${total_sale_price}/100.0 ;;
  }

  measure: first_order_count {
    type: count_distinct
    sql: ${order_id} ;;
    filters: {
      field: order_facts.is_first_order
      value: "Yes"
    }
  }

############### DYNAMIC CURRENCY FIELDS ##########################
  dimension: user_currency {
    type: string
    sql: '{{ _user_attributes['currency'] }}' ;;
  }

## this is a string, so will need to bring in real total converted price to sort in a table. cannot use for none text type viz
  measure: total_price_string {
    label: "Total Price (Converted to User Currency)"
    group_label: "Currency Conversion (String)"
    type: string
    sql: CASE WHEN ${user_currency} = 'USD' THEN CONCAT('$', FORMAT(${total_price_converted},'2','en-US'))
              WHEN ${user_currency} = 'EURO' THEN CONCAT( '€', FORMAT(${total_price_converted}, '2','DE_DE'))
              WHEN ${user_currency} = 'POUND' THEN CONCAT('£', FORMAT(${total_price_converted},'2','en-GB'))
              WHEN ${user_currency} = 'YUAN' THEN CONCAT('¥',FORMAT(${total_price_converted},'2','zh-Hans'))
              WHEN ${user_currency} = 'YEN' THEN CONCAT('¥', FORMAT(${total_price_converted},'2','ja-JP'))
        END;;
  }

## this is a string, so will need to bring in real total converted price to sort
  measure: average_sale_price_string {
    label: "Average Sale Price (Converted to User Currency)"
    group_label: "Currency Conversion (String)"
    type: string
    sql: CASE WHEN ${user_currency} = 'USD' THEN CONCAT('$', FORMAT(${average_price_converted},'2','en-US'))
              WHEN ${user_currency} = 'EURO' THEN CONCAT( '€', FORMAT(${average_price_converted}, '2','DE_DE'))
              WHEN ${user_currency} = 'POUND' THEN CONCAT('£', FORMAT(${average_price_converted},'2','en-GB'))
              WHEN ${user_currency} = 'YUAN' THEN CONCAT('¥',FORMAT(${average_price_converted},'2','zh-Hans'))
              WHEN ${user_currency} = 'YEN' THEN CONCAT('¥', FORMAT(${average_price_converted},'2','ja-JP'))
        END;;
  }

  measure: total_price_converted {
    type: sum
    # hidden: yes
    sql: ${sale_price} * ${currency_conversion.exchange_rate} ;;
  }

  measure: average_price_converted {
    type: number
    # hidden: yes
    sql:  ${average_sale_price} * ${currency_conversion.exchange_rate} ;;
  }



}
