class User < ActiveRecord::Base
 belongs_to :bank

enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?
  after_create :send_welcome_email

  def set_default_role
    self.role ||= :user
  end


  def plaid_username
    # needed for form_for
    # leave blank, we don't want to store bank info
  end

  def plaid_password
    # needed for form_for
    # leave blank, we don't want to store bank info
  end

  def send_welcome_email
    UserMailer.delay.welcome_email(self.id)
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :transactions
  has_many :charities
end
