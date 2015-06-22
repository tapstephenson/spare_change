# this is for paypal omniauth. remove if we don't do omni-auth
class SessionsController < ApplicationController
  
  def index
  end

  def create

    user = User.where(uid: auth_hash.uid).first_or_create!(name: auth_hash.info.name, email: auth_hash.info.email)
    session[:user_id] = user.id
    redirect_to :root
  end

  def show
    @user = User.find_by_id(session[:user_id])
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
