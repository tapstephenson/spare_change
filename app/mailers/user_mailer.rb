class UserMailer < ApplicationMailer
  default from: 'info@sparechange.com'

  def welcome_email(user_id)
    @user = User.find(user_id)
    @url = 'http://127.0.0.1:3000/'
    mail(to: @user.email, subject: 'Thank You for Giving Spare Change!')
  end 
end
