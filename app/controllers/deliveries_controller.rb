class DeliveriesController < ApplicationController
 
  include QueryBuilder

  def draft
    if params[:search].present? and  params[:search][:query].present?
      @deliveries =  current_user.deliveries.draft.search_for(params[:search][:query])
    else
      @deliveries = current_user.deliveries.includes([:pickup,:dropoffs,:items]).where(state: 'draft').order(created_at: :desc)
    end
  end

  def active
    # query = {"apiKey": ENV["GETSWIFT_API_KEY"],"filter": "Active"}
    # @response = Getswift::Delivery.all_bookings(query)
    if params[:search].present?
      params[:search][:startDate]=nil if !params[:search][:startDate].present? 
      @deliveries = Delivery.created_at_search(params[:search][:Reference],params[:search][:startDate]).order(created_at: :desc)
    else
      @deliveries = current_user.deliveries.includes([:driver,:pickup, :dropoffs]).where('state IN (?)', ['active','accepted']).order(created_at: :desc)
    end
    render 'active2'
  end

  def past
    # query = {"apiKey": ENV["GETSWIFT_API_KEY"],"filter": 'Successful'}
    # query2 = {"apiKey": ENV["GETSWIFT_API_KEY"],"filter": 'Cancelled'}
    # query[:Reference] = params[:search][:Reference] if params[:search].present? and params[:search][:Reference].present? 
    # query[:startDate] = params[:search][:startDate] if params[:search].present? and params[:search][:startDate].present? 
    # # @response = Getswift::Delivery.all_bookings(query)
    if params[:search].present?
      params[:search][:startDate]=nil if !params[:search][:startDate].present? 
      @deliveries = Delivery.created_at_search(params[:search][:Reference],params[:search][:startDate],['completed','cancelled','accepted','onway']).order(created_at: :desc)
    else
      @deliveries = current_user.deliveries.includes([:driver,:pickup,:dropoffs]).where('state IN (?)', ['cancelled','completed','accepted','onway','abandoned','closed']).order(created_at: :desc)
      #.paginate(:page => params[:page], :per_page => 1)
    end
    # @response2 = Getswift::Delivery.all_bookings(query2)
    # @response = @response.merge(@response2)
    render 'past2'
  end

  def show
    @delivery = Getswift::Delivery.show_booking(params[:id])
  end

  def cancel
    query = build_cancel_query(params[:id],params[:note])
    @delivery = Getswift::Delivery.cancel_booking(query)
    if @delivery["message"].present? 
      flash[:success] = @delivery["message"]
      redirect_to active_deliveries_path
    else
      delivery = Delivery.where(reference_no: params[:id]).first
      delivery.update(state: "cancelled") if delivery.present?
      flash[:success] = @delivery["message"]
      redirect_to active_deliveries_path
    end
  end

  def complete
    delivery = Delivery.where(reference_no: params[:id]).first
    delivery.update(state: "completed") if delivery.present?
  end

  def create
    @delivery = current_user.deliveries.build
    if @delivery.save(validate: false)
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
