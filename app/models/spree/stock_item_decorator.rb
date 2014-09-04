module Spree
  StockItem.class_eval do
    def count_on_hand
      @count_on_hand ||= get_inventory_from_shipwire
    end

    def update_count_on_hand_from_shipwire
      set_count_on_hand get_inventory_from_shipwire
    end

    def get_inventory_from_shipwire
      inventory = Shipwire::Inventory.new({ product_code: self.variant.sku })
      inventory.send
      inventory.parse_response
      inventory.inventory_responses[0][:inventory][:quantity].to_i
    end
  end
end
