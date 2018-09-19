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

  def self.search_between_range(start, end_date , state, ref=nil)
    if ref.present?
      includes(:delivery).where('state IN (?) AND (  created_at BETWEEN ? AND ?) AND (reference_no LIKE ?)', state , start, end_date, "%#{ref}%")
    else
      includes(:delivery).where('state IN (?) AND (  created_at BETWEEN ? AND ?) ', state , start, end_date)
    end
  end
end
