module FormError
   def error_message_on(object, method)
     return unless object.respond_to?(:errors) && object.errors.include?(method)
     errors = field_errors(object, method)
     content_tag(:div, errors, class: "bg-red text-danger pl-md-3 has-warning")
   end

   private

   def field_errors(object, method)
     "#{method.to_s.split('_').map(&:capitalize).join(' ')} "+ object.errors[method].first
   end
end