class Users::DeliveriesController < ApplicationController

  def new
    deliveries, errors = Getswift::Delivery.add_booking("/api/v2/deliveries", deliveriy_params)
    deliveries.save!
  end

  def delivery_params
    params.require(:delivery).permit(:pickup_location, :dropout_location,:size)
  end
end
