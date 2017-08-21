view: products {
  sql_table_name: demo_db.products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: image {
    type: string
    html: <a href="/dashboards/4?Category={{category._value | uri_encode }}&Brand={{ _filters["products.brand"] | uri_encode }}">
          <img src="https://i.ytimg.com/vi/4f3mux0q7oY/maxresdefault.jpg" height = '100'/></a>
         ;;
    sql: 1=1;;
  }

  dimension: linked_image {
    type: string
    sql: ${image} ;;
    html: {{linked_value}} ;;
    link: {}
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    link: {
      label: "Drill Link"
      url: "http://google.com/?{{ link | encode_uri }}"
    }
    drill_fields: [id, item_name, inventory_items.count]
  }
}
