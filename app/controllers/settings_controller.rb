class SettingsController < ApplicationController
  include UserConcerns
  include SettingsConcerns

  before_filter :authenticate_user!

  def index
    render :index
  end

  def unfinished_signup
    if !plaid_complete
      redirect_to plaid_new_path
    elsif !stripe_complete
      redirect_to stripe_new_path
    elsif !charity_complete
      all_charities
      redirect_to charities_users_path
    end
  end

end
