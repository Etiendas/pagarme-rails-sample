class ChangeTransactionIdTypeToString < ActiveRecord::Migration
  def up
	change_column :transactions, :transaction_id, :string
  end

  def down
  end
end
