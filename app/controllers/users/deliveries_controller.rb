class Users::DeliveriesController < ApplicationController

  def new
    delivery = Getswift::Delivery.add_booking("/api/v2/deliveries", deliveriy_params)
  
  end

  def delivery_params
    params.require(:delivery).permit(:pickup_location, :dropout_location,:size)
  end
end
