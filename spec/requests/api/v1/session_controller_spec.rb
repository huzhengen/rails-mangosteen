require 'rails_helper'

RSpec.describe "Api::V1::SessionControllers", type: :request do
  describe "Session" do
    it "登陆" do
      User.create email: '1@qq.com'
      post api_v1_session_path params: { email: "1@qq.com", code: '123456' }
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      # expect(json['jwt']).to be_present
      expect(json['jwt']).to be_a(String)
    end
  end
end

