module Getswift
  class delivery < Base
    attr_accessor :pickup_address,
                  :dropout_address

    def self.add_booking(query = {})
      response = Request.where('deliveries', query,"post")
      added_booking = response.fetch('booking', []).map { |b| Booking.new(response: '') }
      [ added_booking, response[:errors] ]
    end
  end
end


a.each do |k,v|
  define_method "#{k}",-> {v.is_a?(Hash) ? v.each{|k1,v1| define_method "#{k1}",-> {return v1}} : v}
end 