class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.string :bank_name
      t.string :account_type

      t.timestamps null: false
    end
  end
end
