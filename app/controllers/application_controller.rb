class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery prepend: true


  def after_sign_in_path_for(resouce)
    if current_user.role == "admin"
      admin_dashboard_path
    elsif current_user.role == "user"
      active_deliveries_path
    end
  end

  def check_for_role(user)
    if !user.roles.present?
      user.role_ids = [Role.where(title: 'user').first.id]
    end
  end  
end

