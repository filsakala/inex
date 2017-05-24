module EventTypesHelper

  def table_cell_color(col)
    return EventTableColumn.color_list[col.color.to_sym] if !col.blank? && !col.color.blank?
  end

end
