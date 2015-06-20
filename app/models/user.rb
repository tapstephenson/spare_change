class User < ActiveRecord::Base
  has_many :transactions
end
