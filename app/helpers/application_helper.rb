module ApplicationHelper
  def full_title(page_title)
    base_title = 'United Way'

    if page_title.empty?
      return base_title
    end

    "#{base_title} - #{page_title}"
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, params.merge(sort: column, direction: direction, page: nil), {:class => css_class}
  end

end
