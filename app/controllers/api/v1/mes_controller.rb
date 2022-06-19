class Api::V1::MesController < ApplicationController
  def show
    header = request.headers['Authorization']
    jwt = header.split(' ').last rescue ''
    decoded_jwt = JWT.decode jwt, Rails.application.credentials.hmac_secret, true, { algorithm: 'HS256' } rescue nil
    if decoded_jwt.nil?
      return render status: 400
    end
    user_id = decoded_jwt[0]['user_id'] rescue nil
    user = User.find user_id
    if user.nil?
      head 404
    else
      render json: { resource: user }, status: 200
    end
  end
end
