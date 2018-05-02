Deface::Override.new(
  :virtual_path => "spree/admin/shared/sub_menu/_configuration",
  :name => "add_recurring_tab_to_configuration_sidebar",
  :insert_bottom => "[data-hook='admin_configurations_sidebar_menu']",
  :text => "<%= configurations_sidebar_menu_item Spree.t(:recurrings), admin_recurrings_path %>",
  :disabled => false)

Deface::Override.new(
  :virtual_path => "spree/admin/reports/index",
  :name => "add_subscriptions_reports_index",
  :insert_after => "table.table tbody",
  :text => %q{<tr data-hook='reports_row'>
      <td><%= link_to Spree.t(:subscriptions), admin_subscription_plans_url %></td>
      <td>View Recurring Subscriptions</td>
    </tr>
    <tr data-hook='reports_row'>
      <td><%= link_to Spree.t(:subscription_events), admin_subscription_events_url %></td>
      <td>View Recurring Subscription Events</td>
    </tr>},
  :disabled => false)