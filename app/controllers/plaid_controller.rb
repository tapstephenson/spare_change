class PlaidController < ApplicationController
  # TODO:
  #   identify user before actions


  def new
    @user = current_user
    @banks = [[], ['American Express', 'amex'], ['Charles Schwab', 'schwab'], ['Fidelity', 'fidelity'], ['Wells Fargo', 'wells']]

    render :new
  end

  def create
    @user = current_user

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
    @user.save

    #add plaid bank account type to user profile
    bank = Bank.find_by(account_type: params[:account_type])
    @user.bank_id = bank.id
    @user.save

    # redirect to home on successful signup
    redirect_to '/'

  end

  def show
  end

  def edit
    @user = current_user

    @bank = @user.bank.bank_name

    render :edit
  end

  def update
    user = current_user

    update_plaid_user_data = ActiveSupport::JSON.decode(`curl -X PATCH https://tartan.plaid.com/auth \
  -d client_id=#{ENV['PLAID_CLIENT_ID']} \
  -d secret=#{ENV['PLAID_SECRET']} \
  -d username=#{params['user']['plaid_username']} \
  -d password=#{params['user']['plaid_password']} \
  -d access_token=#{user.plaid_access_token}`)

    user.plaid_access_token = update_plaid_user_data["access_token"]
    user.save

    redirect_to '/'
  end

  def delete
    user = current_user

    user.bank = nil
    user.plaid_access_token = nil
    user.save

    redirect_to '/'

  end

end
