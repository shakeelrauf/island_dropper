class DeliveryToGetswift
  include Sidekiq::Worker
  sidekiq_options retry: false
  include QueryBuilder

  def perform(delivery_id)
    delivery = Delivery.find(delivery_id)
    delivery.dropoffs.each do |dropoff|
      query = build_query(dropoff,delivery.pickup,delivery.items)
      response = Getswift::Delivery.add_booking(delivery,query,dropoff)
    end
    delivery.processed = true
    delivery.save
  end
end