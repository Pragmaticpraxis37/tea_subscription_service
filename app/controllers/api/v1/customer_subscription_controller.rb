class Api::V1::CustomerSubscriptionController < ApplicationController
  include Errors
  before_action :check_customer_subscription_exists, only: [:update]
  before_action :check_params, :check_customer_exists, :check_subscription_exists, except: [:show]


  def show
    customer = Customer.find(params[:id])
    subscriptions = customer.subscriptions
    if subscriptions.empty?
      render json: {message: "This customer has no subscriptions."}
    else
      render json: SubscriptionSerializer.new(subscriptions), status: :created
    end
  end

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
end
