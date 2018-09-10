module DeliveryStepsHelper
   def items_price(delivery,items, d)
    price = 0
    kms = 0
    if delivery.priority == true
      items.each do |item|
        item_type = ItemType.where(title: item.size).first
        res = Getswift::Request.find_distance({origin: delivery.pickup.address,destination: d.address,sensor: false })
        if res[0]["error_messag"].present? or res[0]["routes"][0].nil?
          flash[:error] = "Dropoff or pickup locations are not correct"
          return nil
        end
        kms = res[0]["routes"][0]["legs"][0]["distance"]["text"].to_f
        item_price =  (item_type.base_rate.to_f + (item_type.per_km_rate.to_f * kms)) * Priority.first.percentage
        price += item_price
      end
    else
      items.each do |item|
        item_type = ItemType.where(title: item.size).first
        res = Getswift::Request.find_distance({origin: delivery.pickup.address,destination: d.address,sensor: false })
        if res[0]["error_messag"].present? or res[0]["routes"][0].nil?
          flash[:error] = "Dropoff or pickup locations are not correct"
          return nil
        end
        kms = res[0]["routes"][0]["legs"][0]["distance"]["text"].to_f
        item_price = item_type.base_rate.to_f + (item_type.per_km_rate.to_f * kms)
        price += item_price
      end
    end
    return price
  end
end
