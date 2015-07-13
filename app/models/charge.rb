class Charge < ActiveRecord::Base

  def self.stripe_new_user_data(params)
    ActiveSupport::JSON.decode(`curl https://api.stripe.com/v1/customers \
      -u #{Stripe.api_key}: \
      -d card[number]=#{params['card']['number']} \
      -d card[exp_month]=#{params['card']['exp_month']} \
      -d card[exp_year]=#{params['card']['exp_year']} \
      -d card[cvc]=#{params['card']['cvc']} \
      -d plan=#{params['frequency']}`)
  end
end
