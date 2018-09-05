class Delivery < ApplicationRecord
  include Form
  include CheckFields

  belongs_to :user
  has_one  :pickup,   dependent: :destroy
  has_many :items,    dependent: :destroy
  has_many :dropoffs, dependent: :destroy
  has_one  :driver,   dependent: :destroy

  scoped_search in: :pickup ,on: [:first_name,:last_name, :created_at]
  
  scope :draft,  -> {where(state: "draft")}
  scope :active, -> {where(state: "active")}
  scope :past,   -> {where(state: "past")}

  accepts_nested_attributes_for :pickup,    reject_if: :all_blank,   allow_destroy: true
  accepts_nested_attributes_for :items,     reject_if: :all_blank,   allow_destroy: true
  accepts_nested_attributes_for :dropoffs,  reject_if: :all_blank,   allow_destroy: true
  
  cattr_accessor :form_steps do
    %w[pickup dropoff_items]
  end

  attr_accessor :form_step
  
  with_options if: -> { required_for_step?(:pickup) } do |step|
    # step.validate :pickup do |p|
    #   step.errors.add(:base, 'An pickup must have a first name.') unless p.pickup.first_name?
    # end 
    step.validates_inclusion_of :make_priority_or_preorder, :in => ["make-priority", "pre-order"], :message => 'requires an answer'
    with_options if: -> { make_priority_or_preorder == "pre-order" } do |s|
      s.validates :pre_order_date, presence:  true
    end
  end

  def self.pickup_first_name
    self.pickup.first_name
  end
  
  def self.pickup_last_name
    self.pickup.last_name
  end

  def self.exception_keys
    ["response"]
  end

end