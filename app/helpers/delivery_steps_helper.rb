module DeliveryStepsHelper
   def items_price(delivery,items, d)
    price = 0
    kms = 0
    pricing = Pricing.instance
    if delivery.priority == true
      items.each do |item|
        size = item.size
        base_rate, per_km_rate = size_price(size, pricing)
        res = Getswift::Request.find_distance({origin: delivery.pickup.address,destination: d.address,sensor: false, key: ENV['GEOCODE_API_KEY'] })
        if res[0]["error_messag"].present? or res[0]["routes"][0].nil?
          flash[:error] = res[0]["error_messag"]
          return nil
        end
        kms = res[0]["routes"][0]["legs"][0]["distance"]["text"].to_f
        item_price = (base_rate.to_f + (per_km_rate.to_f * kms)) + (((base_rate.to_f + (per_km_rate.to_f * kms)) * pricing.priority_percentage)/100)
        price += item_price
      end
    else
      items.each do |item|
        size = item.size
        base_rate, per_km_rate = size_price(size, pricing)
        res = Getswift::Request.find_distance({origin: delivery.pickup.address,destination: d.address,sensor: false, key: ENV['GEOCODE_API_KEY'] })
        if res[0]["error_messag"].present? or res[0]["routes"][0].nil?
          flash[:error] = res
          return nil
        end
        kms = res[0]["routes"][0]["legs"][0]["distance"]["text"].to_f
        item_price = base_rate.to_f + (per_km_rate.to_f * kms)
        price += item_price
      end
    end
    return price
  end

  def size_price(size, pricing)
    if size == 's'
      base_rate = pricing.van_base_price
      per_km_rate = pricing.van_small_price
    elsif size == 'f'
      base_rate = pricing.van_base_price
      per_km_rate = pricing.van_furniture_price
    elsif size == 'm'
      base_rate = pricing.car_base_price
      per_km_rate = pricing.car_medium_price
    elsif size == 'l'
      base_rate = pricing.car_base_price
      per_km_rate = pricing.car_large_price
    end
    return [base_rate, per_km_rate]
  end
end
