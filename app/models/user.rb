class User < ActiveRecord::Base
  belongs_to :bank
  belongs_to :charity
  has_many :transactions
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
    # UserMailer.delay.welcome_email(self.id) #comment out while testing
  end

  def total_contributions
    self.transactions.where(["date > ?", self.created_at]).sum(:difference)
  end

  def current_month_total
    month_total(Time.now.month, Time.now.year)
  end

  def previous_month_total
    year_adjust = 0
    year_adjust = 1 if Time.now.month == 1

    month_total((Time.now.month - 1) % 12, Time.now.year - year_adjust)
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  private

  def correct_month?(transaction, month, year)
    transaction.date.month.to_i == month && transaction.date.year.to_i == year
  end

  def month_total(month, year)
    total = 0.0
    self.transactions.each do |transaction|
      total += transaction.difference.to_f if correct_month?(transaction, month, year)
    end
    total
  end


end
