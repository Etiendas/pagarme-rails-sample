class ChangeSuccessToTransactionStatus < ActiveRecord::Migration
  def up
	remove_column :transactions, :success
	add_column :transactions, :status, :string
  end

  def down
  end
end
