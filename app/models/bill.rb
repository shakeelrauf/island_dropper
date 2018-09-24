class Bill < ApplicationRecord
  belongs_to :dropoff
  serialize :response
end
