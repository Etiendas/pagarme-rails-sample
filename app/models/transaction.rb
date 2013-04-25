class Transaction < ActiveRecord::Base
  attr_accessible :success, :transaction_id, :user_email, :amount
end
