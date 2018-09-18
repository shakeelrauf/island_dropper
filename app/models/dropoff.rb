class Dropoff < ApplicationRecord
  include Geolocation
  belongs_to :delivery
  has_one :driver, dependent: :destroy
  has_one :bill, dependent: :destroy
  def full_name
    "#{self.first_name} " + "#{self.last_name}"
  end
end
