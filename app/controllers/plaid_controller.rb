class PlaidController < ApplicationController
  # TODO:
  #   identify user before actions

  def new
    @user = current_user

    if !current_user.bank || !current_user.plaid_access_token
      @banks = [[], ['American Express', 'amex'], ['Charles Schwab', 'schwab'], ['Fidelity', 'fidelity'], ['Wells Fargo', 'wells']]
      render :new
    else
      if @user.stripe_customer_id && @user.stripe_subscription_id
        redirect_to '/'
      else
        redirect_to stripe_new_path
      end
    end

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

    # process for retrieving transactions via Plaid
    user_transactions = HTTParty.post("https://tartan.plaid.com/connect/get",
      body:{
        client_id: ENV['PLAID_CLIENT_ID'],
        secret: ENV['PLAID_SECRET'],
        access_token: @user.plaid_access_token
      }
    )
    user_transactions['transactions'].each do |transaction|
      Transaction.create(
        user_id: @user.id,
        charity_id: @user.charity_id,
        transaction_account: transaction["amount"],
        transaction_id: transaction["_id"] ,
        amount: transaction["amount"],
        date: transaction["date"] ,
        name: transaction["name"],
        pending: transaction["pending"]
      )
    end


    if @user.stripe_customer_id && @user.stripe_subscription_id
      redirect_to '/'
    else
      redirect_to stripe_new_path
    end
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
