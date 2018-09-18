module Payment

  include QueryBuilder
 
  def go_for_payment(token,delivery,current_user )
    begin
      amount =  eval(delivery.checkout_response).values.inject(:+).to_f
      customer = Stripe::Customer.create(
        :email => current_user.email,
        :source  => token
      )
      charge = Stripe::Charge.create({
        amount: (amount * 100).to_i,
        currency: 'usd',
        customer: customer.id,
        description: "Delivery ID: #{delivery.reference_no}"
      })
      delivery.dropoffs.each do |d|
        bil =  d.bill
        bil.stripe_transaction_id = charge.id 
        bil.save
      end
      if delivery.pre_order == true
        if Delivery.check_time_date(delivery.pre_order_date)
          delivery.processed =  true
          flash[:success] = "Your Delivery has been Placed successfully!"
          delivery.dropoffs.each do |dropoff|
            query = build_query(dropoff,delivery.pickup,delivery.items)
            response = Getswift::Delivery.add_booking(delivery,query,dropoff)
          end
        else
          flash[:success] = "Delivery will be perform in working days."
          DeliveryToGetswift.perform_at(exact_time(delivery.updated_at),delivery.id)
        end
      else
        if Delivery.check_time_date(delivery.updated_at)
          delivery.processed =  true
          flash[:success] = "Payment paid!!"
          delivery.dropoffs.each do |dropoff|
            query = build_query(dropoff,delivery.pickup,delivery.items)
            response = Getswift::Delivery.add_booking(delivery,query,dropoff)
          end
        else
          flash[:success] = "Delivery will be perform in working days."
          DeliveryToGetswift.perform_at(exact_time(delivery.updated_at),delivery.id)
        end
      end
      delivery.save
      return response_after_request_to_getswift(response)
    rescue => e
      flash[:error] = e.message
      return redirect_to delivery_step_path(delivery, id: delivery.first_invalid_step)
    end 
  end

  def exact_time(time)
    if time.saturday?
      return 2.day.from_now.change(hour: 7)
    else
      return 1.day.from_now.change(hour: 7)
    end
  end
end