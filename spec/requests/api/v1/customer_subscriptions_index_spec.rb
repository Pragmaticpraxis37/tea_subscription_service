require 'rails_helper'

describe "Show all a customer's tea subscriptions" do
  before :each do
    @customer = create(:customer)
    @subscription_1 = create(:subscription)
    @subscription_2 = create(:subscription)
    @tea_1 = create(:tea)
    @tea_2 = create(:tea)
    @tea_3 = create(:tea)
    @tea_4 = create(:tea)
    @tea_5 = create(:tea)
    @tea_6 = create(:tea)

    create(:subscription_tea, subscription_id: @subscription_1.id, tea_id: @tea_1.id)
    create(:subscription_tea, subscription_id: @subscription_1.id, tea_id: @tea_2.id)
    create(:subscription_tea, subscription_id: @subscription_1.id, tea_id: @tea_3.id)

    create(:subscription_tea, subscription_id: @subscription_2.id, tea_id: @tea_4.id)
    create(:subscription_tea, subscription_id: @subscription_2.id, tea_id: @tea_5.id)
    create(:subscription_tea, subscription_id: @subscription_2.id, tea_id: @tea_6.id)

    @customer_subscription_1 = create(:customer_subscription, customer_id: @customer.id, subscription_id: @subscription_1.id)
    @customer_subscription_2 = create(:customer_subscription, customer_id: @customer.id, subscription_id: @subscription_2.id)
    @customer_id = @customer.id
  end

  describe 'happy path' do
    it "show all a customer's tea subscriptions" do
      # customer_subscription_params = ({
      #   customer_id: @customer_id
      #   })
      #
      # headers = {"CONTENT_TYPE" => "application/json"}



      get api_v1_customer_subscription_path(@customer_id)
    end
  end
end

# customer_subscription_params = ({
#   customer_id: @customer_id,
#   subscription_id: @subscription_id
#   })
#
# headers = {"CONTENT_TYPE" => "application/json"}
#
# post api_v1_customer_subscription_index_path, headers: headers, params: JSON.generate(customer_subscription: customer_subscription_params)
