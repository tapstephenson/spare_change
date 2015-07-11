
## About Spare Change

Spare Change makes charity giving easy through seamless micro-donations.

To build Spare Change we used Ruby on Rails for the back-end, JavaScript for data visualization, Sidekiq for processing background jobs (ie. fetching daily transactions and emails), Redis as a background job queue and Sidetiq for scheduling those jobs.

Users sign up with their banking information and charity preferences.  We use Plaid and Stripe APIs to securely manage banking details and transactions. Plaid is an API for developers of financial services applications that helps them connect with user bank accounts.  Stripe is a suite of APIs that powers commerce for businesses of all sizes.

Spare Change then tracks each user's daily transactions using Plaid and calculates the difference rounded up to the nearest dollar.  All of those small differences add up to a meaningful monthly contribution (~$20 per month based on our initial user testing).

At the end of the month each user is notified of their pending contribution and given the option to abort the transaction before we charge their bank account using Stripe and send the money to the charity of the user's choosing.

### How to Run Spare Change Locally

1. Navigate to an appropriate directory on your machine

2. Clone the repo in the command line
  * `git clone https://github.com/tapley/spare_change.git`
  * If forked to your repo use your clone url

3. Navigate to the spare_change directory
  * `cd spare_change`

4. Install required project gems
  * `bundle install`

5. Create database, migrate schema, seed database
  * `bin/rake db:create db:migrate db:seed`

### Start Servers

1. Install Redis (a key/value store that maintains a job queue)
  * `brew install redis`

2. Install Foreman (runs severs)
  * `gem install foreman`

3. Open a new tab in terminal and run redis-cli monitor (debugging redis)
  * `redis-cli monitor`

4. Run Foreman (starts severs)
  * `foreman start`

### Sign into test account

1. Sign in test account
  * Username `john.smith@gmail.com`
  * Password `12345678`

### Sign in using Plaid & Stripe Test Credentials

To sign in using test credentials which will call the Plaid and Stripe API's you must have access to the secret API keys which must be kept private. If you're interested in a live demo, please contact any of the project contributers listed below:

* Joshua Croff
  * `joshua.croff@gmail.com`

* Tapley Stephenson
  * `tapley.stephenson@gmail.com`

* Teresa Martyny
  * `teresamartyny@gmail.com`

* Piara Sandhu
  * `piarasandhu108@gmail.com`