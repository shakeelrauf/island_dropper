module Form
  def first_invalid_step
    self.class.form_steps.each do |step|
      unless step_valid?(step)
        return step
      end
    end
    self.class.form_steps.first
  end

  def step_valid?(step)
    orig_attributes = {};
    attributes.each do |key, _|
      orig_attributes[key] = eval("#{key}_was")
    end
    tmp = self.class.new(orig_attributes)
    tmp.form_step = step.to_s
    tmp.valid?
  end

  private

  def required_for_step?(step)
    return true if form_step.nil?
    return true if step.to_s == form_step.to_s
  end
end