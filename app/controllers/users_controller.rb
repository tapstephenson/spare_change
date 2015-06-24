class UsersController < ApplicationController
  include UserConcerns

  before_filter :authenticate_user!
  after_action :verify_authorized
  before_action :find_user, only: [:show, :update, :destroy]
  before_action :authorize_user, only: [:show, :update, :destroy]

  def index
    authorize User
  end

  def show
    @user = User.find(params[:id])
    authorize @user

    @total_contributions = @user.total_contributions

  end

  def update
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    p "user deleted1!"
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private

  def secure_params
    params.require(:user).permit(:role)
  end
end
