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
      @response = Request.where('api/v2/deliveries',query)
    end
  end
end