class VisitorsController < ApplicationController
  def index
    p current_user
    if current_user
      if current_user.bank && current_user.plaid_access_token &&
        current_user.stripe_customer_id && current_user.stripe_subscription_id
        p "profile complete"
        render :loggedin
      else
        p "profile incomplete"
        render :completesignup
      end
    else
      p "logged out"
      render :loggedout
    end
  end
end
