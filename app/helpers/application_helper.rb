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
end
