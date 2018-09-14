class Reference < ApplicationRecord
  belongs_to :delivery
  validates :reference_no , presence: true
end
