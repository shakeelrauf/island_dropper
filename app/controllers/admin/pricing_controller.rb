class Admin::PricingController < AdminController

  def update
    Pricing.update(pricing_params)
    flash[:notice] = "Price has been updated successfully."
    redirect_to admin_pricing_index_path
  end

  def index
    @pricing = Pricing.instance
  end


  private 
  def pricing_params
    params.require(:pricing).permit(:van_small_price,:car_medium_price,:car_large_price,:van_furniture_price,:car_base_price,:van_base_price,:priority_percentage)
  end
end
