class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :cpf
      t.string :email
      t.string :password
      t.boolean :confirmed
      t.string :token

      t.timestamps
    end
  end
end
