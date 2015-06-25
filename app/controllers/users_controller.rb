class UsersController < ApplicationController

  include UserConcerns

  before_filter :authenticate_user!
  after_action :verify_authorized
  before_action :authorize_user, only: [:show, :update, :destroy]

  def index
    authorize User
    all_users
  end

  def show
    @total_contributions = current_user.total_contributions
    @current_month_total = current_user.current_month_total
    @previous_month_total = current_user.previous_month_total

  end

  def update
    if current_user.update_attributes(secure_role_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    p "user deleted1!"
    authorize user
    current_user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private

  def secure_role_params
    params.require(:user).permit(:role)
  end

  def secure_charity_params
    params.require(:user).permit(:id, :user_id)
  end
end
