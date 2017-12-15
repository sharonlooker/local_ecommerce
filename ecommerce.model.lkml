connection: "thelook"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore: templated_filter_conditional {}

explore: extend {
  view_name: order_items
  extends: [order_items, orders]
}

explore: order_items {
  access_filter: {
    field: products.brand
    user_attribute: brand
  }
  join: order_facts {
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_items.order_id} = ${order_facts.order_id} ;;
  }
  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
  join: repeat_purchase_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${orders.id} = ${repeat_purchase_facts.order_id};;
  }

  join: currency_conversion {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_currency} = ${currency_conversion.currency} ;;
  }
}

datagroup: utc {
  sql_trigger: select current_date ;;
}

datagroup: est {
  sql_trigger: select date(convert_tz(current_timestamp, 'UTC', 'America/New_York'));;
}

datagroup: china {
  sql_trigger: select date(convert_tz(current_timestamp, 'UTC', 'Asia/Shanghai')) ;;
}
explore: orders {
  description: "Orders for UTC timezone"
  hidden: yes
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
    }
}

explore: orders_est {
  hidden: yes
  description: "Orders for EST timezone"
  extends: [orders]
  view_name: orders
  persist_with: est
}

explore: orders_china {
  hidden: yes
  description: "Orders for CST timezone"
  extends: [orders]
  view_name: orders
  persist_with: china
}

explore: user_data {
  join: users {
    type: left_outer
    sql_on: ${user_data.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: users {}
