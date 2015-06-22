
class StripeController < ApplicationController
  protect_from_forgery with: :null_session

  Stripe.api_key = ENV['STRIPE_SECRET_KEY']

  def new
    # this is the user id from sessions
    @current_year = Time.now.year

    render :new
  end

  def create
    p params['card']['number']

    user_data = HTTParty.get("https://api.stripe.com/v1/customers",
      # user: ENV['STRIPE_SECRET_KEY'],
      data:{
        secret_key: ENV['STRIPE_SECRET_KEY'],
        card:{
          number: params['card']['number'],
          exp_month: params['card']['exp_month'],
          exp_year: params['card']['exp_year'],
          cvc: params['card']['cvc']
        }
      }
    )

    p user_data

    redirect_to '/'
  end

end
