module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = League::NAME
    base_title += ' | ' +  page_title unless page_title.blank?
    base_title
  end

  def error_div(object)
    return unless object

    if object.errors.any?
      errors_capture = capture do
        result = content_tag(:h2, "#{pluralize(object.errors.count, 'error')} prohibited this #{object.class} from being saved:")

         object.errors.full_messages.each do |message|
           result << content_tag(:li, message)
         end

        result
      end

      concat content_tag(:div, errors_capture, id: 'error_explanation')
    end
  end

  def admin_area(&block)
    concat content_tag(:div, capture(&block), :class => 'admin') if admin?
  end

  def vip_area(&block)
    concat content_tag(:div, capture(&block), :class => 'vip') if vip?
  end
end