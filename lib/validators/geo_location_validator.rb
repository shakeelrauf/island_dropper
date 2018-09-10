module Validators
  class GeoLocationValidator < ActiveModel::Validator
    def validate(record)
      begin
        address = Geokit::Geocoders::GoogleGeocoder.geocode record.address 
        puts address
        record.latitude = address.lat
        record.longitude = address.lng
        return true
      rescue  => e
        record.errors.add(:address, "not valid")
      end
    end
  # ruby geo coder
    # def validate2(record)
    #   begin
    #     address = Geocoder.search record.address 
    #     puts address
    #     if address.empty? 
    #       record.errors.add(:address, "not valid")
    #     else
    #       debugger
    #       record.latitude = address.lat
    #       record.longitude = address.lng
    #       return true
    #     end
    #   rescue  => e
    #     record.errors.add(:address, "not valid")
    #   end
    # end
  end
end