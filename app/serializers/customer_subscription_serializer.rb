class CustomerSubscriptionSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :customer_id, :subscription_id
end
