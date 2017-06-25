module WhereOrRegexpExtension
  extend ActiveSupport::Concern

  class_methods do
    def where_or_regexp(columns: [], string: "")
      return all if string.blank?
      string = string.split(' ').join('|')
      sql    = columns[0...-1].collect { |column| "`#{column}` REGEXP  \"#{string}\" OR " }.join
      sql    += "`#{columns.last}` REGEXP \"#{string}\"" if columns.last
      where(sql)
    end

    def where_or_like(columns: [], string: "")
      return all if string.blank?
      string = string.split(' ').join('|')
      sql    = columns[0...-1].collect { |column| "`#{column}` LIKE  \"#{string}\" OR " }.join
      sql    += "`#{columns.last}` LIKE \"#{string}\"" if columns.last
      where(sql)
    end

    def where_is_published(for_inex_member)
      if !for_inex_member
        self.where("is_published = true")
      else
        self.where("TRUE")
      end
    end

    def where_if(column, value, condition)
      if condition
        if !value.nil?
          self.where(column, value)
        else
          self.where(column)
        end
      else
        self.where("TRUE")
      end
    end
  end
end