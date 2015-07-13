class CharitiesController < ApplicationController
  include UserConcerns
  def update
    current_user.update_attributes(charity_id: params[:charity_id])
    redirect_to "/"
  end

  def index
    all_charities
    render "charities/index"
  end

end