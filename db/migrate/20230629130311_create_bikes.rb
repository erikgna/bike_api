class CreateBikes < ActiveRecord::Migration[7.0]
  def change
    create_table :bikes do |t|
      t.string :model
      t.string :name
      t.boolean :avaliability

      t.timestamps
    end
  end
end
