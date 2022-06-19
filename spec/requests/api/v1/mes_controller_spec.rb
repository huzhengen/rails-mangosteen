require 'rails_helper'

RSpec.describe "Me", type: :request do
  describe "获取当前用户" do
    it "获取" do
      user = User.create email: '1@qq.com'
      post api_v1_session_path params: { email: "1@qq.com", code: '123456' }
      json = JSON.parse response.body
      jwt = json['jwt']
      # request.headers['Authorization'] = "Bearer #{jwt}"
      get api_v1_me_path, headers: { 'Authorization' => "Bearer #{jwt}" } 
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      # expect(json['resource']['id']).to be_present
      expect(json['resource']['id']).to be_a(Integer)
      expect(json['resource']['id']).to eq user.id
    end
  end
end
