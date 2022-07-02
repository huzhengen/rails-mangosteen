require "rails_helper"

RSpec.describe "Items", type: :request do
  describe "获取账目" do
    it "分页(未登录)" do
      user1 = User.create! email: '1@qq.com'
      user2 = User.create! email: '2@qq.com'
      11.times {Item.create! amount: 100, user_id: user1.id}
      11.times {Item.create! amount: 100, user_id: user2.id}
      get api_v1_items_path
      expect(response).to have_http_status(401)
    end
    it "分页" do
      user1 = User.create! email: '1@qq.com'
      user2 = User.create! email: '2@qq.com'
      11.times {Item.create! amount: 100, user_id: user1.id}
      11.times {Item.create! amount: 100, user_id: user2.id}

      post api_v1_session_path params: { email: user1.email, code: '123456' }
      json = JSON.parse response.body
      jwt = json['jwt']
      get api_v1_items_path, headers: { 'Authorization' => "Bearer #{jwt}" } 
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      expect(json["resources"].size).to eq(10) # default per_page is 10
      get api_v1_items_path, params: { page: 2 }, headers: { 'Authorization' => "Bearer #{jwt}" } 
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      expect(json["resources"].size).to eq(1) # 第二页只有一条数据
    end
    it "按时间筛选" do
      user1 = User.create! email: '1@qq.com'
      item1 = Item.create amount: 100, created_at: '2010-01-02', user_id: user1.id
      item2 = Item.create amount: 100, created_at: '2010-01-02', user_id: user1.id
      item3 = Item.create amount: 100, created_at: '2010-01-03', user_id: user1.id

      post api_v1_session_path params: { email: user1.email, code: '123456' }
      json = JSON.parse response.body
      jwt = json['jwt']
      get api_v1_items_path, params: { created_after: "2010-1-1", created_before: "2010-1-2" }, headers: { 'Authorization' => "Bearer #{jwt}" }
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      expect(json["resources"].size).to eq 2
      expect(json["resources"][0]['id']).to eq item1.id
      expect(json["resources"][1]['id']).to eq item2.id
    end
    it "按时间筛选(边界条件)" do
      user1 = User.create! email: '1@qq.com'
      item1 = Item.create amount: 100, created_at: '2010-01-01', user_id: user1.id

      post api_v1_session_path params: { email: user1.email, code: '123456' }
      json = JSON.parse response.body
      jwt = json['jwt']
      get api_v1_items_path, params: { created_after: "2010-1-1", created_before: "2010-1-2" }, headers: { 'Authorization' => "Bearer #{jwt}" }
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      expect(json["resources"].size).to eq 1
      expect(json["resources"][0]['id']).to eq item1.id
    end
    it "按时间筛选(只有开始时间)" do
      user1 = User.create! email: '1@qq.com'
      item1 = Item.create amount: 100, created_at: '2010-01-02', user_id: user1.id
      item2 = Item.create amount: 100, created_at: '2008-01-01', user_id: user1.id

      post api_v1_session_path params: { email: user1.email, code: '123456' }
      json = JSON.parse response.body
      jwt = json['jwt']
      get api_v1_items_path, params: { created_after: "2010-01-01" }, headers: { 'Authorization' => "Bearer #{jwt}" }
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      expect(json["resources"].size).to eq 1
      expect(json["resources"][0]['id']).to eq item1.id
    end
    it "按时间筛选(只有结束时间)" do
      user1 = User.create! email: '1@qq.com'
      item1 = Item.create amount: 100, created_at: '2010-01-01', user_id: user1.id
      item2 = Item.create amount: 100, created_at: '2015-01-01', user_id: user1.id

      post api_v1_session_path params: { email: user1.email, code: '123456' }
      json = JSON.parse response.body
      jwt = json['jwt']
      get api_v1_items_path, params: { created_before: "2010-01-05" }, headers: { 'Authorization' => "Bearer #{jwt}" }
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
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
