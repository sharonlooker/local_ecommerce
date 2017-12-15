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
    sql: 1=1 ;;
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
    hidden: yes
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
