class StripeController < ApplicationController
  # protect_from_forgery with: :null_session
  protect_from_forgery except: :create
  Stripe.api_key = ENV['STRIPE_SECRET_KEY']

  def new

    # this is the user id from sessions
    @current_year = Time.now.year

    render :new
  end

  def create
    user = current_user
    p user
    p params['card']['number']
    p params['card']['exp_month']
    p params['card']['exp_year']
    p params['card']['cvc']

    # Stripe API call to sign up customer on subscription plan
    stripe_new_user_data = ActiveSupport::JSON.decode(`curl https://api.stripe.com/v1/customers \
      -u #{ENV['STRIPE_SECRET_KEY']}: \
      -d card[number]=#{params['card']['number']} \
      -d card[exp_month]=#{params['card']['exp_month']} \
      -d card[exp_year]=#{params['card']['exp_year']} \
      -d card[cvc]=#{params['card']['cvc']} \
      -d plan=#{params['frequency']}`)
    p stripe_new_user_data

    # Stripe dummy data
    # 4242424242424242
    # 12
    # 2016
    # 123

    user.stripe_customer_id = stripe_new_user_data['id']
    user.stripe_subscription_id = stripe_new_user_data['subscriptions']['data'][0]['id']
    user.save

    redirect_to '/'
  end

  def edit

    # this is the user id from sessions
    @current_year = Time.now.year

    render :edit
  end

  def update
    # delete
    # create
  end

  def delete
    user = current_user

    # retrieves customer data by their customer id and deletes their subscription
    customer = Stripe::Customer.retrieve(user.stripe_customer_id)
    customer.subscriptions.retrieve(user.stripe_subscription_id).delete

    # deletes card information
    customer.delete

    redirect_to '/'
  end

end
