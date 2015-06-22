class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.references :user
      t.references :charity
      t.decimal :amount, precision: 10, scale: 2
      t.datetime :datetime
      t.boolean :pending

      t.timestamps null: false
    end
  end
end
