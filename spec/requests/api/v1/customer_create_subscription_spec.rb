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
    it 'subscribes a customer to a tea subscription and saves the information in the database' do

      customer_subscription_params = ({
        customer_id: @customer_id,
        subscription_id: @subscription_id
        })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_customer_subscription_index_path, headers: headers, params: JSON.generate(customer_subscription: customer_subscription_params)

      created_customer_subscription = CustomerSubscription.last

      expect(created_customer_subscription.customer_id).to eq(@customer_id)
      expect(created_customer_subscription.subscription_id).to eq(@subscription_id)
      expect(created_customer_subscription.customer_id).to_not eq(@customer_2.id)
      expect(created_customer_subscription.customer_id).to_not eq(@subscription_2.id)

      subscription_tea_ids = [@tea_1.id, @tea_2.id, @tea_3.id]
      non_subscription_tea_ids = [@tea_4.id, @tea_5.id, @tea_6.id]

      customer_subscribed_tea_ids = created_customer_subscription.subscription.teas.map do |tea|
        tea.id
      end

      expect(customer_subscribed_tea_ids).to eq(subscription_tea_ids)
      expect(customer_subscribed_tea_ids).to_not eq(non_subscription_tea_ids)
    end

    it 'subscribes a customer to a tea subscription and returns a payload of JSON data' do

      customer_subscription_params = ({
        customer_id: @customer_id,
        subscription_id: @subscription_id
        })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_customer_subscription_index_path, headers: headers, params: JSON.generate(customer_subscription: customer_subscription_params)

      expect(response).to be_successful
      expect(response.status).to eq(201)

      customer_subscription = JSON.parse(response.body, symbolize_names: true)

      expect(customer_subscription).to be_a(Hash)
      expect(customer_subscription.keys).to match_array([:data])
      expect(customer_subscription[:data]).to be_a(Hash)
      expect(customer_subscription[:data].keys).to match_array([:id, :type, :attributes])
      expect(customer_subscription[:data][:id]).to be_a(String)
      expect(customer_subscription[:data][:type]).to be_a(String)
      expect(customer_subscription[:data][:type]).to eq('customer_subscription')
      expect(customer_subscription[:data][:attributes].keys).to match_array([:id, :customer_id, :subscription_id])
      expect(customer_subscription[:data][:attributes][:id]).to be_an(Integer)
      expect(customer_subscription[:data][:attributes][:customer_id]).to be_an(Integer)
      expect(customer_subscription[:data][:attributes][:subscription_id]).to be_an(Integer)
    end
  end

  describe 'sad path' do
    it 'renders an error message if both a customer id and a subscription id are not sent as parameters' do

      customer_subscription_params = ({
        customer_id: @customer_id,
        subscription_id: ""
        })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_customer_subscription_index_path, headers: headers, params: JSON.generate(customer_subscription: customer_subscription_params)

      require "pry"; binding.pry

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to be_a(Hash)
      expect(error[:error]).to eq("Please provide both a customer id and a subscription id.")
    end
  end

end
