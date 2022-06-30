require "rails_helper"

RSpec.describe "Items", type: :request do
  describe "获取账目" do
    it "分页" do
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
    it "按时间筛选" do
      item1 = Item.create amount: 100, created_at: '2010-01-02'
      item2 = Item.create amount: 100, created_at: '2010-01-02'
      item3 = Item.create amount: 100, created_at: '2010-01-03'
      get api_v1_items_path, params: { created_after: "2010-1-1", created_before: "2010-1-2" }
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      expect(json["resources"].size).to eq 2
      expect(json["resources"][0]['id']).to eq item1.id 
      expect(json["resources"][1]['id']).to eq item2.id
    end
    it "按时间筛选(边界条件)" do
      # item1 = Item.create amount: 100, created_at: Time.new(2010, 1, 1, 0, 0, 0, "Z")
      item1 = Item.create amount: 100, created_at: '2010-01-01'
      get api_v1_items_path, params: { created_after: "2010-1-1", created_before: "2010-1-2" }
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      p json
      expect(json["resources"].size).to eq 1
      expect(json["resources"][0]['id']).to eq item1.id
    end
    it "按时间筛选(只有开始时间)" do
      item1 = Item.create amount: 100, created_at: '2010-01-02'
      item2 = Item.create amount: 100, created_at: '2008-01-01'
      get api_v1_items_path, params: { created_after: "2010-01-01" }
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      expect(json["resources"].size).to eq 1
      expect(json["resources"][0]['id']).to eq item1.id
    end
    it "按时间筛选(只有结束时间)" do
      item1 = Item.create amount: 100, created_at: '2010-01-01'
      item2 = Item.create amount: 100, created_at: '2015-01-01'
      get api_v1_items_path, params: { created_before: "2010-01-05" }
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      p json
      expect(json["resources"].size).to eq 1
      expect(json["resources"][0]['id']).to eq item1.id 
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
