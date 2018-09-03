module ChecksForFields  
  def check_for_calling_getswift(delivery)
    pickup, dropoffs, items = delivery.pickup, delivery.dropoffs, delivery.items
    return true if pickup.present? and
                   check_for_existence(pickup) and
                   dropoffs.count > 0 and 
                   check_for_existence(dropoffs.first) and 
                   items.count > 0 and 
                   check_for_existence(items.first)

    return false
  end
  
  def check_for_existence(model)
    exception_keys = Delivery.exception_keys
    return false if (model.attributes.values.include?(nil) or model.attributes.values.include?(""))
    return true
  end
end