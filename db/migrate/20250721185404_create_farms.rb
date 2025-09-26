class CreateFarms < ActiveRecord::Migration[8.0]
  def change
    create_table :farms do |t|
      t.string :name
      t.string :subdomain
      
      t.timestamps
    end
  end
end
