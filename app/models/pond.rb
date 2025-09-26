class Pond < ApplicationRecord
  acts_as_tenant(:farm)
  belongs_to :farm
  has_many :sensor_readings, dependent: :destroy

  validates :name, presence: true
  validates :volume, numericality: { only_integer: true, greater_than: 0 }
end
