module Geolocation
  extend ActiveSupport::Concern

  included do
    # include ActiveModel::Validations
    # validates_with Validators::GeoLocationValidator
  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :address,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude
  end
end