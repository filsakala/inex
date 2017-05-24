module PaginationHelper
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer
    protected

    def page_number(page)
      unless page == current_page
        link(page, page, :class => 'item')
      else
        link(page, "#", :class => 'active item')
      end
    end

    def gap
      %(<div class="disabled item">... </div>)
    end

    def next_page
      num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
      previous_or_next_page(num, @options[:next_label], 'next')
    end

    def previous_or_next_page(page, text, classname)
      if page
        link(text, page, :class => classname)
      else
        link(text, "#", :class => classname + ' disabled')
      end
    end

    def html_container(html)
      tag(:div, html, class: 'ui right floated pagination menu')
    end

    private

    def link(text, target, attributes = {})
      if target.is_a? Fixnum
        attributes[:rel] = rel_value(target)
        target = url(target)
      end

      unless target == "#"
        attributes[:href] = target
      end

      attributes.delete(:classname)
      tag(:div, tag(:a, text, attributes))
    end
  end
end