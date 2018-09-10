class RegistrationsController < Devise::RegistrationsController
  before_action :current_user_not_present ,only: [:email_confirmation]
  def create
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?
    if resource.persisted?
      resource.roles <<  Role.where(title: 'user').first
      if resource.confirmed?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        session[:email] = resource.email 
        redirect_to registrations_email_confirmation_path
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def email_confirmation
    render 'users/registrations/email_confirmation'
  end

  private
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
  def after_update_path_for(resource)
    if resource.role == 'admin'
      admin_dashboard_path
    else 
      user_path(resource)
    end
  end

  def current_user_not_present
    if current_user.present?
      redirect_to root_path
    end
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end
end
