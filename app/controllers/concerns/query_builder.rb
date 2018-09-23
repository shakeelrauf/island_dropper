module QueryBuilder
  def build_query(dropoff, pickup, items)

    items_r = resonse_items(items)
    query = {
                "apiKey": ENV["GETSWIFT_API_KEY"],
                "booking":{
                    "pickupDetail": {
                        "name": "#{pickup.first_name.to_s } "+ "#{ pickup.last_name.to_s}",
                        "phone": pickup.phone_number,
                        "address": pickup.address
                    },
                    "dropoffDetail": {
                        "name": dropoff.first_name.to_s + dropoff.last_name.to_s,
                        "phone": dropoff.phone_number,
                        "address": dropoff.address
                    }, 
                    "items": items_r
                }
            }    
    query.to_json        
  end

  def build_preorder_query(dropoff, pickup, items,pickup_time)
    items_r = resonse_items(items)
    query = {
                "apiKey": ENV["GETSWIFT_API_KEY"],
                "booking":{
                    "pickupDetail": {
                        "name": "#{pickup.first_name.to_s } "+ "#{ pickup.last_name.to_s}",
                        "phone": pickup.phone_number,
                        "address": pickup.address
                    },
                    "pickupTime": "#{pickup_time.strftime('%Y-%m-%d %I:%M:%S')}",
                    "dropoffDetail": {
                        "name": dropoff.first_name.to_s + dropoff.last_name.to_s,
                        "phone": dropoff.phone_number,
                        "address": dropoff.address
                    }, 
                    "items": items_r
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

  def resonse_items(items)
    array = []
    items.each do |i|
      if i.size == 'm' 
        array.push({"description": "medium car Description: #{i.description}" })
      elsif i.size == 'l'
        array.push({"description": "large car Description: #{i.description}" })
      elsif i.size == 's'
        array.push({"description": "small van Description: #{i.description}" })
      elsif i.size == 'f'
        array.push({"description": "fortunite van Description: #{i.description}" })
      end
    end
    array
  end
end

