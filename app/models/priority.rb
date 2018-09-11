class Priority < ApplicationRecord
  before_create :confirm_singularity

  def self.instance
    # there will be only one row, and its ID must be '1'
    begin
      find(1)
    rescue ActiveRecord::RecordNotFound
      # slight race condition here, but it will only happen once
      row = Priority.new
      row.percentage = 0
      row.save!
      row
    end
  end

   def confirm_singularity
    raise Exception.new("There can be only one.") if Priority.count > 1
  end
end
