class AuthenticationMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    Rails.logger.debug "Authorization Header: #{request.get_header('HTTP_AUTHORIZATION')}"
    request = Rack::Request.new(env)
    token = request.get_header('HTTP_AUTHORIZATION')&.split(' ')&.last

    if token
      decoded_token = JwtService.decode(token)
      if decoded_token
        # Optionnel : Ajoutez des informations utilisateur à la requête si nécessaire
        # env['warden'].set_user(User.find(decoded_token[:user_id]))
      else
        return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Invalid token' }.to_json]]
      end
    end

    @app.call(env)
  end
end
