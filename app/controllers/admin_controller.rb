class AdminController < ApplicationController
  before_action :authorize_user!
  layout 'admin_layout'

  def delivery_jobs
    if params[:search].present?
      @deliveries = Delivery.includes([:pickup,:dropoffs, :user]).where.not('state IN (?)', ['new','draft']).search_for_reference(params[:search][:query])
    else
      @deliveries = Delivery.includes([:pickup,:dropoffs, :user]).where.not('state IN (?)', ['new','draft'])
    end
  end

  def dashboard
    @deliveries = Delivery.where(state: 'active').count
    @users = User.count
  end

  def update_pricing
    items = ItemType.all
    s,f,m,l = items.select{|i| i.title=='s'},items.select{|i| i.title=='f'},items.select{|i| i.title=='m'}, items.select{|i| i.title=='l'}
    filter_params(params[:delivery])
    s.first.update(base_rate: params[:delivery][:base_rate_van],per_km_rate: params[:delivery][:small_per_km_van])    
    f.first.update(base_rate: params[:delivery][:base_rate_van],per_km_rate: params[:delivery][:furniture_per_km_van])    
    m.first.update(base_rate: params[:delivery][:base_rate_car],per_km_rate: params[:delivery][:medium_per_km_car])    
    l.first.update(base_rate: params[:delivery][:base_rate_car],per_km_rate: params[:delivery][:large_per_km_car])    
    Priority.instance.update(percentage: params[:delivery][:percentage])
    flash[:notice] = "Updated prices"
    redirect_to admin_pricing_path
  end

  def user_accounts
    if params[:search].present?
      @users = User.search_for(params[:search][:query])
    else
      @users  = User.all
    end
  end

  def pricing
    items = ItemType.all
    @s = items.select{|i| i.title=='s'}
    @f = items.select{|i| i.title=='f'}
    @m = items.select{|i| i.title=='m'}
    @l = items.select{|i| i.title=='l'}
    @p = Priority.instance
  end


  def data_queryss
    
  end

  private
  def authorize_user!
    if current_user 
      if !(current_user.role == "admin")
        flash[:error] = "You are not authorize to access this page"
        redirect_to active_deliveries_path
      end
    end
  end
  def filter_params(delivery)
    if delivery[:base_rate_van].present?
      delivery[:base_rate_van] = delivery[:base_rate_van].to_f
    else
      delivery[:base_rate_van] = 0
    end
    if delivery[:small_per_km_van].present?
      delivery[:small_per_km_van] = delivery[:small_per_km_van].to_f
    else
      delivery[:small_per_km_van] = 0
    end
    if delivery[:furniture_per_km_van].present?
      delivery[:furniture_per_km_van] = delivery[:furniture_per_km_van].to_f
    else
      delivery[:furniture_per_km_van] = 0
    end
    if delivery[:base_rate_car].present?
      delivery[:base_rate_car] = delivery[:base_rate_car].to_f
    else
      delivery[:base_rate_car] = 0
    end
    if delivery[:medium_per_km_car].present?
      delivery[:medium_per_km_car] = delivery[:medium_per_km_car].to_f
    else
      delivery[:medium_per_km_car] = 0
    end
    if delivery[:large_per_km_car].present?
      delivery[:large_per_km_car] = delivery[:large_per_km_car].to_f
    else
      delivery[:large_per_km_car] = 0
    end
    if delivery[:percentage].present?
      delivery[:percentage] = delivery[:percentage].to_f
    else
      delivery[:percentage] = 0
    end

  end
end
