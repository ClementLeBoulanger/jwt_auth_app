# app/controllers/api/v1/sessions_controller.rb
class Api::V1::SessionsController < Devise::SessionsController
  def create
    pp params
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      jti = SecureRandom.uuid # Génère un UUID unique pour le `jti`
      token = JwtService.encode({ user_id: user.id, jti: jti })
      render json: { token: token, user: user }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def verify
    token = params[:token]
    decoded_token = JwtService.decode(token)
    if decoded_token.present? && !JwtBlacklist.revoke?(token)
      user_id = decoded_token[:user_id]
      user = User.find_by(id: user_id)

      if user
        render json: { valid: true, user: user }, status: :ok
      else
        render json: { valid: false, error: 'User not found' }, status: :not_found
      end
    else
      render json: { valid: false, error: 'Token is blacklisted or invalid' }, status: :unauthorized
    end
  end


  def revoke
    token = params[:token]
    if token
      if JwtBlacklist.revoke(token)
        render json: { message: 'Token successfully blacklisted' }, status: :ok
      else
        render json: { error: 'Token could not be blacklisted' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Token missing' }, status: :bad_request
    end
  end
end
