module CheckFields 
  def check_for_existence
    self.attributes.each do |attr|
      return false if self[attr].nil?
      return true
    end
  end
end