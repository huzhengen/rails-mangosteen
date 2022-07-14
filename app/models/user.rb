class User < ApplicationRecord
  validates :email, presence: true

  def generate_jwt
    JWT.encode({ user_id: self.id }, Rails.application.credentials.hmac_secret, 'HS256')
  end

  def generate_auth_header
    { 'Authorization' => "Bearer #{self.generate_jwt}" } 
  end
end
