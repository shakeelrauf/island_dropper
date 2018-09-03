class DeliveriesController < ApplicationController
 

  def draft
    if params[:search].present? and  params[:search][:query].present?
      @deliveries =  current_user.deliveries.draft.search_for(params[:search][:query])
    else
      @deliveries = current_user.deliveries.includes([:pickup,:dropoffs,:items]).where(state: 'draft')
    end
  end

  def active
    query = {"apiKey": ENV["GETSWIFT_API_KEY"]}
    query[:Reference] = params[:search][:Reference] if params[:search].present? and params[:search][:Reference].present? 
    query[:startDate] = params[:search][:startDate] if params[:search].present? and params[:search][:startDate].present? 
    @response = Getswift::Delivery.all_bookings(query)
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
