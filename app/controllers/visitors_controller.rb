class VisitorsController < ApplicationController
  include UserConcerns

  def index
    if current_user
      if profile_complete
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
