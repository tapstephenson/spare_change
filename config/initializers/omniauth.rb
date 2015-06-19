Rails.application.config.middleware.use OmniAuth::Builder do
  provider :paypal, ENV['APP_ID'], ENV['APP_TOKEN'], sandbox: true, scope: "openid profile email"
end

# Code below is for testing mode in case live authentication is lagging during testing.
# OmniAuth.config.test_mode = true

# OmniAuth.config.mock_auth[:paypal] =  OmniAuth::AuthHash.new({
#   provider: "paypal",
#   uid: "12345",
#   info: {
#     name: "John Doe",
#     email: "john@example.com"
#   }
# })