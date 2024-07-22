class JwtBlacklist < ApplicationRecord
  self.table_name = 'jwt_blacklists'

  def self.revoke(token)
    jti = decode_jwt(token)[:jti]
    if jti.present?
      create!(jti: jti)
    else
      Rails.logger.error("Failed to revoke token: JTI is nil")
    end
  end

  def self.revoke?(token)
    jti = decode_jwt(token)[:jti]
    jti.present? && exists?(jti: jti)
  end

  private

  def self.decode_jwt(token)
    decoded_token = JWT.decode(token, Rails.application.credentials.devise[:jwt_secret_key], true, algorithm: 'HS256')
    HashWithIndifferentAccess.new(decoded_token[0])
  rescue JWT::DecodeError
    {}
  end
end
