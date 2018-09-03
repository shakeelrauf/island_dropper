class Delivery < ApplicationRecord
  include Form
  belongs_to :user
  has_one :pickup, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :dropoffs, dependent: :destroy
  scoped_search in: :pickup ,on: [:first_name,:last_name, :created_at]
  scope :draft, -> {where(state: "draft")}
  accepts_nested_attributes_for :pickup, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :dropoffs, reject_if: :all_blank, allow_destroy: true
  
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

  def self.pickup_first_name
    self.pickup.first_name
  end
  def self.pickup_last_name
    self.pickup.last_name
  end

end
