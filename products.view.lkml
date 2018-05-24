view: products {
  sql_table_name: demo_db.products ;;

  filter: with_category{
    sql: EXISTS (
        select distinct u.id
        FROM public.users u
        left join public.order_items oi on u.id=oi.user_id
        left join public.inventory_items ii on oi.inventory_item_id = ii.id
        WHERE u.id = users.id
        AND {% condition with_category %} ii.product_category {% endcondition%} )
       ;;
  }

  filter: without_category {
    sql: NOT EXISTS (
      select distinct u.id
        FROM public.users u
        left join public.order_items oi on u.id=oi.user_id
        left join public.inventory_items ii on oi.inventory_item_id = ii.id
        WHERE u.id = users.id
        AND {% condition without_category %} ii.product_category {% endcondition%}
        AND {% condition another_filter %} ii.department {% endcondition%} )
      ;;
  }

  filter: another_filter {
    type: string
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    link: {
      label: "google brand"
      url: "https://www.google.com/search?source={{value | uri_encode }}"
    }

    link: {
      label: "google department"
      url: "https://www.google.com/search?source={{department._value}}"
    }
  }

  dimension: image {
    type: string
    html: <a href="/dashboards/4?Category={{category._value | uri_encode }}&Brand={{ _filters["products.brand"] | uri_encode }}">
          <img src="https://i.ytimg.com/vi/4f3mux0q7oY/maxresdefault.jpg" height = '100'/></a>
         ;;
    sql: 1=1;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  filter: stack_by {
    suggestions: ["Category", "Brand", "Department"]
  }

  dimension: stack_by_dimension{
    type: string
    sql: CASE WHEN {% parameter stack_by %} = 'Category' THEN ${category}
              WHEN {% parameter stack_by %} = 'Brand' THEN ${brand}
              WHEN {% parameter stack_by %} = 'Department' THEN ${department}
            ELSE ${category}
          END
    ;;
    link: {
      url: "/dashboards/6?Stack%20by%20Field=Category
      &{{ _filters['products.stack_by'] }}={{ value | url_encode }}
      &Category={{ _filters['products.category'] }}
      &Brand={{ _filters['products.brand'] }}
      &Department={{ _filters['products.department'] }}"
      label: "See Stacked by Category, for just {{value}}"
    }

    link: {
      url: "/dashboards/6?Stack%20by%20Field=Brand
      &{{ _filters['products.stack_by'] }}={{ value | url_encode }}
      &Category={{ _filters['products.category'] }}
      &Brand={{ _filters['products.brand'] }}
      &Department={{ _filters['products.department'] }}"
      label: "See Stacked by Brand, for just {{value}}"
    }

    link: {
      url: "/dashboards/6?Stack%20by%20Field=Department
      &{{ _filters['products.stack_by'] }}={{ value | url_encode }}
      &Category={{ _filters['products.category'] }}
      &Brand={{ _filters['products.brand'] }}
      &Department={{ _filters['products.department'] }}"
      label: "See Stacked by Department, for just {{value}}"
    }
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
