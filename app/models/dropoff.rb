class Dropoff < ApplicationRecord
  include Geolocation
  belongs_to :delivery
  def full_name
    "#{self.first_name}" + "#{self.last_name}"
  end
end
