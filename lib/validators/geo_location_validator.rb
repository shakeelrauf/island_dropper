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
  end
end