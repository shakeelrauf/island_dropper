module FormError
   def error_message_on(object, method)
     return unless object.respond_to?(:errors) && object.errors.include?(method)
     errors = field_errors(object, method).join(', ')
     content_tag(:div, errors, class: "bg-red text-danger pl-md-3 has-warning")
   end

   private

   def field_errors(object, method)
     object.errors[method]
   end
end