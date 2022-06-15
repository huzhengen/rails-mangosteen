require "rails_helper"

RSpec.describe "ValidationCodes", type: :request do
  describe "验证码" do
    it "发送验证码成功" do
      post api_v1_validation_codes_path params: { email: "1@qq.com" }
      expect(response).to have_http_status(200)
    end
    it "发送验证码太频繁，返回 429" do
      post api_v1_validation_codes_path params: { email: "1@qq.com" }
      expect(response).to have_http_status(200)
      post api_v1_validation_codes_path params: { email: "1@qq.com" }
      expect(response).to have_http_status(429)
    end
  end
end
