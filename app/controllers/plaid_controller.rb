class PlaidController < ApplicationController

  def new
      @banks = []

      Bank.all.each do |bank|
        @banks << [bank.bank_name, bank.account_type]
      end

      render :new
  end

  def create
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
    current_user.plaid_access_token = user_data.parsed_response["access_token"]
    current_user.save

    #add plaid bank account type to user profile
    bank = Bank.find_by(account_type: params[:account_type])
    current_user.update_attributes(bank_id: bank.id)
    # current_user.save

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

    redirect_to '/'
  end

  def show
  end

  def edit
    @bank = current_user.bank.bank_name
    render :edit
  end

  def update
    update_plaid_user_data = ActiveSupport::JSON.decode(`curl -X PATCH https://tartan.plaid.com/auth \
  -d client_id=#{ENV['PLAID_CLIENT_ID']} \
  -d secret=#{ENV['PLAID_SECRET']} \
  -d username=#{params['user']['plaid_username']} \
  -d password=#{params['user']['plaid_password']} \
  -d access_token=#{user.plaid_access_token}`)

    current_user.plaid_access_token = update_plaid_user_data["access_token"]
    current_user.save

    redirect_to '/'
  end

  def delete
    current_user.bank = nil
    current_user.plaid_access_token = nil
    current_user.save

    redirect_to '/'
  end

end
