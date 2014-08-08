module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = League::NAME
    base_title += ' | ' +  page_title unless page_title.blank?
    base_title
  end
end