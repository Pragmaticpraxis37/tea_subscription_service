class Api::V1::CustomerSubscriptionController < ApplicationController

  def create
    new_customer_subscription = CustomerSubscription.create(customer_subscription)

    if new_customer_subscription.save
      render json: CustomerSubscriptionSerializer.new(new_customer_subscription), status: :created
    end
  end

  def delete

  end

  private

  def customer_subscription
    params.require(:customer_subscription).permit(:customer_id, :subscription_id)
  end

end
