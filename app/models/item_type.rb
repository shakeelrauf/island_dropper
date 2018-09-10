class ItemType < ApplicationRecord
  validates :title , presence: true, uniqueness: true
end
