class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :user
      t.references :charity
      t.string :transaction_account
      t.string :transaction_id
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :rounded_amount, precision: 10, scale: 2
      t.decimal :difference, precision: 10, scale: 2
      t.date :date
      t.string :name
      t.boolean :pending

      t.timestamps null: false
    end
  end
end
