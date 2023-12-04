module ApplicationHelper
  include Pagy::Frontend

  def flash_class(type)
    case type
    when 'success'
      'bg-green-50 text-green-500'
    when 'error'
      'bg-red-50 text-red-500 '
    when 'alert'
      'bg-yellow-50 text-yellow-500'
    when 'notice'
      'bg-blue-500 text-white'
    else
      'bg-gray-500 text-white'
    end
  end

  def errors_helper(model, field)
    if model.errors.include?(field)
      model.errors.full_messages_for(field).each do |message|
        return content_tag(:span, message, class: 'text-red-400 text-sm')
      end
    end
  end
end
