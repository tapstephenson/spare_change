class User < ActiveRecord::Base
enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?
  after_create :send_welcome_email

  def set_default_role
    self.role ||= :user
  end

  def send_welcome_email
    # UserMailer.delay.welcome_email(self)
    UserMailer.delay.welcome_email(self)
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :transactions
  has_many :charities
end
