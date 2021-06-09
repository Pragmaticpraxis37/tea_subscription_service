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

    @customer_subscription = create(:customer_subscription, customer_id: @customer.id, subscription_id: @subscription.id)
  end

  describe 'happy path' do
    it "cancels a customer's tea subscription and save information in the CustomerSubscription table" do

      customer_subscription =  CustomerSubscription.find_by(customer_id: @customer.id, subscription_id: @subscription.id)
      expect(customer_subscription.subscription.status).to eq('Active')

      customer_subscription_params = ({
        customer_id: @customer.id,
        subscription_id: @subscription.id
        })

      headers = {"CONTENT_TYPE" => "application/json"}

      patch api_v1_customer_subscription_path(@subscription), headers: headers, params: JSON.generate(customer_subscription: customer_subscription_params)

      customer_subscription =  CustomerSubscription.find_by(customer_id: @customer.id, subscription_id: @subscription.id)
      expect(customer_subscription.subscription.status).to eq('Cancelled')
    end

    it "cancels a customer's tea subscription and returns a payload of JSON cancelled subscription data" do

      customer_subscription_params = ({
        customer_id: @customer.id,
        subscription_id: @subscription.id
        })

      headers = {"CONTENT_TYPE" => "application/json"}

      patch api_v1_customer_subscription_path(@subscription), headers: headers, params: JSON.generate(customer_subscription: customer_subscription_params)


      expect(response).to be_successful
      expect(response.status).to eq(201)

      customer_subscription = JSON.parse(response.body, symbolize_names: true)

      expect(customer_subscription).to be_a(Hash)
      expect(customer_subscription.keys).to match_array([:data])
      expect(customer_subscription[:data]).to be_a(Hash)
      expect(customer_subscription[:data].keys).to match_array([:id, :type, :attributes])
      expect(customer_subscription[:data][:id]).to be_a(String)
      expect(customer_subscription[:data][:type]).to be_a(String)
      expect(customer_subscription[:data][:type]).to eq('subscription')
      expect(customer_subscription[:data][:attributes].keys).to match_array([:id, :title, :price, :status, :frequency_per_month])
      expect(customer_subscription[:data][:attributes][:id]).to be_an(Integer)
      expect(customer_subscription[:data][:attributes][:title]).to be_a(String)
      expect(customer_subscription[:data][:attributes][:price]).to be_a(Float)
      expect(customer_subscription[:data][:attributes][:status]).to be_an(String)
      expect(customer_subscription[:data][:attributes][:status]).to eq('Cancelled')
      expect(customer_subscription[:data][:attributes][:frequency_per_month]).to be_an(Integer)
    end
  end
end
