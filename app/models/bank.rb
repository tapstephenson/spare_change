class Bank < ActiveRecord::Base
  has_many :users
end
