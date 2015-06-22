# user and created admin user are for devise/pundit
user = CreateAdminService.new.call

# additional attributes for Spare Change
user.name = 'Tapley Stephenson',
user.charity_id = 1,
user.role = 2,
user.save!

# this is bank data for Plaid API
Bank.create(bank_name: 'American Express', account_type: 'amex')
Bank.create(bank_name: 'Charles Schwab', account_type: 'scwab')
Bank.create(bank_name: 'Fidelity', account_type: 'fidelity')
Bank.create(bank_name: 'Wells Fargo', account_type: 'wells')

# process for retrieving Plaid access token (will be used in signup)
plaid_new_user_data = HTTParty.post("https://tartan.plaid.com/auth",
  body:{
    client_id: ENV['PLAID_CLIENT_ID'],
    secret: ENV['PLAID_SECRET'],
    # online banking username and password (strings below are Plaid dummy data)
    # will be added once by user, not stored in Spare Change DB
    username: 'plaid_test',
    password: 'plaid_good',
    type: 'wells'
  }
)
user.plaid_access_token = plaid_new_user_data.parsed_response["access_token"]
user.save

# Stripe API call to sign up customer on subscription plan
stripe_new_user_data = ActiveSupport::JSON.decode(`curl https://api.stripe.com/v1/customers \
   -u sk_test_5Lq3TlyeL7o86D0pMfJXo5Vz: \
   -d card[number]=4242424242424242 \
   -d card[exp_month]=12 \
   -d card[exp_year]=2016 \
   -d card[cvc]=123 \
   -d plan=1`)
user.stripe_customer_id = stripe_new_user_data['id']
user.stripe_subscription_id = stripe_new_user_data['subscriptions']['data'][0]['id']
user.save

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
