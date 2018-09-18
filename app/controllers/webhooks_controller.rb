class WebhooksController < ActionController::Base
  include DriverDetails
  def job_accept
    if params[:EventName] == "job/accepted"
      ref = Dropoff.where(reference_no:  params[:Data][:Job][:JobIdentifier]).first
      if ref.present?
        driver = driver_details(params[:Data][:Driver][:Identifier])
        drive =  ref.build_driver(reference_no: params[:Data][:Driver][:Identifier], driver_name: driver["name"],phone_number: driver["phone"],photo_url: driver["photoUrl"],email:  driver["email"], driver_location: params[:Data][:Location])
        drive.save
        ref.update_attributes(state: "accepted") 
      end
    end
  end
  def job_edited
    if params[:EventName] == "job/edited"
      if params[:Data][:JobIdentifier].present?
        dropoff = Dropoff.where(reference_no: params[:Data][:JobIdentifier] ).first
        if dropoff.present?
          @delivery = dropoff.delivery
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
              dropoff.update(first_name: dropoff_first_name,state: 'edited', last_name: dropoff_last_name, address: dropoff_address, phone_number: dropoff_phone_no)
            end
          end
        end
      end
    end
  end

  def job_cancelled
    if params[:EventName] == "job/cancelled"
      ref = Dropoff.where(reference_no: params[:Data][:JobIdentifier]).first
      ref.update(state: "cancelled")
    end
  end
  def job_closed
    if params[:EventName] == "job/closed"
      ref = Dropoff.where(reference_no: params[:Data][:JobIdentifier]).first
      ref.update(state: "closed")  if delivery.present?
    end
  end
  def job_completed
    if params[:EventName] == "job/finished"
      ref = Dropoff.where(reference_no:  params[:Data][:Job][:JobIdentifier]).first
      delivery = ref.delivery
      if ref.present?
        ref.driver.update(driver_location: params[:Data][:Location])
        location = delivery.locations.build(longitude: params[:Data][:Location][:Longitude],latitude: params[:Data][:Location][:Latitude], when_state: 'completed' )
        location.save
        ref.update(state: "completed")
      end
    end
  end
  def job_driveratpickup
    if params[:EventName] == "job/driveratpickup"
      ref = Dropoff.where(reference_no:  params[:Data][:Job][:JobIdentifier]).first
      delivery = ref.delivery
      if ref.present?
        location = delivery.locations.build(longitude: params[:Data][:Location][:Longitude],latitude: params[:Data][:Location][:Latitude], when_state: 'driveratpickup' )
        location.save
        ref.update(state: "driveratpickup") 
      end
    end
  end
  def job_onway
    if params[:EventName] == "job/onway"
      ref = Dropoff.where(reference_no:  params[:Data][:Job][:JobIdentifier]).first
      delivery = ref.delivery
      if ref.present?
        location = delivery.locations.build(longitude: params[:Data][:Location][:Longitude],latitude: params[:Data][:Location][:Latitude], when_state: 'onway' )
        location.save
        ref.update_attributes(state: "onway")
      end
    end
  end
  def job_driveratdropoff
    if params[:EventName] == "job/driveratdropoff"
      ref = Dropoff.where(reference_no:  params[:Data][:Job][:JobIdentifier]).first
      delivery = ref.delivery
      if ref.present?
        location = delivery.locations.build(longitude: params[:Data][:Location][:Longitude],latitude: params[:Data][:Location][:Latitude], when_state: 'driveratdropoff' )
        location.save
        ref.update(state: "driveratdropoff")
      end
    end
  end
  def job_abandoned
    if params[:EventName] == "job/abandoned"
      ref = Dropoff.where(reference_no:  params[:Data][:JobIdentifier]).first
      ref.update(state: "abandoned")  if ref.present?
    end
  end
end
