module Getswift
  class Delivery < Base
    attr_accessor :pickup_address,
                  :dropout_address

    def self.add_booking(delivery,query = {})
      response = Request.where('api/v2/deliveries', query,"post")
      if response[:errors].present?
        return response
      else
        delivery.reference_no = response["delivery"]["id"]
        delivery.response = response
        delivery.tracking_url = response["delivery"]["trackingUrls"]["www"]
        delivery.state ='active'
        delivery.pickup.address = response["quote"]["pickup"]["address"]
        dropoff = delivery.dropoffs.first
        dropoff.address = response["quote"]["dropoff"]["address"]
        dropoff.save
        delivery.save
        response
      end
    end

    def self.driver_details(driver_id)
      response = Request.where("api/v2/drivers/#{driver_id}")
      response
    end

    def self.all_bookings(query)
      response = Request.where('api/v2/deliveries',query)
      response
    end

    def self.show_booking(delivery_id)
      response = Request.where("api/v2/deliveries/#{delivery_id}")
      response
    end

    def self.cancel_booking(query={})
      response = Request.where("api/v2/deliveries/cancel",query, "post")
      response
    end
  end
end