require 'rails_helper'

describe 'Subscribe customer to tea subscription' do
  before :each do
    @customer_1 = create(:customer)
    @customer_2 = create(:customer)
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

    @subscription_id = @subscription_1.id
    @customer_id = @customer_1.id
  end

  describe 'happy path' do
    it 'subscribes a customer to a tea subscription' do

      customer_subscription_params = ({
        customer_id: @customer_id,
        subscription_id: @subscription_id
        })

      post api_v1_customer_subscription_index_path, params: JSON.generate(customer_subscription: customer_subscription_params)

      expect(response).to be_successful

      created_customer_subscription = CustomerSubscription.last

      expect(created_customer_subscription.customer_id).to eq(@customer_id)
      expect(created_customer_subscription.subscription_id).to eq(@subscription_id)
    end
  end

end
