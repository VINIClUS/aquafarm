class Farm < ApplicationRecord
  belongs_to :user
  has_many :ponds, dependent: :destroy

  validates :name, presence: true, length: { maximum: 120 }
  validates :name, uniqueness: true
end
