class Deliveries::StepsController < ApplicationController
  include Wicked::Wizard

  steps *Delivery.form_steps
  before_action :set_delivery


  def show
    @delivery.build_pickup if (@delivery.pickup == nil) and (step.to_s == "pickup")
    if step.to_s == "dropoff_items"
      @delivery.dropoffs.build 
      @delivery.items.build 
    end
    render_wizard
  end

  def update
    @delivery.update_attributes(delivery_params)
    render_wizard @delivery
  end

  def save_draft
    @delivery.update_attributes(delivery_params)
    redirect_to root_path
  end

  private

  def delivery_params
    params.require(:delivery).permit(:make_priority_or_preorder,pickup_attributes: [:first_name, :last_name, :address,:phone_number], dropoffs_attributes: [:first_name, :last_name,:address,:phone_number,:delivery_instructions], items_attributes: [:size, :description])
  end

  def redirect_to_finish_wizard
    redirect_to root_url, notice: "Thank you for Completing."
  end

  def set_delivery
    @delivery = Delivery.where(id: params[:delivery_id]).first
  end
end
