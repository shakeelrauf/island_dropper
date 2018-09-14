class Admin::JobsController < AdminController
   def index
    if params[:search].present?
      @deliveries = Delivery.includes([:pickup,:dropoffs, :user]).where.not('state IN (?)', ['new','draft']).search_for_reference(params[:search][:query])
    else
      @deliveries = Delivery.includes([:pickup,:dropoffs, :user]).where.not('state IN (?)', ['new','draft'])
    end
  end
end
