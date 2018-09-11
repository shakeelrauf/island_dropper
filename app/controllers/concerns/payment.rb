module Payment

  include QueryBuilder
 
  def go_for_payment(token,delivery,current_user )
    begin
      amount =  eval(delivery.checkout_response).values.inject(:+)
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
      delivery.stripe_transaction_id = charge.id 
      delivery.save
      flash[:success] = "Payment paid!!"
      query = build_query(delivery)
      response = Getswift::Delivery.add_booking(delivery,query)
      return response_after_request_to_getswift(response)
    rescue => e
      flash[:error] = e.message
      return redirect_to delivery_step_path(delivery, id: delivery.first_invalid_step)
    end 
  end
end