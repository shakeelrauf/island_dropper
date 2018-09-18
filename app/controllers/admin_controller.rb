class AdminController < ApplicationController
  before_action :authorize_user!
  layout 'admin_layout'

  def dashboard
    @deliveries = Delivery.where(state: 'active').count
    @users = User.count
  end

  def data_queryss
    
  end

  def profile
    
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
