class DeliveriesController < ApplicationController
 
  def new
    @user = current_user
    render_wizard
    delivery = Getswift::Delivery.add_booking("/api/v2/deliveries", deliveriy_params)
  end

  def create
    @delivery =  current_user.deliveries.build({})
    if @delivery.save
      redirect_to delivery_step_path(@delivery, id: @delivery.first_invalid_step)
    end
  end
end
