class SessionsController < ApplicationController
  def create
    uid = request.env['omniauth.auth'].uid
    user = User.where(uid: uid).first_or_create
    session[:user_id] = user.id
    redirect_to :root
  end
end
