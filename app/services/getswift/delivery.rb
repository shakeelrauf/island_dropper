module Getswift
  class delivery < Base
    attr_accessor :pickup_address,
                  :dropout_address

    def self.add_booking(query = {})
      response = Request.where('deliveries', query)
      added_booking = response.fetch('booking', []).map { |b| Booking.new(response: '') }
      [ added_booking, response[:errors] ]
    end
  end
end