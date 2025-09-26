# db/migrate/20250906130000_add_user_to_farms.rb
class AddUserToFarms < ActiveRecord::Migration[7.1]
  def change
    add_reference :farms, :user, null: false, foreign_key: true
  end
end
