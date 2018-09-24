class Pickup < ApplicationRecord
  include Geolocation
  belongs_to :delivery

  def full_name
    "#{self.first_name } " + " #{self.last_name}"
  end
  # include Form
  # include CheckField
  # validate do |pickup|
  #   pickup.errors.add(:base, 'An pickup must have a first name.') unless pickup.first_name?
  # end
  # cattr_accessor :form_steps do
  #   %w[pickup dropoff_items]
  # end


  # attr_accessor :form_step

  # with_options if: -> { required_for_step?(:pickup) } do |step|
  # end

end
