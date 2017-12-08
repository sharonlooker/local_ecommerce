connection: "thelook"

include: "*.view.lkml"         # include all views in this project
  # include all dashboards in this project
include: "ecommerce.model.lkml"
include: "*.dashboard"


explore: order_items_extended {
  view_name: order_items
  extends: [order_items]

    join: products {
      fields: [products.brand]
    }
    join: repeat_purchase_facts {
      fields: []

    }
  }
