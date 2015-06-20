# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@user_account_info = HTTParty.post("https://tartan.plaid.com/connect?client_id=#{ENV['PLAID_CLIENT_ID']}&secret=#{ENV['PLAID_SECRET']}",
    body: {
      username: "plaid_test",
      password: "plaid_good",
      type: "wells"
    }
)

# p @user_account_info


if @user_account_info != nil
  User.create(
                name: 'Tapley Stephenson',
                email: 'tap@gmail.com',
                username: 'plaid_test',
                password_hash: '',
                account_type: 'wells',
                charity_id: '1'
              )

#   # Charity.create(name: '', paypal_id: '', description: '')

#   # User.charges.create()
#   # User.Donation.create()

  @user_account_info["transactions"].each do |transaction|
    Transaction.create(
                        user_id: 1,
                        charity_id: 1,
                        transaction_account: transaction["amount"],
                        transaction_id: transaction["_id"] ,
                        amount: transaction["amount"],
                        date:transaction["date"] ,
                        pending:["pending"]
                      )
  end
end









