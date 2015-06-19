class SessionsController < ApplicationController
  def create
    auth_hash = request.env['omniauth.auth']
    p "*"*90
    p auth_hash
    uid = auth_hash.uid
    profile = auth_hash.profile
    email = auth_hash.info.email

    user = User.where(uid: uid).first_or_create
    session[:user_id] = user.id
    redirect_to :root
  end

  def show
    @user = User.find_by_id(session[:user_id])
  end
end
