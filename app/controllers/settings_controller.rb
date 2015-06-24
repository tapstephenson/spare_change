class SettingsController < ApplicationController
  include UserConcerns

  before_filter :authenticate_user!
  # before_action :authorize_user, only: [:index]
  

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
