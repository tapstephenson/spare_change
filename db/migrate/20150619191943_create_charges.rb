class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.references :user
      t.decimal :amount, precision: 10, scale: 2
      t.datetime :datetime
      t.boolean :pending

      t.timestamps null: false
    end
  end
end
