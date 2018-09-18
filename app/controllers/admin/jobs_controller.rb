class Admin::JobsController < AdminController
   def index
    if params[:search].present?
      @deliveries = Delivery.created_at_search(params[:search][:query],['active'])
   
    else
      @deliveries = Delivery.includes([:pickup,:dropoffs, :user]).where.not('state IN (?)', ['new','draft', 'cancelled'])
    end
  end
end
