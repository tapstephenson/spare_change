# user and created admin user are for devise/pundit
user = CreateAdminService.new.call

# additional attributes for Spare Change
user.name = 'Tapley Stephenson',
user.charity_id = 1,
user.role = 2,
user.save!

# process for retrieving Plaid access token (will be used in signup)
plaid_new_user_data = HTTParty.post("https://tartan.plaid.com/auth",
  body:{
    client_id: ENV['PLAID_CLIENT_ID'],
    secret: ENV['PLAID_SECRET'],
    # will be added once by user, not stored in Spare Change DB
    username: 'plaid_test',
    password: 'plaid_good',
    type: 'wells'
  }
)
user.plaid_access_token = plaid_new_user_data.parsed_response["access_token"]
user.save!

# user creation confirmation
puts 'CREATED ADMIN USER: ' << user.email


# process for retrieving transactions via Plaid
user_transactions = HTTParty.post("https://tartan.plaid.com/connect/get",
  body:{
    client_id: ENV['PLAID_CLIENT_ID'],
    secret: ENV['PLAID_SECRET'],
    access_token: user.plaid_access_token
  }
)
user_transactions['transactions'].each do |transaction|
  Transaction.create(
                      user_id: user.id,
                      charity_id: user.charity_id,
                      transaction_account: transaction["amount"],
                      transaction_id: transaction["_id"] ,
                      amount: transaction["amount"],
                      date: transaction["date"] ,
                      name: transaction["name"],
                      pending: transaction["pending"]
                    )
end
