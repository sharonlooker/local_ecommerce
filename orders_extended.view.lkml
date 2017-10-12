include: "orders.view.lkml"
view: orders_extended {
  extends: [orders]

filter: date_filter {
  type: date
}

}
