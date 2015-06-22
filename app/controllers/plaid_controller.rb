class PlaidController < ApplicationController

  def new
    # this is the user id from sessions
    id = session["warden.user.user.key"][0][0]
    @user = User.find(id)
    @banks = [[], ['American Express', 'amex'], ['Charles Schwab', 'schwab'], ['Fidelity', 'fidelity'], ['Wells Fargo', 'wells']]

    render :new
  end

  def create
    # this is the user id from sessions
    id = session["warden.user.user.key"][0][0]
    @user = User.find(id)

    # retrieve user data from plaid
    user_data = HTTParty.post("https://tartan.plaid.com/auth",
      body:{
        client_id: ENV['PLAID_CLIENT_ID'],
        secret: ENV['PLAID_SECRET'],
        # will be added once by user, not stored in Spare Change DB
        username: params[:user][:plaid_username],
        password: params[:user][:plaid_password],
        type: params[:account_type]
      }
    )

    # add plaid access token to user profile
    @user.plaid_access_token = user_data.parsed_response["access_token"]
    @user.save!

    # redirect to home on successful signup
    redirect_to '/'

  end

  def show
  end

  def edit
    # this is the user id from sessions
    id = session["warden.user.user.key"][0][0]
    @user = User.find(id)

    @banks = [[], ['American Express', 'amex'], ['Charles Schwab', 'schwab'], ['Fidelity', 'fidelity'], ['Wells Fargo', 'wells']]

    render :new
  end

  def update
  end

  def delete
  end

end
