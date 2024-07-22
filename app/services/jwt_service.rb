class JwtService
  def self.encode(payload, exp = 30.days.from_now)
    payload[:exp] = exp.to_i
    payload[:jti] ||= SecureRandom.uuid # Ajoute un `jti` si non fourni
    JWT.encode(payload, Rails.application.credentials.devise[:jwt_secret_key])
  end

  def self.decode(token)
    decoded = JWT.decode(token, Rails.application.credentials.devise[:jwt_secret_key], true, algorithm: 'HS256')
    HashWithIndifferentAccess.new(decoded[0])
  rescue JWT::ExpiredSignature, JWT::DecodeError
    nil
  end
end
