module Validators
  class GeoLocationValidator < ActiveModel::Validator
    def validate(record)
      begin
        address = Geokit::Geocoders::GoogleGeocoder.geocode record.address 
        puts address
        record.latitude = address.lat
        record.longitude = address.lng
        if record.country != "Trinidad and Tobago"
          record.errors.add(:address, "Location should be in Trinidad and Tobago")
          return false
        end
        return true
      rescue  => e
        record.errors.add(:address, "not valid")
      end
    end
  end
end