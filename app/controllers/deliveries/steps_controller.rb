class Deliveries::StepsController < ApplicationController
  include Wicked::Wizard
  include ChecksForFields
  include QueryBuilder
  include Payment
  include ApplicationHelper

  steps *Delivery.form_steps
  before_action :set_delivery


  def show
    return redirect_to root_path if @delivery.state == "active"
    if step.to_s == "checkout"
      @calculate_price = calculate_price(@delivery)
      if @calculate_price.nil?
        return redirect_to delivery_step_path(@delivery, id: @delivery.first_invalid_step)
      else
        @delivery.update!(checkout_response: @calculate_price.to_s)
      end
    end
    build_associations!
    render_wizard
  end

  def update
    if step.to_s == "checkout"
      return go_for_payment(params[:delivery][:card_token],@delivery, current_user)
    end
    return redirect_to root_path if @delivery.state == "active"
    if params[:commit] == "Save Draft"
      @delivery.attributes = delivery_params
      @delivery.state = 'draft'
      @delivery.save(validate: false)
      flash[:success] = "Your information has been saved successfully to draft"
      return redirect_to draft_deliveries_path
    end
    if params[:delivery][:pre_order_date].present?
      params[:delivery][:pre_order_date] = DateTime.strptime(params[:delivery][:pre_order_date], '%m/%d/%Y')
    end
    if @delivery.update_attributes(delivery_params)
      if step.to_s == "dropoff_items" and  params[:commit] != "Save Draft"
        if check_for_calling_getswift(@delivery)
          flash[:success] = "Checkout!!"
          return render_wizard @delivery
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
    params.require(:delivery).permit(:id,:card_token, :delivery_id,:priority,:checkout_response,:pre_order,:token,:pre_order_date,{pickup_attributes: [:id, :_destroy,:first_name, :last_name, :address,:phone_number], dropoffs_attributes: [:id,:user_id,:_destroy,:first_name, :last_name,:address,:phone_number,:delivery_instructions], items_attributes: [:id,:size, :description]})
  end

  def response_after_request_to_getswift(response)
    if response[:errors].present?
      flash[:success] = response[:errors][:message]
      return redirect_to delivery_step_path(@delivery, id: @delivery.first_invalid_step)
    else
      flash[:success] = "Checkout!!"
      return render_wizard @delivery
    end
  end

  def set_delivery
    @delivery = current_user.deliveries.includes(:pickup,:dropoffs).where(token: params[:delivery_token]).first
    if @delivery.nil? 
      render_404
    end
  end

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end
end
