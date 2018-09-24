class Delivery < ApplicationRecord
  include Form
  include CheckFields
  before_create :generate_token
  
  belongs_to :user
  has_one  :pickup,   dependent: :destroy
  has_many :items,    dependent: :destroy
  has_many :dropoffs, dependent: :destroy
  has_one  :driver,   dependent: :destroy
  has_many  :locations,   dependent: :destroy
  validates :pre_order_date,presence: true, if: "pre_order"
  scoped_search in: :pickup ,on: [:first_name,:last_name, :created_at]
  attr_accessor :card_token
  scope :draft,  -> {where(state: "draft")}
  scope :active, -> {where(state: "active")}
  scope :past,   -> {where(state: "past")}
  scope :search_with_reference_and_created_at, -> (start_date=nil,end_date=nil,reference_no=nil) {where("( created_at > ? OR created_at < ?) OR reference_no LIKE '%?%' ",start_date,end_date, reference_no)}

  accepts_nested_attributes_for :pickup,    reject_if: :all_blank,   allow_destroy: true
  accepts_nested_attributes_for :items,     reject_if: :all_blank,   allow_destroy: true
  accepts_nested_attributes_for :dropoffs,  reject_if: :all_blank,   allow_destroy: true
  
  cattr_accessor :form_steps do
    %w[pickup dropoff_items checkout]
  end

  def to_param
    token  
  end

  def time_diff(start_time, end_time)
    seconds_diff = (start_time - end_time).to_i.abs
    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600
    minutes = seconds_diff / 60
    seconds_diff -= minutes * 60
    seconds = seconds_diff
    hours.to_s.rjust(2, '0')
  end

  def run_at()
    unless check_time_date(time)
      DeliveryToGetswift.perform_at(time, delivery_id)
    end
  end

  def self.check_time_date(date_time)
    if date_time.on_weekday? || date_time.saturday?
      if date_time.hour.between?(7,13) || (date_time.hour.to_s == '15' && date_time.min.between?(1..30))
        return true
      else
        return false
      end
    else
      return false 
    end
  end

  attr_accessor :form_step
  
  def self.created_at_search(search, state)
    wildcard_search = "%#{search}%"
    wildcard_search = '%%' if search.gsub(/\s+/, "").empty?
    includes(:dropoffs).references(:dropoffs).where(" ( dropoffs.reference_no LIKE ?) AND dropoffs.state IN (?)",wildcard_search,state)
  end

  # def self.search_for_reference(search, state)
  #   wildcard_search = "#{search}%"
  #   includes(:dropoffs).references(:dropoffs).where(" ( dropoffs.reference_no LIKE ?) AND dropoffs.state IN (?)", wildcard_search,state)
  # end


  def self.pickup_first_name
    self.pickup.first_name
  end
  
  def self.pickup_last_name
    self.pickup.last_name
  end

  def self.exception_keys
    ["response"]
  end


  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Delivery.exists?(token: random_token)
    end
  end
end