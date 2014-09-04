module Spree
  ProductsController.class_eval do
    def show
      @variants = @product.variants_including_master.active(current_currency).includes([:option_values, :images])
      @product_properties = @product.product_properties.includes(:property)
      @taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
      update_stock @variants
    end

    private

    def update_stock variants
      variants.delay.each do |variant|
        variant.stock_items.each do |stock_item|
          stock_item.update_count_on_hand_from_shipwire
        end
      end
    end
    handle_asynchronously :update_stock

  end
end
