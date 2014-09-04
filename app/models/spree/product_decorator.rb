module Spree
  Product.class_eval do
    def update_stock
      stock_items.each(&:update_count_on_hand_from_shipwire)
    end
    handle_asynchronously :update_stock
  end
end
