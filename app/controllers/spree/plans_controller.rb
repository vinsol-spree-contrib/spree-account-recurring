module Spree
  class PlansController < StoreController
    def index
      @plans = Spree::Plan.visible.order('id desc')
    end
  end
end