class Delivery < ApplicationRecord
  has_one :pickup, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :dropoffs, dependent: :destroy
end
