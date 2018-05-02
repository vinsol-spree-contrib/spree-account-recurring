Deface::Override.new(virtual_path: 'spree/shared/_sidebar',
  name: 'add_plans_button_to_sidebar',
  insert_bottom: '#sidebar',
  text: "<div class='list-group'>
        <%= link_to Spree.t('view_subscription_plan'), plans_path, class: 'list-group-item' %>
        </div>"
)