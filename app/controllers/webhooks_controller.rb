class WebhooksController < ActionController::Base
  include DriverDetails
  def job_accept
    if params[:EventName] == "job/accepted"
      delivery = Delivery.where(reference_no: params[:Data][:Job][:JobIdentifier]).first
      if delivery.present?
        driver = driver_details(params[:Data][:Driver][:Identifier])
        driver =  delivery.build_driver(reference_no: params[:Data][:Driver][:Identifier], driver_name: driver["name"],phone_number: driver["phone"],photo_url: driver["photoUrl"],email:  driver["email"], driver_location: params[:Data][:Location])
        location = delivery.locations.build(longitude: params[:Data][:Location][:Longitude],latitude: params[:Data][:Location][:Latitude], when_state: 'accepted' )
        driver.save
        location.save
        delivery.update_attributes(state: "accepted") 
      end
    end
  end
  def job_cancelled
    if params[:EventName] == "job/cancelled"
      delivery = Delivery.where(reference_no: params[:Data][:JobIdentifier]).first
      delivery.update(state: "cancelled")  if delivery.present?
    end
  end
  def job_closed
    if params[:EventName] == "job/closed"
      delivery = Delivery.where(reference_no: params[:Data][:JobIdentifier]).first
      delivery.update(state: "closed")  if delivery.present?
    end
  end
  def job_completed
    if params[:EventName] == "job/finished"
      delivery = Delivery.where(reference_no: params[:Data][:Job][:JobIdentifier]).first
      delivery.driver.update(driver_location: params[:Data][:Location]) if delivery.driver.present?
      location = delivery.locations.build(longitude: params[:Data][:Location][:Longitude],latitude: params[:Data][:Location][:Latitude], when_state: 'completed' )
      location.save
      delivery.update(state: "completed")  if delivery.present?
    end
  end
  def job_driveratpickup
    if params[:EventName] == "job/driveratpickup"
      delivery = Delivery.where(reference_no: params[:Data][:Job][:JobIdentifier]).first
      location = delivery.locations.build(longitude: params[:Data][:Location][:Longitude],latitude: params[:Data][:Location][:Latitude], when_state: 'driveratpickup' )
      location.save
      delivery.update(state: "driveratpickup")  if delivery.present?
    end
  end
  def job_onway
    if params[:EventName] == "job/onway"
      delivery = Delivery.where(reference_no: params[:Data][:Job][:JobIdentifier]).first
      location = delivery.locations.build(longitude: params[:Data][:Location][:Longitude],latitude: params[:Data][:Location][:Latitude], when_state: 'onway' )
      location.save
      delivery.update_attributes(state: "onway")  if delivery.present?
    end
  end
  def job_driveratdropoff
    if params[:EventName] == "job/driveratdropoff"
      delivery = Delivery.where(reference_no: params[:Data][:Job][:JobIdentifier]).first
      location = delivery.locations.build(longitude: params[:Data][:Location][:Longitude],latitude: params[:Data][:Location][:Latitude], when_state: 'driveratdropoff' )
      location.save
      delivery.update(state: "driveratdropoff")  if delivery.present?
    end
  end
  def job_abandoned
    if params[:EventName] == "job/abandoned"
      delivery = Delivery.where(reference_no: params[:Data][:JobIdentifier]).first
      delivery.update(state: "abandoned")  if delivery.present?
    end
  end

end
