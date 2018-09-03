class Deliveries::StepsController < ApplicationController
  include Wicked::Wizard

  steps *Delivery.form_steps
  before_action :set_delivery


  def show
    @delivery.build_pickup if (@delivery.pickup == nil) and (step.to_s == "pickup")
    if step.to_s == "dropoff_items"
      @delivery.dropoffs.build  if @delivery.dropoffs.count == 0
      @items = @delivery.items.build if @delivery.items.count == 0
    end
    render_wizard
  end

  def update
    @delivery.update(state: 'draft') if params[:commit] == "draft"
    @delivery.update_attributes(delivery_params)
    render_wizard @delivery
  end

  def save_draft
    @delivery.update_attributes(delivery_params)
    redirect_to root_path
  end

  private

  def delivery_params
    params.require(:delivery).permit(:id, :delivery_id,:make_priority_or_preorder,{pickup_attributes: [:id, :_destroy,:first_name, :last_name, :address,:phone_number], dropoffs_attributes: [:id,:_destroy,:first_name, :last_name,:address,:phone_number,:delivery_instructions], items_attributes: [:id,:size, :description]})
  end

 

  def set_delivery
    @delivery = Delivery.where(id: params[:delivery_id]).first
  end
end