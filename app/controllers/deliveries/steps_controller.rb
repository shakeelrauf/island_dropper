class Deliveries::StepsController < ApplicationController
  include Wicked::Wizard
  include ChecksForFields
  include QueryBuilder

  steps *Delivery.form_steps
  before_action :set_delivery


  def show
    return redirect_to root_path if @delivery.state == "active"
    build_associations!
    render_wizard
  end

  def update
    return redirect_to root_path if @delivery.state == "active"
    if params[:commit] == "Save Draft"
      @delivery.attributes = delivery_params
      @delivery.state = 'draft'
      @delivery.save(validate: false)
      return redirect_to draft_deliveries_path
    end
    if @delivery.update_attributes(delivery_params)
      if step.to_s == "dropoff_items" and  params[:commit] != "Save Draft"
        if check_for_calling_getswift(@delivery)
          query = build_query(@delivery)
          response = Getswift::Delivery.add_booking(@delivery,query)
          flash[:success] = "Succesfully sent"
          return redirect_to root_path
        else
          flash[:error] = "Reuest failed!! Complete the form."
          return redirect_to delivery_step_path(@delivery, id: @delivery.first_invalid_step)
        end
      end
    else
      build_associations!
    end
    render_wizard @delivery
  end

  def save_draft
    @delivery.update_attributes(delivery_params)
    redirect_to root_path
  end

  private

  def parse_pre_order_date
    delivery_params[:pre_order_date] = Date.strptime(delivery_params[:pre_order_date], "%m/%d/%y") if delivery_params[:pre_order_date].present?
  end
  def delivery_params
    params.require(:delivery).permit(:id, :delivery_id,:make_priority_or_preorder,:pre_order_date,{pickup_attributes: [:id, :_destroy,:first_name, :last_name, :address,:phone_number], dropoffs_attributes: [:id,:_destroy,:first_name, :last_name,:address,:phone_number,:delivery_instructions], items_attributes: [:id,:size, :description]})
  end

  def set_delivery
    @delivery = Delivery.where(id: params[:delivery_id]).first
  end
end
