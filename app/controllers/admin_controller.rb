class AdminController < ApplicationController
  before_action :authorize_user!
  layout 'admin_layout'

  def delivery_jobs
    if params[:search].present?
      @deliveries = Delivery.includes([:pickup,:dropoffs, :user]).where.not(state: 'new').search_for_reference(params[:search][:query])
    else
      @deliveries = Delivery.includes([:pickup,:dropoffs, :user]).where.not(state: 'new')
    end
  end

  def dashboard
    @deliveries = Delivery.where(state: 'active').count
    @users = User.count
  end

  def user_accounts
    if params[:search].present?
      @users = User.search_for(params[:search][:query])
    else
      @users  = User.all
    end
  end

  def pricing
    
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
end
