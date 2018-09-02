class Delivery < ApplicationRecord
  include Form
  belongs_to :user
  has_one :pickup, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :dropoffs, dependent: :destroy

  accepts_nested_attributes_for :pickup
  accepts_nested_attributes_for :items
  accepts_nested_attributes_for :dropoffs
  
  attr_accessor :pickup_first_name
  attr_accessor :pickup_last_name
  attr_accessor :pickup_address
  attr_accessor :pickup_phone_number

  cattr_accessor :form_steps do
    %w[pickup dropoff_items]
  end

  attr_accessor :form_step
  
  with_options if: -> { required_for_step?(:pickup) } do |step|
    
  end

end
