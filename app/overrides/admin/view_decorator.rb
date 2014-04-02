Deface::Override.new(
  :virtual_path => "spree/admin/shared/_configuration_menu",
  :name => "add_recurring_tab_to_configuration_sidebar",
  :insert_bottom => "[data-hook='admin_configurations_sidebar_menu']",
  :text => "<%= configurations_sidebar_menu_item Spree.t(:recurrings), admin_recurrings_path %>",
  :disabled => false)

Deface::Override.new(
  :virtual_path => "spree/admin/reports/index",
  :name => "add_subscriptions_reports_index",
  :insert_after => "table.index tbody",
  :text => %q{<tr data-hook='reports_row'>
      <td class='align-center'><%= link_to Spree.t(:subscriptions), admin_subscriptions_url %></td>
      <td style="padding-left:1em">View Recurring Subscriptions</td>
    </tr>
    <tr data-hook='reports_row'>
      <td class='align-center'><%= link_to Spree.t(:subscription_events), admin_subscription_events_url %></td>
      <td style="padding-left:1em">View Recurring Subscription Events</td>
    </tr>},
  :disabled => false)

Deface::Override.new(
  :virtual_path => "spree/admin/shared/_tabs",
  :name => "select_reports_when_subscriptions",
  :replace => %q{erb[loud]:contains("tab :reports, :icon => 'icon-file'")},
  :text => %q{<%= tab :reports, :subscriptions, :icon => 'icon-file'%>},
  :disabled => false)