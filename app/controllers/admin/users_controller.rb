class Admin::UsersController < AdminController


  def index
    if params[:search].present?
      @users = User.search_for(params[:search][:query])
    else
      @users  = User.all
    end
  end

end
