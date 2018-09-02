class Users::DeliveriesController < ApplicationController
  include Wikced::Wizard
  steps :dropoff_items

  def new
    @user = current_user
    render_wizard
    delivery = Getswift::Delivery.add_booking("/api/v2/deliveries", deliveriy_params)
  end

  def create
    @delivery =  current_user.create_delivery!
    redirect_to delivery_step_path(@delivery, id: @delivery.first_invalid_step)
  end

  def show
    @user = current_user
    @delivery = @user.deliveries.build
    render_wizard
  end

  def update
    @user = current_user
    @delivery.attributes = params[:delivery]
    render_wizard @user
  end

  def delivery_params
    params.require(:delivery).permit(:pickup_location, :dropout_location,:size)
  end
end
