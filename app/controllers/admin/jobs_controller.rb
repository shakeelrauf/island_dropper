class Admin::JobsController < AdminController
   def index
    if params[:search].present?
      @dropoffs = Dropoff.search_at_reference_no(params[:search][:query],['active'])
   
    else
      @dropoffs = Dropoff.includes([:delivery,:user]).where.not('state IN (?)', ['new','draft', 'cancelled','completed'])
    end
  end
end
