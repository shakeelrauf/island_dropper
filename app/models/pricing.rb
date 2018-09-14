class Pricing < ApplicationRecord
  before_create :confirm_singularity

  def self.instance
    # there will be only one row, and its ID must be '1'
    begin
      find(1)
    rescue ActiveRecord::RecordNotFound
      # slight race condition here, but it will only happen once
      row = Pricing.new
      row.van_small_price,row.car_medium_price,row.car_large_price,row.van_furniture_price,row.car_base_price,row.van_base_price, row.priority_percentage = 0,0,0,0,0,0,0
      row.save!
      row
    end
  end

  def confirm_singularity
    raise Exception.new("There can be only one.") if Pricing.count > 1
  end
end
