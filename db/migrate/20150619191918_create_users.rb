class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :username
      t.string :password_hash
      t.string :account_type
      t.references :charity

      t.timestamps null: false
    end
  end
end
