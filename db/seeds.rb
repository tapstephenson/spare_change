# # user and created admin user are for devise/pundit
# user = CreateAdminService.new.call

# this is bank data for Plaid API
Bank.create(bank_name: 'American Express',
            account_type: 'amex')
Bank.create(bank_name: 'Charles Schwab',
            account_type: 'scwab')
Bank.create(bank_name: 'Fidelity',
            account_type: 'fidelity')
Bank.create(bank_name: 'Wells Fargo',
            account_type: 'wells')

# create Charities

Charity.create( name: "Habitat for Humanity",
                description: "Our mission is to provide local families with a springboard to secure, stable futures through affordable homeownership, financial literacy and neighborhood revitalization.",
                logo_url: "http://www.habitatroaringfork.org/images/logo.jpg")
Charity.create( name: "San Francisco Food Bank",
                description: "Our mission is to end hunger in San Francisco and Marin. Farm-fresh fruits and vegetables… neighborhood pantries where people can choose their food… nutrition education classes... and much more.",
                logo_url: "http://citizenspace.us/wp-content/uploads/2011/11/sffb_apple.jpg")
Charity.create( name: "Boys & Girls Club",
                description: "We offer access to daily homework help, professional tutoring, support for college acceptance, and college scholarships; health and fitness, healthy eating and mental health services; free swim, learn-to-swim, and competitive swimming; nationally-recognized visual arts programs; community service opportunities; a traveling basketball program; character and leadership development programs; and much more.",
                logo_url: "http://www.fremontuniverse.com/wp-content/uploads/HANDS.bmp")
Charity.create( name: "Planned Parenthood Federation of America",
                description: "For more than 90 years, Planned Parenthood has promoted a commonsense approach to women's health and well-being, based on respect for each individual's right to make informed, independent decisions about health, sex, and family planning.",
                logo_url: "http://plannedparenthoodadvocate.typepad.com/.a/6a0147e284dcb2970b014e8905d37c970d-pi")
Charity.create( name: "National Fish and Wildlife Foundation",
                description: "Protect and restore our nation's fish, wildlife, and habitats by investing federal dollars in the most pressing conservation needs and matching those dollars with private funds.",
                logo_url: "http://www.nhm.ku.edu/komar/research/logonfwf.jpg")

# Create seed user
user = User.create(name: "Tapley Stephenson", email: "tapley.stephenson@gmail.com", password: "12345678", password_confirmation: "12345678", charity_id: 1, role: 2)
# Override created_at to utilize year's worth of transactions
user.update_attributes(created_at: 1.year.ago)


# add Plaid data to seed user
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
user.bank_id = 4
user.plaid_access_token = plaid_new_user_data.parsed_response["access_token"]

# add Stripe data to seed user
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

# create 1000 transactions in the past year for user
1000.times do
  price = Faker::Commerce.price

  Transaction.create(
    user_id: user.id,
    charity_id: user.charity_id,
    transaction_account: "seed_transaction_account",
    transaction_id: "seed_transaction_id",
    amount: price,
    rounded_amount: price.ceil,
    difference: price.ceil - price,
    date: Faker::Date.backward(365),
    name: Faker::Company.name,
    pending: false
    )
end

puts 'ADDED TRANSACTIONS FOR: ' << user.email
puts 'SEED COMPLETE!'



