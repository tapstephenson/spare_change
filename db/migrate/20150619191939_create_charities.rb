class CreateCharities < ActiveRecord::Migration
  def change
    create_table :charities do |t|
      t.string :name
      t.string :paypal_id
      t.text :description

      t.timestamps null: false
    end
  end
end
