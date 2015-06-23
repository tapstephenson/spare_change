class SettingsController < ApplicationController
  include UsersConcerns

  def index
    render :index
  end

  def unfinished_signup
    if !plaid_complete
      redirect_to plaid_new_path
    elsif !stripe_complete
      redirect_to stripe_new_path
    end
  end

end
