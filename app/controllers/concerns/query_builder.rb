module QueryBuilder
  def build_query(delivery)
    pickup, dropoffs, items = delivery.pickup, delivery.dropoffs, delivery.items
    
    query = {
                "apiKey": ENV["GETSWIFT_API_KEY"],
                "booking":{
                    "pickupDetail": {
                        "name": pickup.first_name.to_s + pickup.last_name.to_s,
                        "phone": pickup.phone_number,
                        "address": pickup.address
                    },
                    "dropoffDetail": {
                        "name": dropoffs.first.first_name.to_s + dropoffs.first.last_name.to_s,
                        "phone": dropoffs.first.phone_number,
                        "address": dropoffs.first.address
                    }
                }
            }    
    query.to_json        
  end
end

