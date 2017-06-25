module TasksHelper

  # Add to calendar helper
  def add_event_to_google_calendar(task)
    url = "https://calendar.google.com/calendar/render?action=TEMPLATE&trp=false"
    url << "&text=#{task.title}"
    url << "&dates=#{task.deadline.strftime("%Y%m%d")}/#{(task.deadline + 1.day).strftime("%Y%m%d")}" if task.deadline
    url << "&details=#{task.description}&location=%0A%0A"
    url << "&pli=1&sf=true&output=xml"
    url << "&sprop=http%3A%2F%2Finex.sk"
    url
  end

  def star_if_highlighted(highlighted)
    content_tag :i, nil, class: "yellow star icon pop_up", title: "Dôležité" if highlighted
  end

  def done_count(task)
    task.try(:done_task_list_count)
  end

  def all_count(task)
    task.try(:task_list_count)
  end

  def done_all_count(task)
    "#{done_count(task)}/#{all_count(task)}"
  end

  def deadline_with_icon(task)
    [
      content_tag(:i, nil, class: 'clock icon'),
      task.deadline.strftime("%d.%m.")
    ].join.html_safe if task.deadline
  end
end
