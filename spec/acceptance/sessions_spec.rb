require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Session" do
  post "/api/v1/session" do
    parameter :email, "Email", required: true
    parameter :code, "Code", required: true
    response_field :jwt, "The token used to authenticate the user"
    let(:email) { "1@gmail.com" }
    let(:code) { "123456" }
    example "login" do
      do_request
      expect(status).to eq 200
      json = JSON.parse response_body
      expect(json["jwt"]).to be_a String
    end
  end
end
