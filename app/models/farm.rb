class Farm < ApplicationRecord
  has_many :ponds, dependent: :destroy
end
