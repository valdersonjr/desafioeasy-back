Devise.setup do |config|
  require 'devise/orm/active_record'

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 12

  config.reconfirmable = true

  config.expire_all_remember_me_on_sign_out = true

  config.password_length = 6..128

  config.reset_password_within = 6.hours

  config.sign_out_via = :delete

  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.devise_jwt_secret_key!
    jwt.dispatch_requests = [
      ['POST', %r{^/login$}]
    ]
    jwt.revocation_requests = [
      ['DELETE', %r{^/logout$}]
    ]
    jwt.expiration_time = 1.week.to_i
  end
end
