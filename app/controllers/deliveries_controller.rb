class DeliveriesController < ApplicationController
 
  include QueryBuilder
  include Payment

  def draft
    if params[:search].present? and  params[:search][:query].present?
      @deliveries =  current_user.deliveries.draft.search_for(params[:search][:query]).paginate(:page => params[:page], :per_page => 10)
    else
      @deliveries = current_user.deliveries.includes([:pickup,:dropoffs,:items]).where(state: 'draft').order(created_at: :desc).paginate(:page => params[:page], :per_page => 10)
    end
  end

  def active
    # query = {"apiKey": ENV["GETSWIFT_API_KEY"],"filter": "Active"}
    # @response = Getswift::Delivery.all_bookings(query)
    if params[:search].present?
      params[:search][:startDate]=nil if !params[:search][:startDate].present? 
      @dropoffs = current_user.dropoffs.search_at_reference_no(params[:search][:query],['new','cancelled','completed']).paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
    else
      @dropoffs = current_user.dropoffs.includes(:delivery).where.not('state IN (?)', ['new','cancelled','completed']).paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
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
        @dropoffs =  current_user.dropoffs.search_between_range(start_date, end_date,['completed','cancelled'],params[:search][:Reference]).paginate(:page => params[:page], :per_page => 10)
      else
        @dropoffs = current_user.dropoffs.search_at_reference_no(params[:search][:Reference],['active','accepted','ownway','abandon']).paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
      end
    else
      @dropoffs = current_user.dropoffs.includes(:delivery).where('state IN (?)', ['cancelled','completed']).paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
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
    @dropoff = Dropoff.where(reference_no: params[:token]).first
    if @dropoff.present? 
      query = build_cancel_query(@dropoff.reference_no,params[:note])
      @d = Getswift::Delivery.cancel_booking(query)
      if @d["message"].present? 
        flash[:success] = @d["message"]
      else
        refund_payment(@dropoff)
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
