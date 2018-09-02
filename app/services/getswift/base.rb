module Getswift
  class Base
    attr_accessor :errors

    def initialize(args = {})
      args.each do |name, value|
        attr_name = name.to_s.underscore
        send("#{attr_name}=", value) if respond_to?("#{attr_name}=")
      end
    end
  end
end


{
    "apiKey": "97b7e68c-7114-4f41-972c-e685dd8d9ed8",
    "booking":{
        "pickupDetail": {
            "name": "Rupert",
            "phone": "99999",
            "address": "57 luscombe st, brunswick, melbourne"
        },
        "dropoffDetail": {
            "name": "Igor",
            "phone": "9999",
            "address": "Pakistan"
        }
    }
}            