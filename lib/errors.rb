module Errors
  def check_params
    # require "pry"; binding.pry
    if !customer_subscription[:customer_id].present? || !customer_subscription[:subscription_id].present?
      render json: {error: "Please provide both a customer id and a subscription id."}, status: 400
    end
  end

  def check_customer_exists
    if !Customer.exists?(customer_subscription[:customer_id])
      render json: {error: "The customer does not exist."}, status: 400
    end
  end

  def check_subscription_exists
    if !Subscription.exists?(customer_subscription[:subscription_id])
      render json: {error: "The subscription does not exist."}, status: 400
    end
  end

  def check_customer_subscription_exists
    if !CustomerSubscription.exists?(customer_id: customer_subscription[:customer_id], subscription_id: customer_subscription[:subscription_id])
      render json: {error: "The customer does not have this subscription."}, status: 400
    end
  end
end
