class Transaction < ActiveRecord::Base
  belongs_to :user
  before_save :round_transaction, :difference

  def round_transaction
    if deposit?
      self.rounded_amount = 0
    elsif pending?
      self.rounded_amount = 0
    else
      self.rounded_amount = self.amount.ceil
    end
  end

  def difference
    if deposit?
      self.difference = 0
    elsif pending?
      self.difference = 0
    else
      self.difference = self.rounded_amount - self.amount
    end
  end

  private

  def pending?
    self.pending
  end

  def deposit?
    true if self.amount < 0
    # true unless self.amount > 0
  end

end
