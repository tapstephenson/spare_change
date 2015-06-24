class StripeController < ApplicationController
  include StripeConcerns
  # protect_from_forgery with: :null_session
  protect_from_forgery except: :create
  before_action :authorize_stripe, only: [:create, :update, :delete]

  def new
    render :new
  end

  def create
    # Stripe API call to sign up customer on subscription plan
    stripe_new_user_data = ActiveSupport::JSON.decode(`curl https://api.stripe.com/v1/customers \
      -u #{Stripe.api_key}: \
      -d card[number]=#{params['card']['number']} \
      -d card[exp_month]=#{params['card']['exp_month']} \
      -d card[exp_year]=#{params['card']['exp_year']} \
      -d card[cvc]=#{params['card']['cvc']} \
      -d plan=#{params['frequency']}`)

    current_user.update_attributes(stripe_customer_id: stripe_new_user_data['id'], 
                                   stripe_subscription_id: stripe_new_user_data['subscriptions']['data'][0]['id'])
    redirect_to '/'
  end

  def edit
    render :edit
  end

  def update
    # delete
    # create
  end

  def delete
    # retrieves customer data by their customer id and deletes their subscription
    customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    customer.subscriptions.retrieve(current_user.stripe_subscription_id).delete

    # deletes card information
    customer.delete

    current_user.stripe_customer_id = nil
    current_user.stripe_subscription_id = nil
    current_user.save

    p "delete ran"

    redirect_to '/'
  end

end
