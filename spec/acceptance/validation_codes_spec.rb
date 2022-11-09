require "rails_helper"
require "rspec_api_documentation/dsl"

resource "code" do
  post "/api/v1/validation_codes" do
    parameter :email, type: :string
    let(:email) { "1@qq.com" }

    example "Request to send a verification code" do
      # expect(UserMailer).to receive(:validation_code).with(email: email).and_return(double(deliver_now: true))
      expect(UserMailer).to receive(:welcome_email).with(email)
      do_request
      expect(status).to eq 200
      expect(response_body).to eq "{}"
    end
  end
end
