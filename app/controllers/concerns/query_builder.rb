module QueryBuilder
  def build_query(dropoff, pickup, items)
    
    query = {
                "apiKey": ENV["GETSWIFT_API_KEY"],
                "booking":{
                    "pickupDetail": {
                        "name": "#{pickup.first_name.to_s }"+ "#{ pickup.last_name.to_s}",
                        "phone": pickup.phone_number,
                        "address": pickup.address
                    },
                    "dropoffDetail": {
                        "name": dropoff.first_name.to_s + dropoff.last_name.to_s,
                        "phone": dropoff.phone_number,
                        "address": dropoff.address
                    }
                }
            }    
    query.to_json        
  end

  def build_cancel_query(delivery_id,note)
    query = {
            "apiKey": ENV["GETSWIFT_API_KEY"],
            "jobId": delivery_id,
            "cancellationNotes": note
            }  

    query.to_json        
  end
end

