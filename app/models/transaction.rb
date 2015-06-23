class Transaction < ActiveRecord::Base
  belongs_to :user
  before_save :round_transaction, :difference

  def round_transaction
    self.rounded_amount = self.amount.ceil
  end

  def difference
    self.difference = self.amount - self.rounded_amount
  end
end
