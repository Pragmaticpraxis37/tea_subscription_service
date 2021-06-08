require 'rails_helper'

describe 'Cancel customer tea subscription' do
  before :each do
    @customer = create(:customer)
    @subscription = create(:subscription)
    @tea_1 = create(:tea)
    @tea_2 = create(:tea)
    @tea_3 = create(:tea)

    create(:subscription_tea, subscription_id: @subscription.id, tea_id: @tea_1.id)
    create(:subscription_tea, subscription_id: @subscription.id, tea_id: @tea_2.id)
    create(:subscription_tea, subscription_id: @subscription.id, tea_id: @tea_3.id)

    create(:customer_subscription, customer_id: @customer.id, subscription_id: @subscription.id)
  end

  describe 'happy path' do
    xit "cancels a customer's tea subscription and save information in the CustomerSubscription table" do

      customer_subscription_params = ({
        customer_id: @customer.id,
        subscription_id: @subscription.id
        })

      headers = {"CONTENT_TYPE" => "application/json"}

      patch api_v1_customer_subscription_path(@subscription), headers: headers, params: JSON.generate(customer_subscription: customer_subscription_params)

      expect(response).to be_successful
      expect(response.status).to eq(204)

      created_customer_subscription = CustomerSubscription.last

      expect(x).to eq(3)
    end
  end
end
