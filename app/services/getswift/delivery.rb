module Getswift
  class Delivery < Base
    attr_accessor :pickup_address,
                  :dropout_address

    def self.add_booking(delivery,query = {})
      response = Request.where('api/v2/deliveries', query,"post")
      delivery.update(reference_no: response["delivery"]["id"], response: response, state: 'active')
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