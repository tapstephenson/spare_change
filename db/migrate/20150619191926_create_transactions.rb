class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :user
      t.references :charity
      t.decimal :amount precision: 10, scale: 2
      t.date :date
      t.boolean :pending

      t.timestamps null: false
    end
  end
end
