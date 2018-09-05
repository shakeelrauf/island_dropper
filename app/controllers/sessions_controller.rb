class SessionsController < Devise::SessionsController

   # POST /resource/sign_in
  def create
    @user =  User.where(email: params[:user][:email]).first
    if @user.present?
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      flash[:error] = "User not found!"
      redirect_to new_user_session_path
    end
  end
end
