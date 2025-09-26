class Farm < ApplicationRecord
  belongs_to :user
  has_many :ponds, dependent: :destroy
end
