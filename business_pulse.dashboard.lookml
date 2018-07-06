- dashboard: business_pulse
  title: Business Pulse
  layout: newspaper
  embed_style:
    background_color: "#f6f8fa"
    show_title: false
    title_color: "#3a4245"
    tile_text_color: "#3a4245"
    text_tile_text_color: ''
  elements:
  - name: New Users Acquired
    title: New Users Acquired
    model: ecommerce
    explore: order_items
    type: single_value
    fields:
    - order_items.first_order_count
    filters:
      order_facts.order_date_date: 90 days
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: goal
      label: Goal
      expression: '8000'
      value_format:
      value_format_name: decimal_0
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: true
    comparison_type: progress_percentage
    comparison_reverse_colors: false
    show_comparison_label: true
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    listen:
      Date: orders.created_date
    row: 0
    col: 0
    width: 6
    height: 5
  - name: Total Sales, Year over Year
    title: Total Sales, Year over Year
    model: ecommerce
    explore: order_items
    type: looker_line
    fields:
    - order_items.sum_sale_price
    - orders.created_month_name
    - orders.created_year
    pivots:
    - orders.created_year
    fill_fields:
    - orders.created_month_name
    - orders.created_year
    sorts:
    - orders.created_year
    - orders.created_month_name
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: custom
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: false
    point_style: none
    interpolation: linear
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    series_types: {}
    y_axis_labels:
    - Total Revenue
    x_axis_label: Month
    discontinuous_nulls: true
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    y_axis_value_format: "$#,##0"
    colors:
    - 'palette: Mixed Pastels'
    series_colors: {}
    row: 5
    col: 0
    width: 12
    height: 8
  - name: Average Order Price
    title: Average Order Price
    model: ecommerce
    explore: order_items
    type: single_value
    fields:
    - order_facts.average_order_price
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    single_value_title: Average Order Price
    listen:
      Date: orders.created_date
    row: 0
    col: 6
    width: 6
    height: 5
  - name: Repeat Purchase Rate
    title: Repeat Purchase Rate
    model: ecommerce
    explore: order_items
    type: single_value
    fields:
    - repeat_purchase_facts.30_day_repeat_purchase_rate
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    single_value_title: Repeat Purchase Rate
    listen:
      Date: orders.created_date
    row: 0
    col: 12
    width: 6
    height: 5
  - name: Orders This Year
    title: Orders This Year
    model: ecommerce
    explore: order_items
    type: single_value
    fields:
    - orders.reporting_period
    - orders.count
    filters:
      orders.reporting_period: "-NULL"
    sorts:
    - orders.reporting_period
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: percent_change
      label: percent change
      expression: "${orders.count}/offset(${orders.count},1)-1"
      value_format:
      value_format_name: percent_0
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    single_value_title: Orders This Year
    row: 0
    col: 18
    width: 6
    height: 5
  - name: Order Item Count by Gender and Age Tier
    title: Order Item Count by Gender and Age Tier
    model: ecommerce
    explore: order_items
    type: looker_donut_multiples
    fields:
    - users.age_tier
    - users.gender
    - order_items.count
    pivots:
    - users.age_tier
    fill_fields:
    - users.age_tier
    sorts:
    - order_items.count desc
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    show_value_labels: true
    font_size: 12
    value_labels: legend
    label_type: labPer
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    series_types: {}
    colors: 'palette: Mixed Pastels'
    series_colors: {}
    listen:
      Date: orders.created_date
    row: 13
    col: 0
    width: 24
    height: 7
  - name: Total Spend by Cohort
    title: Total Spend by Cohort
    model: ecommerce
    explore: order_items
    type: looker_line
    fields:
    - orders.months_since_signup
    - users.created_month
    - order_items.sum_sale_price
    pivots:
    - users.created_month
    fill_fields:
    - users.created_month
    filters:
      users.created_date: 180 days
    sorts:
    - orders.months_since_signup
    - users.created_month desc
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: lifetime_sale_price
      label: Lifetime Sale Price
      expression: |-
        if(
        is_null(${order_items.sum_sale_price})
        ,null
        ,running_total(${order_items.sum_sale_price}))
      value_format:
      value_format_name: usd_0
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: ordinal
    y_axis_scale_mode: linear
    show_null_points: false
    point_style: none
    interpolation: linear
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    series_types: {}
    hidden_fields:
    - order_items.sum_sale_price
    colors:
    - 'palette: Mixed Pastels'
    series_colors: {}
    listen:
      Date: orders.created_date
    row: 5
    col: 12
    width: 12
    height: 8
  - name: Orders by Day and Category
    title: Orders by Day and Category
    model: ecommerce
    explore: order_items
    type: looker_area
    fields:
    - order_items.count
    - products.category
    - orders.created_date
    pivots:
    - products.category
    fill_fields:
    - orders.created_date
    filters:
      products.category: Sweaters,Pants,Blazers & Jackets,Accessories,Fashion Hoodies
        & Sweatshirts,Shorts
    sorts:
    - orders.created_date desc
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    stacking: normal
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: true
    point_style: none
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    series_types: {}
    colors:
    - 'palette: Mixed Pastels'
    series_colors: {}
    listen:
      Date: orders.created_date
    row: 20
    col: 0
    width: 24
    height: 8
  filters:
  - name: Date
    title: Date
    type: field_filter
    default_value: 90 days
    explore: order_items
    field: orders.created_date
    listens_to_filters: []
    allow_multiple_values: true
    required: false
