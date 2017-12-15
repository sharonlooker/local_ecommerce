view: currency_conversion {
  derived_table: {
    sql: select 'USD' as currency, 1.0 as exchange_rate
      UNION
      select 'EURO' as currency, 0.850495 as exchange_rate
      UNION
      select 'POUND' as currency, 0.750670 as exchange_rate
      UNION
      select 'YUAN' as currency, 6.604120 as exchange_rate
      UNION
      select 'YEN' as currency, 112.615000 as exchange_rate
       ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: exchange_rate {
    type: string
    sql: ${TABLE}.exchange_rate ;;
  }

}
