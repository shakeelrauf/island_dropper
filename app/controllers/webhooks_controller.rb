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
  def job_edited
    if params[:EventName] == "job/edited"
      if params[:Data][:JobIdentifier].present?
        @delivery = Delivery.where(reference_no: params[:Data][:JobIdentifier]).first
        if @delivery.present?
          @gd = Getswift::Delivery.show_booking(params[:Data][:JobIdentifier])
          pickup = @gd["pickupLocation"]
          dropoff = @gd["dropoffLocation"]
          if pickup.present? && dropoff.present?
            pickup_address = pickup["address"]
            pickup_phone_no = pickup["phone"]
            pic = pickup["name"].split(' ')
            pickup_first_name = pic.first
            pickup_last_name = pic.last
            dropoff_address = dropoff["address"]
            dropoff_phone_no = dropoff["phone"]
            drop = dropoff["name"].split(' ')
            dropoff_first_name = drop.first
            dropoff_last_name = drop.last
            @delivery.pickup.update(first_name: pickup_first_name, last_name: pickup_last_name, address: pickup_address, phone_number: pickup_phone_no)
            @delivery.dropoffs.first.update(first_name: dropoff_first_name, last_name: dropoff_last_name, address: dropoff_address, phone_number: dropoff_phone_no)
          end
        end
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
