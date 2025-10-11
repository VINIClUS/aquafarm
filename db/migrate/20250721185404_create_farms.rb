class CreateFarms < ActiveRecord::Migration[8.0]
  def change
    create_table :farms do |t|
      t.string :name, null: false
      t.string :subdomain
      
      t.timestamps
    end
    
    add_index :farms, :name, unique: true
  end
end
