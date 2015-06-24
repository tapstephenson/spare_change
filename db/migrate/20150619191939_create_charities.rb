class CreateCharities < ActiveRecord::Migration
  def change
    create_table :charities do |t|
      t.string      :name
      t.text        :description
      t.string      :logo_url
      t.references  :user

      t.timestamps null: false
    end
  end
end
