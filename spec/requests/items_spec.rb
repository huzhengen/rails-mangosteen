require "rails_helper"

RSpec.describe "Items", type: :request do
  describe "get /api/v1/items by page" do
    it "works! (now write some real specs)" do
      11.times do
        Item.create amount: 100
      end
      expect(Item.count).to eq(11)
      get api_v1_items_path
      expect(response).to have_http_status(200)
      # expect(response.body).to include("\"total\":11")
      json = JSON.parse response.body
      expect(json["resources"].size).to eq(10) # default per_page is 10
      get api_v1_items_path, params: { page: 2 }
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      expect(json["resources"].size).to eq(1) # 第二页只有一条数据
    end
  end

  describe "create" do
    it "can create an item" do
      expect(Item.count).to eq(0)
      post api_v1_items_path, params: { item: { amount: 100 } }
      expect(response).to have_http_status(201)
      expect(Item.count).to eq(1)
    end
    it "can create one item" do
      expect {
        post api_v1_items_path, params: { item: { amount: 100 } }
      }.to change(Item, :count).by(+1)
      expect {
        post api_v1_items_path, params: { item: { amount: 100 } }
      }.to change { Item.count }.by(1)
      expect(response).to have_http_status(201)
      json = JSON.parse response.body
      expect(json["resource"]["id"]).to be_an(Integer)
      expect(json["resource"]["amount"]).to eq(100)
    end
  end
end
