class Admin::UsersController < AdminController


  def index
    if params[:search].present?
      @users = User.search_for(params[:search][:query]).paginate(:page => params[:page], :per_page => 4)
    else
      @users  = User.all.paginate(:page => params[:page], :per_page => 4)
    end
  end

end
