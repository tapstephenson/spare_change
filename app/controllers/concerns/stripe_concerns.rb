module StripeConcerns
  extend ActiveSupport::Concern

  included do
    def authorize_stripe
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    end
  end
end