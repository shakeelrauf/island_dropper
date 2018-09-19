class Dropoff < ApplicationRecord
  include Geolocation
  belongs_to :delivery
  has_one :driver, dependent: :destroy
  has_one :bill, dependent: :destroy
  belongs_to :user

  def full_name
    "#{self.first_name} " + "#{self.last_name}"
  end


  def self.search_at_reference_no(ref,state)
  	includes(:delivery).where('(reference_no LIKE ? ) AND state IN (?)',"%#{ref}%", state)
  end
end
