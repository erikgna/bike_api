class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.string :holder_name
      t.string :card_number
      t.string :expiration_date
      t.string :ccv

      t.timestamps
    end
  end
end
