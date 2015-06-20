class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :role

      t.string :username
      t.string :password_hash #I don't think we need this. devise uses encrypted_password above.
      t.string :account_type
      t.integer :pin
      t.string :uid # uid is for paypal - delete if we don't use paypal
      t.references :charity
      
      ## Plaid
      t.string :plaid_access_token
      
      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps null: false
    end
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
  end
end
