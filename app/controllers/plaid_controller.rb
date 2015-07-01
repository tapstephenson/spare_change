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
        access_token: current_user.plaid_access_token
      }
    )
    user_transactions['transactions'].each do |transaction|
      Transaction.create(
        user_id: current_user.id,
        charity_id: current_user.charity_id,
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

  def donations_graph
    @response = {
      dates: [],
      cumulative_donation: [],
      daily_donation: []
    }

    ordered_transactions = current_user.transactions.where(["date > ?", current_user.created_at]).order(date: :asc)
    cumulative_donation = 0
    daily_donation = 0
    first_transaction_of_day = ordered_transactions.first

    ordered_transactions.each do |transaction|
      if same_day?(first_transaction_of_day, transaction)
        # add donation into the cumulative and keep moving
        cumulative_donation += transaction.difference
        daily_donation += transaction.difference
      else
        # when you've hit the beginning of the next day, save current data and reset daily_donation
        @response[:dates] << first_transaction_of_day.date.strftime("%b %e, %Y")
        @response[:cumulative_donation] << cumulative_donation
        @response[:daily_donation] << daily_donation
        daily_donation = 0

        # set new month's transaction to current month and add its donation
        first_transaction_of_day = transaction
        cumulative_donation += transaction.difference
        daily_donation += transaction.difference
      end
    end

    # respond_to do |format|
    #   format.js { render json: @response }
    # end
    p "Reponse"
    p @response
    render json: {monthAmount: @response}

  end

  def same_day?(transaction1, transaction2)
    transaction1.date.day == transaction2.date.day &&
    transaction1.date.month == transaction2.date.month &&
    transaction1.date.year == transaction2.date.year
  end

end
