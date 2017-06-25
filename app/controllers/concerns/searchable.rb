module Searchable
  extend ActiveSupport::Concern

  def do_search(class_name, columns: [], order_by: {})
    per_page = params[:length].to_i
    per_page ||= 10 if per_page == 0
    page = (params[:start].to_i) / per_page + 1
    page = 1 if page <= 0
    class_name.where_or_regexp(columns: columns, string: params[:search][:value])
      .order(order_by).paginate(page: page, per_page: per_page)
  end
end