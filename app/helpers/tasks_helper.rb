module TasksHelper

  def color_by_deadline(date)
    return "grey" if !date
    return "red" if Date.today >= date
    return "orange" if 7.days.from_now >= date
    return "green"
  end

  def task_list_to_s(task)
    s = ''
    task.task_lists.each do |tl|
      s += "#{tl.title} (#{tl.state})\n"
    end
    s
  end

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

end
