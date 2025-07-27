class CreatePonds < ActiveRecord::Migration[8.0]
  def change
    create_table :ponds do |t|
      t.string :name
      t.integer :volume
      t.references :farm, null: false, foreign_key: true

      t.timestamps
    end
  end
end
