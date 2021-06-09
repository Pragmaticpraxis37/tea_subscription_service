require 'rails_helper'

describe "Show all a customer's tea subscriptions" do
  before :each do
    @customer_1 = create(:customer)
    @subscription_1 = create(:subscription)
    @subscription_2 = create(:subscription, status: 'Cancelled')
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

    @customer_1_subscription_1 = create(:customer_subscription, customer_id: @customer_1.id, subscription_id: @subscription_1.id)
    @customer_1_subscription_2 = create(:customer_subscription, customer_id: @customer_1.id, subscription_id: @subscription_2.id)


    @customer_2 = create(:customer)
    @subscription_3 = create(:subscription)

    @tea_7 = create(:tea)
    @tea_8 = create(:tea)
    @tea_9 = create(:tea)

    create(:subscription_tea, subscription_id: @subscription_3.id, tea_id: @tea_7.id)
    create(:subscription_tea, subscription_id: @subscription_3.id, tea_id: @tea_8.id)
    create(:subscription_tea, subscription_id: @subscription_3.id, tea_id: @tea_9.id)

    @customer_2_subscription_3 = create(:customer_subscription, customer_id: @customer_2.id, subscription_id: @subscription_3.id)
  end

  describe 'happy path' do
    it "show all of only a single customer's tea subscriptions whether they are cancelled or not" do
      customer_1_subscriptions_ids = @customer_1.subscriptions.ids
      customer_2_subscription_id = @customer_2.subscriptions.ids

      get api_v1_customer_subscription_path(@customer_1.id)

      customer_subscriptions = JSON.parse(response.body, symbolize_names: true)

      expect(customer_subscriptions[:data].length).to eq(2)

      customer_subscriptions[:data].each do |subscription|
        expect(customer_1_subscriptions_ids).to include(subscription[:attributes][:id])
        expect(customer_2_subscription_id).to_not include(subscription[:attributes][:id])
      end
    end

    it "returns a payload of JSON data for all of a single customer's tea subscriptions" do

      get api_v1_customer_subscription_path(@customer_1.id)

      customer_subscriptions = JSON.parse(response.body, symbolize_names: true)

      require "pry"; binding.pry

      expect(customer_subscriptions).to be_a(Hash)
      expect(customer_subscriptions.keys).to match_array([:data])
      expect(customer_subscriptions[:data]).to be_a(Array)

      customer_subscriptions[:data].each do |subscription|
        expect(subscription.keys).to match_array([:id, :type, :attributes])
        expect(subscription[:id]).to be_a(String)
        expect(subscription[:type]).to be_a(String)
        expect(subscription[:type]).to eq('subscription')
        expect(subscription[:attributes].keys).to match_array([:id, :title, :price, :status, :frequency_per_month])
        expect(subscription[:attributes][:id]).to be_an(Integer)
        expect(subscription[:attributes][:title]).to be_a(String)
        expect(subscription[:attributes][:price]).to be_a(Float)
        expect(subscription[:attributes][:status]).to be_an(String)
        expect(subscription[:attributes][:frequency_per_month]).to be_an(Integer)
      end
    end
  end

  describe 'sad path' do
    it "returns a message if a customer has no subscriptions" do
      customer_3 = create(:customer)

      get api_v1_customer_subscription_path(customer_3.id)

      expect(response).to be_successful

      message = JSON.parse(response.body, symbolize_names: true)

      expect(message).to be_a(Hash)
      expect(message[:message]).to eq("This customer has no subscriptions.")
    end
  end
end
