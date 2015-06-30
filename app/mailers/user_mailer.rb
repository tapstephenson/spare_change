class UserMailer < ApplicationMailer
  default from: 'info@sparechange.com'

  def welcome_email(user_id)
    @user = User.find(user_id)
    @url = 'http://127.0.0.1:3000/'
    mail(to: @user.email, subject: 'Thank You for Giving Spare Change!')
  end 

  def weekly_email(user_id)
    @user = User.find(user_id)
    @url = 'http://127.0.0.1:3000/'
    @charity = Charity.find(@user.charity_id).name
    mail(to: @user.email, subject: 'Weekly Update for Spare Change')
  end
end
