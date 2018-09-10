class ConfirmationsController < Devise::ConfirmationsController
   
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?
    if resource.errors.empty?
      set_flash_message!(:notice, :confirmed)
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      flash[:danger] = "Your account has already been confirmed!"
      redirect_to new_user_session_path
    end
  end
end