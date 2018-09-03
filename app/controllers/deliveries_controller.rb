class DeliveriesController < ApplicationController
 
  def new
    @user = current_user
    render_wizard
    delivery = Getswift::Delivery.add_booking("/api/v2/deliveries", deliveriy_params)
  end

  def draft
    if params[:search].present? and  params[:search][:query].present?
      @deliveries =  current_user.deliveries.draft.search_for(params[:search][:query])
    else
      @deliveries = current_user.deliveries.includes([:pickup,:dropoffs,:items]).where(state: 'draft')
    end
  end

  def create
    @delivery = current_user.deliveries.build
    if @delivery.save
      redirect_to delivery_step_path(@delivery, id: @delivery.first_invalid_step)
    end
  end

  def destroy
    @delivery =  Delivery.where(id: params[:id]).first
    if @delivery.destroy
      redirect_to draft_deliveries_path 
      flash[:success] = "Successfully destroyed!"
    else
      redirect_to draft_deliveries_path 
      flash[:error] = "Cannot destroy!!"
    end
  end
end
