module DocumentsHelper

  def event_filter(event_type_ids, event_ids, years)
    if event_type_ids.blank? && event_ids.blank?
      events_by_id = Event.all
      events_by_type = Event.where(id: nil)
    else
      events_by_id = Event.where(id: event_ids)
      events_by_type = Event.where(event_type: EventType.find(event_type_ids))
    end
    # events in selected years
    if years.any?
      event_ids = []
      from_field = Event.arel_table[:from]
      to_field = Event.arel_table[:to]
      years.each do |year|
        event_ids += events_by_id.where(from_field.gteq(Date.parse("01-01-#{year}")).and(from_field.lteq(Date.parse("31-12-#{year}")))).pluck(:id)
        event_ids += events_by_type.where(from_field.gteq(Date.parse("01-01-#{year}")).and(from_field.lteq(Date.parse("31-12-#{year}")))).pluck(:id)
      end
    else
      event_ids = events_by_id.pluck(:id) + events_by_type.pluck(:id)
    end
    return event_ids
  end

  def event_leaders(ar_events)
    return ar_events.joins(:leaders).pluck(:user_id)
  end

  def event_trainers(ar_events)
    return ar_events.joins(:trainers).pluck(:user_id)
  end

  def event_local_partners(ar_events)
    return ar_events.joins(:local_partners).pluck(:user_id)
  end

  def event_volunteers(ar_events, educations, ages)
    event_event_list = ar_events.joins(:event_lists)
    event_event_list = event_event_list.where(education_id: educations) if !educations.blank?
    if ages.any?
      ok_ids = []
      event_event_list.each do |el|
        age = User.age(el.birth_date)
        ages.each do |a|
          if a.from <= age && age <= a.to
            ok_ids << el.id
          end
        end
      end
      event_event_list = EventList.where(id: ok_ids)
    end
    return event_event_list.joins(:volunteers).pluck(:user_id)
  end

  # TODO Clen na aktivite?
  def event_members(ar_events)
    user_ids = []
    User.all.each do |u|
      user_ids << u.id if u.je_clen?
    end
    user_ids
  end

  def filter_by_people(ar_events, educations, ages, people)
    user_ids = []
    volunteer_user_ids = []
    if people.any?
      people.each do |p|
        if p == "leaders"
          r = event_leaders(ar_events)
          user_ids << r if !r.blank?
        elsif p == "trainers"
          r = event_trainers(ar_events)
          user_ids << r if !r.blank?
        elsif p == "local_partners"
          r = event_local_partners(ar_events)
          user_ids << r if !r.blank?
        elsif p == "volunteers" # Vek a education cez event_list
          volunteer_user_ids = event_volunteers(ar_events, educations, ages)
        elsif p == "members"
          r = event_members(ar_events)
          user_ids << r if !r.blank?
        end
      end
    else # all!
      r = event_leaders(ar_events)
      user_ids << r if !r.blank?
      r = event_trainers(ar_events)
      user_ids << r if !r.blank?
      r = event_local_partners(ar_events)
      user_ids << r if !r.blank?
      volunteer_user_ids = event_volunteers(ar_events, educations, ages)
      r = event_members(ar_events)
      user_ids << r if !r.blank?
    end
    return [user_ids.flatten, volunteer_user_ids]
  end

  # Construct hash { user_id: count }
  def user_id_counts(user_ids)
    result = {}
    user_ids.each do |id|
      if result[id].blank?
        result[id] = 1
      else
        result[id] += 1
      end
    end
    return result
  end

  # Get search params, the result is count of results
  def result_stats(params = {})
    @years ||= params[:years] || []
    event_type_ids ||= params[:event_type_ids] || []
    event_ids ||= params[:event_ids] || []
    @do_uniq = (params[:do_uniq] == "on")

    # Events filter
    @event_ids = event_filter(event_type_ids, event_ids, @years)

    if params[:stats_type] == "person_stats"
      @people ||= params[:people] || []
      @educations ||= params[:education_ids] || []
      @sex = params[:sex] if params[:sex] != "-"
      @ages = []
      (0..20).each do |i|
        if !params["age_from_#{i}"].blank? && !params["age_to_#{i}"].blank?
          @ages << { from: params["age_from_#{i}"],
                     to: params["age_to_#{i}"] }
        end
      end
      @ar_events = Event.where(id: @event_ids) # ActiveRecord events
      user_ids, volunteer_user_ids = filter_by_people(@ar_events, @educations, @ages, @people)
      # raise "#{user_ids}, #{volunteer_user_ids}"

      @users = User.where(id: user_ids) # automaticky robi uniq!
      @users = @users.where(education_id: @educations) if !@educations.blank?
      @users = @users.where(sex: @sex) if !@sex.blank?
      if @ages.any?
        uids = []
        @users.each do |el|
          age = User.age(el.birth_date)
          @ages.each do |a|
            if a.from <= age && age <= a.to
              uids << el.id
            end
          end
        end
      else
        uids = @users.pluck(:id)
      end

      # recalc by user count
      user_counts = user_id_counts(user_ids)
      uids_recalc = []
      # prida do pola id tolkokrat, kolko bolo pred uniq vo where
      uids.each do |id|
        if !user_counts[id].blank?
          user_counts[id].times do
            uids_recalc << id
          end
        end
      end

      @user_ids = (uids_recalc + volunteer_user_ids).flatten
      return @user_ids.uniq.count if @do_uniq
      return @user_ids.count

    elsif params[:stats_type] == "event_stats"
      return @event_ids.uniq.count if @do_uniq
      return @event_ids.count
    else
      return 0 # nothing to do here
    end
  end
end
