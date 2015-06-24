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
                logo_url: "http://www.habitatgsf.org/image/layout-and-template-images/25th-anniversary-horizontal-website.png")
Charity.create( name: "San Francisco Food Bank",
                description: "Our mission is to end hunger in San Francisco and Marin. Farm-fresh fruits and vegetables… neighborhood pantries where people can choose their food… nutrition education classes... and much more.",
                logo_url: "http://www.sfmfoodbank.org/sites/all/themes/sffb/images/sffb-logo.png")
Charity.create( name: "Boys & Girls Club",
                description: "We offer access to daily homework help, professional tutoring, support for college acceptance, and college scholarships; health and fitness, healthy eating and mental health services; free swim, learn-to-swim, and competitive swimming; nationally-recognized visual arts programs; community service opportunities; a traveling basketball program; character and leadership development programs; and much more.",
                logo_url: "http://www.kidsclub.org/wp-content/themes/BGCSF/images/logo_home_page.gif")
Charity.create( name: "Planned Parenthood Federation of America",
                description: "For more than 90 years, Planned Parenthood has promoted a commonsense approach to women's health and well-being, based on respect for each individual's right to make informed, independent decisions about health, sex, and family planning.",
                logo_url: "https://upload.wikimedia.org/wikipedia/en/thumb/2/2c/Planned_Parenthood_logo.svg/1280px-Planned_Parenthood_logo.svg.png")
Charity.create( name: "National Fish and Wildlife Foundation",
                description: "Protect and restore our nation's fish, wildlife, and habitats by investing federal dollars in the most pressing conservation needs and matching those dollars with private funds.",
                logo_url: "http://www.nhm.ku.edu/komar/research/logonfwf.jpg")

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
