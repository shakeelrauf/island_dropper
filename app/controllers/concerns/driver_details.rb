module DriverDetails 
  def driver_details(driver_id)
    Getswift::Delivery.driver_details(driver_id)
  end
end