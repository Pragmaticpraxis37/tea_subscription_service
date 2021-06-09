class Api::V1::CustomerSubscriptionController < ApplicationController
  before_action :check_customer_subscription_exists, only: [:update]
  before_action :check_params, :check_customer_exists, :check_subscription_exists

  def create
    new_customer_subscription = CustomerSubscription.create(customer_subscription)

    if new_customer_subscription.save
      render json: CustomerSubscriptionSerializer.new(new_customer_subscription), status: :created
    end
  end

  def update
    subscription = CustomerSubscription.find_by(customer_id: customer_subscription[:customer_id], subscription_id: customer_subscription[:subscription_id])
    cancelled = Subscription.update(subscription.subscription_id, status: "Cancelled")
    render json: SubscriptionSerializer.new(cancelled), status: :created
  end

  private

  def customer_subscription
    params.require(:customer_subscription).permit(:customer_id, :subscription_id)
  end

  def check_params
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
