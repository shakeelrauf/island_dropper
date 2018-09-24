class Admin::JobsController < AdminController
   def index
    if params[:search].present?
      @dropoffs = Dropoff.search_at_reference_no(params[:search][:query],['cancelled','compeleted','abandon']).paginate(:page => params[:page], :per_page => 3)
    else
      @dropoffs = Dropoff.includes([:delivery,:user]).where('state IN (?)', ['active','accepted','onway']).paginate(:page => params[:page], :per_page => 3)
    end
  end
end
