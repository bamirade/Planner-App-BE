module AuthHelper
  SECRET_KEY = Rails.application.secrets.secret_key_base

  def self.generate_token(user_id)
    payload = { user_id: user_id }
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.decode_token(token)
    JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256').first
  rescue JWT::ExpiredSignature
    nil
  end
end
