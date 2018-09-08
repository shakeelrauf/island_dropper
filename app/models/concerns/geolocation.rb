module Geolocation
  extend ActiveSupport::Concern

  included do
    # include ActiveModel::Validations
    # validates_with Validators::GeoLocationValidator
  end
end