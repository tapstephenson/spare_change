class VisitorsController < ApplicationController
  include UserConcerns
  include SettingsConcerns

  def index
    if current_user
      if profile_complete
        @transactions = current_user.transactions.where(["date > ?", current_user.created_at]).order(date: :desc).limit(20)
        @charity = Charity.find(current_user.charity_id)

        p "profile complete"
        render :loggedin
      else
        redirect_to settings_unfinished_signup_path
      end
    else
      p "logged out"
      render :loggedout
    end
  end
end
