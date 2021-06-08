class Api::V1::CustomerSubscriptionController < ApplicationController
  before_action :check_params

  def create
    new_customer_subscription = CustomerSubscription.create(customer_subscription)

    if new_customer_subscription.save
      render json: CustomerSubscriptionSerializer.new(new_customer_subscription), status: :created
    end
  end

  def update
    require "pry"; binding.pry
    # if customer_subscription[:customer_id].present? && customer_subscription[:subscription_id].present?
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
end
