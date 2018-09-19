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
      @dropoffs = current_user.dropoffs.search_at_reference_no(params[:search][:query],['active','accepted']).order(created_at: :desc)
    else
      @dropoffs = current_user.dropoffs.includes(:delivery).where('state IN (?)', ['active','accepted']).order(created_at: :desc)
    end
    render 'active2'
  end

  def past
    if params[:search].present?
      if params[:search][:startDate].present? and params[:search][:endDate].present?
        if params[:search][:startDate].present?
          start_date = Date.new(params[:search][:startDate].split('/').last.to_i,params[:search][:startDate].split('/').first.to_i,params[:search][:startDate].split('/').second.to_i) 
        else
          start_date = Date.today
        end   
        if params[:search][:endDate].present?
          end_date = Date.new(params[:search][:endDate].split('/').last.to_i,params[:search][:endDate].split('/').first.to_i,params[:search][:endDate].split('/').second.to_i) 
        else
          end_date =  Date.today
        end
        @dropoffs =  Dropoff.search_between_range(start_date, end_date,['completed','cancelled','accepted','onway'],params[:search][:Reference])
      else
        @dropoffs = current_user.dropoffs.search_at_reference_no(params[:search][:Reference],['completed','cancelled','accepted','onway']).order(created_at: :desc)
      end
    else
      @dropoffs = current_user.dropoffs.includes(:delivery).where('state IN (?)', ['cancelled','completed','accepted','onway','abandoned','closed']).order(created_at: :desc)
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
    @dropoff = Dropoff.where(reference_no: params[:id]).first
    if @dropoff.present? 
      query = build_cancel_query(@dropoff.reference_no,params[:note])
      @d = Getswift::Delivery.cancel_booking(query)
      if @d["message"].present? 
        flash[:success] = @d["message"]
      else
        refund_money(@dropoff)
        @dropoff.update(state: "cancelled")
        flash[:success] = @d["message"]
      end
    end
    redirect_to active_deliveries_path
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
