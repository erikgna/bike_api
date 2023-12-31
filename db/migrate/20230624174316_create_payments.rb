class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.string :holder_name
      t.string :card_number
      t.integer :expiration_date
      t.integer :ccv
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
