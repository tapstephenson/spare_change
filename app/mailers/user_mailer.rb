class UserMailer < ApplicationMailer
  default from: 'info@sparechange.com'

  def welcome_email(user)
    @user = user
    @url = 'http://127.0.0.1:3000/'
    mail(to: @user.email, subject: 'Thank You for Giving Spare Change!')
  end 
end
