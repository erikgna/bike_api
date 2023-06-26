class CreateRides < ActiveRecord::Migration[7.0]
  def change
    create_table :rides do |t|
      t.string :value
      t.string :creation_date
      t.string :city
      t.string :start_date
      t.string :end_date
      t.string :start_location
      t.string :end_location
      t.json :path
      t.references :user, null: false, foreign_key: true
      t.references :payments, null: true, foreign_key: true

      t.timestamps
    end
  end
end
