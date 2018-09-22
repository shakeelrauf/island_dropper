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

  def build_preorder_query(dropoff, pickup, items,pickup_time)
    query = {
                "apiKey": ENV["GETSWIFT_API_KEY"],
                "booking":{
                    "pickupDetail": {
                        "name": "#{pickup.first_name.to_s }"+ "#{ pickup.last_name.to_s}",
                        "phone": pickup.phone_number,
                        "address": pickup.address
                    },
                    "pickupTime": "#{pickup_time.strftime('%Y-%m-%d %I:%M:%S')}",
                    "dropoffDetail": {
                        "name": dropoff.first_name.to_s + dropoff.last_name.to_s,
                        "phone": dropoff.phone_number,
                        "address": dropoff.address
                    }
                }
            }    

            # ,
            #         "dropoffWindow": {
            #             "earliestTime": "#{early_dropoff_time}",
            #             "latestTime": "#{late_dropoff_time}"
            #         }
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

