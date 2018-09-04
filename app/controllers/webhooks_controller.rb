class WebhooksController < ActionController::Base
  def job_accept
    if params[:EventName] == "job/accepted"
      delivery = Delivery.where(reference_no: params[:Data][:Job][:JobIdentifier]).first
      if delivery.present?
        driver =  delivery.build_driver(reference_no: params[:Data][:Driver][:Identifier], driver_name: params[:Data][:Driver][:DriverName], driver_location: params[:Data][:Location])
        driver.save
        delivery.update(status: "accepted") 
      end
    end
  end
end
