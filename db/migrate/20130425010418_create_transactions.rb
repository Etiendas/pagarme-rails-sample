class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :user_email
      t.integer :transaction_id
      t.boolean :success

      t.timestamps
    end
  end
end
