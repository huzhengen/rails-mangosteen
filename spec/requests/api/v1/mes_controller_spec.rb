require "rails_helper"
require "active_support/testing/time_helpers"

RSpec.describe "Me", type: :request do
  include ActiveSupport::Testing::TimeHelpers
  describe "获取当前用户" do
    it "登陆后成功获取" do
      user = User.create email: "1@qq.com"
      post api_v1_session_path params: { email: "1@qq.com", code: "123456" }
      json = JSON.parse response.body
      jwt = json["jwt"]
      # request.headers['Authorization'] = "Bearer #{jwt}"
      get api_v1_me_path, headers: { "Authorization" => "Bearer #{jwt}" }
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      # expect(json['resource']['id']).to be_present
      expect(json["resource"]["id"]).to be_a(Integer)
      expect(json["resource"]["id"]).to eq user.id
    end

    it "jwt 过期" do
      travel_to(3.hours.ago)
      user1 = User.create email: "1@qq.com"
      jwt = user1.generate_jwt
      travel_back
      get api_v1_me_path, headers: { "Authorization" => "Bearer #{jwt}" }
      expect(response).to have_http_status(401)
    end

    it "jwt 没过期" do
      travel_to(1.hours.ago)
      user1 = User.create email: "1@qq.com"
      jwt = user1.generate_jwt
      travel_back
      get api_v1_me_path, headers: { "Authorization" => "Bearer #{jwt}" }
      expect(response).to have_http_status(200)
    end
  end
end
