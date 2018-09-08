class Dropoff < ApplicationRecord
  include Geolocation
  belongs_to :delivery
end
