module ApplicationHelper
  include FormError
  include DeliveryStepsHelper

  def distance loc1, loc2
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    rm * c # Delta in meters
  end


  def calculate_price(delivery)
    total_price = {}
    items = delivery.items
    delivery.dropoffs.each.with_index do |d,i|
      single_dropoff_price = items_price(delivery,items,d)
      if single_dropoff_price.nil? 
        return nil
      end
      bill = d.bill
      bill.amount = single_dropoff_price
      bill.save
      total_price["#{i+1}"] = single_dropoff_price
    end
    return total_price
  end
end
