Rails.application.config.middleware.use OmniAuth::Builder do
  provider :paypal, ENV['APP_ID'], ENV['APP_TOKEN'], sandbox: true, scope: "openid profile email"
end