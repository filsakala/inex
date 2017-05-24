module ApplicationHelper

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields ui right floated yellow button", data: { id: id, fields: fields.gsub("\n", "") })
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to(name, '#fs', class: "remove_fields ui red button")
  end

  def flash_class(level)
    return "ui green message" if level == 'success'
    return "ui red message" if level == 'error'
    return "ui yellow message" if level == 'warning'
    return "ui grey message" if level == 'notice'
    return "ui grey message"
  end

  # Check if you are currently in controller.
  def current_controller?(controllers = [])
    controllers.include?(controller_name)
  end

  # Is this page the current page?
  def cp(path)
    # raise current_page?(path).inspect
    # raise (request.path == path).inspect
    # "active" if current_page?(path)
    "active" if request.path == path
  end

  # Is this page from current controller?
  def ccp(controllers = [])
    "active" if current_controller?(controllers)
  end

  def build_menu
    if @menu.blank?
      @menu ||= [
        {
          link: event_types_path,
          class: "item #{ccp(['events', 'event_types'])}",
          icon: 'announcement icon',
          text: t(:events)
        }, {
          link: contact_lists_path,
          class: "item #{ccp(['contacts', 'contact_lists'])}",
          icon: 'address book icon',
          text: t(:contacts)
        }, {
          link: organizations_path,
          class: "item #{ccp(['organizations', 'partner_networks'])}",
          icon: 'child icon',
          text: t(:organizations)
        },
      ]
      if current_user && current_user.is_employee? && !@menu.blank?
        @menu << {
          link: documents_path,
          class: "item #{ccp(['documents'])}",
          icon: 'file outline icon',
          text: t(:documents)
        }
        @menu << {
          link: users_path,
          class: "item #{ccp(['users'])}",
          icon: 'users icon',
          text: t(:accounts)
        }
      end
    end
    @menu
  end

  def date_format(date)
    return "" if !date
    date.strftime("%d.%m.%Y")
  end

  def date_day_month_format(date)
    return "" if !date
    date.strftime("%d.%m.")
  end

  def datetime_format(datetime)
    return "" if !datetime
    datetime.strftime("%d.%m.%Y %H:%M")
  end

  def write_error(entity)
    if entity.errors.any?
      errors = ""
      entity.errors.full_messages.each do |message|
        errors << "<li>#{message}</li>"
      end
      "<div class=\"ui icon red message\">
          <i class=\"remove icon\"></i>
          <div class=\"content\">
            <div class=\"header\">
              #{t(:form_problem_occured)}
            </div>
            <ul class=\"list\">
            #{errors}
            </ul>
        </div>
        </div>".html_safe
    end
  end

  def write_warning(entity)
    if entity.errors.any?
      errors = ""
      entity.errors.full_messages.each do |message|
        errors << "<li>#{message}</li>"
      end
      "<div class=\"ui icon yellow message\">
          <i class=\"warning sign icon\"></i>
          <div class=\"content\">
            <div class=\"header\">
              Upozornenia:
            </div>
            <ul class=\"list\">
            #{errors}
            </ul>
        </div>
        </div>".html_safe
    end
  end

  def build_breadcrumb(controller = controller_name, action = action_name)
    divider = '<i class="right chevron icon divider"></i>'
    breadcrumb = ""
    breadcrumb << link_to("Home", root_path, class: "section")
    case controller
      when "users"
        breadcrumb << divider << link_to(t(:users), users_path, class: "section") if current_user.is_employee?
        case action
          when "show"
            breadcrumb << divider << link_to(@user.name, @user, class: "section") if @user
            breadcrumb << divider << link_to(current_user.nickname, current_user, class: "section") if !@user
          when "show_events"
            breadcrumb << divider << link_to("#{t(:my)} #{t(:events).downcase}", show_events_user_path(current_user), class: "section")
          when "show_bags"
            breadcrumb << divider << link_to("#{t(:my)} #{t(:bags).downcase}", show_bags_user_path(current_user), class: "section")
          when "new"
            breadcrumb << divider << link_to(@user.name, @user, class: "section") unless @user.name.blank?
            breadcrumb << divider << link_to(current_user.nickname, current_user, class: "section") if @user.name.blank?
            breadcrumb << divider << link_to(t(:register), new_user_path, class: "section")
          when "edit"
            breadcrumb << divider << link_to(@user.name, @user, class: "section") if @user
            breadcrumb << divider << link_to(current_user.nickname, current_user, class: "section") if !@user
            breadcrumb << divider << link_to(t(:edit_data), edit_user_path(@user), class: "section")
        end
      when "tasks"
        case action
          when "index"
            breadcrumb << divider << link_to("#{t(:my)} #{t(:tasks).downcase}", tasks_path, class: "section")
          when "index_others"
            breadcrumb << divider << link_to(t(:others_assigned_tasks), index_others_tasks_path, class: "section")
          when "repeatable"
            breadcrumb << divider << link_to("#{t(:repeatable)} #{t(:tasks).downcase}", repeatable_tasks_path, class: "section")
          when "new"
            breadcrumb << divider << t(:tasks)
            breadcrumb << divider << link_to(t(:add_tasks), new_task_path, class: "section")
          when "edit"
            breadcrumb << divider << @task.title
            breadcrumb << divider << link_to(t(:edit_task), edit_task_path(params[:id]), class: "section")
        end
      when "contact_lists"
        breadcrumb << divider << link_to(t(:contacts), contact_lists_path, class: "section")
        case action
          when "show"
            breadcrumb << divider << link_to(@contact_list.title, @contact_list, class: "section")
          when "edit"
            breadcrumb << divider << link_to(@contact_list.title, @contact_list, class: "section")
            breadcrumb << divider << link_to("#{t(:edit)} #{t(:address_book).downcase}", edit_contact_list_path(@contact_list), class: "section")
          when "add"
            breadcrumb << divider << link_to(@contact_list.title, @contact_list, class: "section")
            breadcrumb << divider << link_to(t(:select_contacts), add_contact_list_path(@contact_list), class: "section")
          when "organizations"
            breadcrumb << divider << link_to(t(:partner_organizations), organizations_contact_lists_path, class: "section")
          when "events"
            breadcrumb << divider << link_to(t(:events), events_contact_lists_path, class: "section")
            breadcrumb << divider << t(:select_years)
          when "events_second"
            breadcrumb << divider << link_to(t(:events), events_contact_lists_path, class: "section")
            breadcrumb << divider << t(:select_years)
            breadcrumb << divider << t(:select_events)
          when "events_third"
            breadcrumb << divider << link_to(t(:events), events_contact_lists_path, class: "section")
            breadcrumb << divider << t(:select_years)
            breadcrumb << divider << t(:select_events)
            breadcrumb << divider << t(:results)
        end
      when "contacts"
        breadcrumb << divider << link_to(t(:contacts), contact_lists_path, class: "section")
        breadcrumb << divider << link_to(t(:all_contacts), contacts_path, class: "section")
        case action
          when "new"
            breadcrumb << divider << link_to("#{t(:add)} #{t(:contact).downcase}", new_contact_path, class: "section")
          when "edit"
            breadcrumb << divider << link_to(@contact.name, @contact, class: "section")
            breadcrumb << divider << link_to("#{t(:edit)} #{t(:contacts).downcase}", edit_contact_path(@contact), class: "section")
          when "show"
            breadcrumb << divider << link_to(@contact.name, @contact, class: "section")
        end
      when "organizations"
        breadcrumb << divider << link_to(t(:organizations), organizations_path, class: "section")
        case action
          when "new"
            breadcrumb << divider << link_to(t(:add_organization), new_organization_path, class: "section")
          when "edit"
            breadcrumb << divider << link_to(@organization.name, @organization, class: "section")
            breadcrumb << divider << link_to(t(:edit_organization), edit_organization_path(@organization), class: "section")
          when "show"
            breadcrumb << divider << link_to(@organization.name, @organization, class: "section")
        end
      when "partner_networks"
        breadcrumb << divider << link_to(t(:organizations), organizations_path, class: "section")
        breadcrumb << divider << link_to(t(:partner_networks), partner_networks_path, class: "section")
        case action
          when "new"
            breadcrumb << divider << link_to("#{t(:add)} #{t(:partner_network).downcase}", new_partner_network_path, class: "section")
          when "edit"
            breadcrumb << divider << link_to(@partner_network.name, @partner_network, class: "section")
            breadcrumb << divider << link_to("#{t(:edit)} #{t(:partner_network).downcase}", edit_partner_network_path(@partner_network), class: "section")
          when "show"
            breadcrumb << divider << link_to(@partner_network.name, @partner_network, class: "section")
        end
      when "documents"
        breadcrumb << divider << link_to(t(:documents), documents_path, class: "section")
        case action
          when "edit_file"
            breadcrumb << divider << link_to("#{t(:edit)} #{t(:document).downcase}", edit_file_documents_path(file_id: params[:file_id]), class: "section")
          when "edit_stats"
            breadcrumb << divider << link_to("#{t(:edit)} #{t(:document).downcase}", edit_file_documents_path(file_id: params[:file_id]), class: "section")
            breadcrumb << divider << link_to(t(:add_stats), edit_stats_documents_path(file_id: params[:file_id], row: params[:row], col: params[:col]), class: "section")
        end
      when "event_types"
        breadcrumb << divider << link_to(t(:event_types), event_types_path, class: "section")
        case action
          when "show"
            breadcrumb << divider << link_to(@event_type.title, @event_type, class: "section")
          when "new"
            breadcrumb << divider << link_to("#{t :add} #{t :event_type}", new_event_type_path, class: "section")
          when "edit"
            breadcrumb << divider << link_to(@event_type.title, @event_type, class: "section")
            breadcrumb << divider << link_to("#{t :edit} #{t :event_type}", edit_event_type_path(@event_type), class: "section")
          when "bags"
            breadcrumb << divider << link_to(@event_type.title, @event_type, class: "section")
            breadcrumb << divider << link_to(t(:bags), bags_event_type_path(@event_type), class: "section")
        end
      when "participation_fees"
        breadcrumb << divider << link_to(t(:event_types), event_types_path, class: "section")
        breadcrumb << divider << link_to(t(:payments), participation_fees_path, class: "section")
        case action
          when "show"
            breadcrumb << divider << link_to("Detail", @participation_fee, class: "section")
          when "new"
            breadcrumb << divider << link_to(t(:add), new_participation_fee_path(user_id: params[:user_id]), class: "section")
          when "edit"
            breadcrumb << divider << link_to(t(:edit), edit_participation_fee_path(@participation_fee), class: "section")
        end
      when "event_categories"
        breadcrumb << divider << link_to(t(:event_types), event_types_path, class: "section")
        breadcrumb << divider << link_to(t(:workcamp_types), event_categories_path, class: "section")
        case action
          when "new"
            breadcrumb << divider << link_to(t(:add), new_event_category_path, class: "section")
          when "edit"
            breadcrumb << divider << link_to(t(:edit), edit_event_category_path(@event_category), class: "section")
        end
      when "events"
        case action
          when "new"
            breadcrumb << divider << link_to(t(:event_types), event_types_path, class: "section")
            breadcrumb << divider << link_to(@event_type.title, @event_type, class: "section")
            breadcrumb << divider << link_to(t(:add_event), new_event_type_event_path(@event_type), class: "section")
          when "edit"
            breadcrumb << divider << link_to(t(:event_types), event_types_path, class: "section")
            breadcrumb << divider << link_to(@event_type.title, @event_type, class: "section")
            breadcrumb << divider << link_to(@event.translated_title, event_type_event_path(@event_type, @event), class: "section")
            breadcrumb << divider << link_to(t(:edit_event), edit_event_type_event_path(@event_type, @event), class: "section")
          when "step_second"
            breadcrumb << divider << link_to(t(:event_types), event_types_path, class: "section")
            breadcrumb << divider << link_to(@event_type.title, @event_type, class: "section")
            breadcrumb << divider << link_to(@event.translated_title, event_type_event_path(@event_type, @event), class: "section")
            breadcrumb << divider << link_to(t(:edit_event), edit_event_type_event_path(@event_type, @event), class: "section")
            breadcrumb << divider << link_to("#{t :step} 2", step_second_event_type_event_path(@event_type, @event), class: "section")
          when "step_third"
            breadcrumb << divider << link_to(t(:event_types), event_types_path, class: "section")
            breadcrumb << divider << link_to(@event_type.title, @event_type, class: "section")
            breadcrumb << divider << link_to(@event.translated_title, event_type_event_path(@event_type, @event), class: "section")
            breadcrumb << divider << link_to(t(:edit_event), edit_event_type_event_path(@event_type, @event), class: "section")
            breadcrumb << divider << link_to("#{t :step} 2", step_second_event_type_event_path(@event_type, @event), class: "section")
            breadcrumb << divider << link_to("#{t :step} 3", step_third_event_type_event_path(@event_type, @event), class: "section")
          when "step_fourth"
            breadcrumb << divider << link_to(t(:event_types), event_types_path, class: "section")
            breadcrumb << divider << link_to(@event_type.title, @event_type, class: "section")
            breadcrumb << divider << link_to(@event.translated_title, event_type_event_path(@event_type, @event), class: "section")
            breadcrumb << divider << link_to(t(:edit_event), edit_event_type_event_path(@event_type, @event), class: "section")
            breadcrumb << divider << link_to("#{t :step} 2", step_second_event_type_event_path(@event_type, @event), class: "section")
            breadcrumb << divider << link_to("#{t :step} 3", step_third_event_type_event_path(@event_type, @event), class: "section")
            breadcrumb << divider << link_to("#{t :step} 4", step_fourth_event_type_event_path(@event_type, @event), class: "section")
          when "step_fifth"
            breadcrumb << divider << link_to(t(:event_types), event_types_path, class: "section")
            breadcrumb << divider << link_to(@event_type.title, @event_type, class: "section")
            breadcrumb << divider << link_to(@event.translated_title, event_type_event_path(@event_type, @event), class: "section")
            breadcrumb << divider << link_to(t(:edit_event), edit_event_type_event_path(@event_type, @event), class: "section")
            breadcrumb << divider << link_to("#{t :step} 2", step_second_event_type_event_path(@event_type, @event), class: "section")
            breadcrumb << divider << link_to("#{t :step} 3", step_third_event_type_event_path(@event_type, @event), class: "section")
            breadcrumb << divider << link_to("#{t :step} 4", step_fourth_event_type_event_path(@event_type, @event), class: "section")
            breadcrumb << divider << link_to("#{t :step} 5", step_fifth_event_type_event_path(@event_type, @event), class: "section")
          when "show"
            breadcrumb << divider << link_to(t(:event_types), event_types_path, class: "section")
            breadcrumb << divider << link_to(@event_type.title, @event_type, class: "section")
            breadcrumb << divider << link_to(@event.translated_title, event_type_event_path(@event_type, @event), class: "section")
          when "import_1"
            breadcrumb << divider << link_to(t(:event_types), event_types_path, class: "section")
            breadcrumb << divider << link_to(t(:import_events), import_1_events_path, class: "section")
          when "import_2"
            breadcrumb << divider << link_to(t(:event_types), event_types_path, class: "section")
            breadcrumb << divider << link_to(t(:import_events), import_1_events_path, class: "section")
            breadcrumb << divider << "#{t :step} 2"
          when "import_3"
            breadcrumb << divider << link_to(t(:event_types), event_types_path, class: "section")
            breadcrumb << divider << link_to(t(:import_events), import_1_events_path, class: "section")
            breadcrumb << divider << "#{t :step} 3"
          when "import_4"
            breadcrumb << divider << link_to(t(:event_types), event_types_path, class: "section")
            breadcrumb << divider << link_to(t(:import_events), import_1_events_path, class: "section")
            breadcrumb << divider << "#{t :step} 4"
        end
      when "event_lists"
        case action
          when "show"
            breadcrumb << divider << link_to(t(:my_bag), event_list_path(@event_list), class: "section")
          when "edit"
            breadcrumb << divider << link_to(t(:my_bag), event_list_path(@event_list), class: "section")
            breadcrumb << divider << link_to(t(:application), edit_event_list_path(@event_list), class: "section")
          when "step_second"
            breadcrumb << divider << link_to(t(:my_bag), event_list_path(@event_list), class: "section")
            breadcrumb << divider << link_to(t(:application), edit_event_list_path(@event_list), class: "section")
            breadcrumb << divider << link_to(t(:check_and_confirmation), step_second_event_list_path(@event_list), class: "section")
          when "payment_info"
            breadcrumb << divider << link_to("#{t(:my)} #{t(:bags).downcase}", show_bags_user_path(current_user), class: "section")
            breadcrumb << divider << link_to(t(:information_about_fees), payment_info_event_list_path(@event_list), class: "section")
        end
      when "permissions"
        case action
          when "index"
            breadcrumb << divider << link_to(t(:users), users_path, class: "section")
            breadcrumb << divider << link_to(t(:user_permissions), permissions_path, class: "section")
        end
      when "log_activities"
        case action
          when "index"
            breadcrumb << divider << link_to(t(:users), users_path, class: "section")
            breadcrumb << divider << link_to(t(:user_activity_log), log_activities_path, class: "section")
        end
      when "event_tables"
        breadcrumb << divider << link_to(t(:event_types), event_types_path, class: "section")
        breadcrumb << divider << link_to(@event_type.title, @event_type, class: "section")
        breadcrumb << divider << link_to(t(:tables), event_type_event_tables_path(@event_type), class: "section")
        case action
          when "show"
            breadcrumb << divider << link_to("#{t :table} #{@event_table.name}", [@event_type, @event_table], class: "section")
          when "edit"
            breadcrumb << divider << link_to("#{t :table} #{@event_table.name}", [@event_type, @event_table], class: "section")
            breadcrumb << divider << link_to(t(:edit_table), edit_event_type_event_table_path(@event_type, @event_table), class: "section")
          when "new"
            breadcrumb << divider << link_to(t(:create_table), new_event_type_event_table_path(@event_type), class: "section")
        end
      when "issue_tickets"
        breadcrumb << divider << link_to("Problémy", issue_tickets_path, class: "section") if current_user.is_employee?
        case action
          when "show"
            breadcrumb << divider << link_to("Detail problému", @issue_ticket, class: "section")
          when "new"
            breadcrumb << divider << link_to("Pridať problém", new_user_path, class: "section")
          when "edit"
            breadcrumb << divider << link_to("Detail problému", @issue_ticket, class: "section")
            breadcrumb << divider << link_to("Upraviť problém", edit_issue_ticket_path(@issue_ticket), class: "section")
        end
    end
    return breadcrumb
  end

  def build_breadcrumb_homepage(controller = controller_name, action = action_name)
    divider = '<i class="right chevron icon divider"></i>'
    breadcrumb = ""
    breadcrumb << link_to("Home", root_path, class: "section")
    case controller
      when "homepage"
        case action
          when "kontakty"
            breadcrumb << divider << link_to(t(:contacts), kontakty_homepage_index_path, class: "section")
          when "search"
            breadcrumb << divider << link_to(t(:search_events), search_homepage_index_path, class: "section")
          when "edit_cards"
            breadcrumb << divider << link_to(t(:edit_cards), edit_cards_homepage_index_path, class: "section")
        end
      when "blog_posts"
        breadcrumb << divider << link_to("Blog", blog_posts_path, class: "section")
        breadcrumb << divider << link_to("#{t :category} #{@category.name || "všetko"}", blog_posts_path(category: @category.name), class: "section") unless @category.blank?
        case action
          when "categories"
            breadcrumb << divider << link_to(t(:categories), categories_blog_posts_path, class: "section")
          when "show"
            breadcrumb << divider << link_to(@blog_post.title, @blog_post, class: "section")
          when "new"
            breadcrumb << divider << link_to(t(:new_article), new_blog_post_path, class: "section")
        end
      when "html_articles"
        case action
          when "show"
            case @html_article.category
              when "o_nas"
                breadcrumb << divider << t(:about_us)
              when "aktivity"
                breadcrumb << divider << t(:activities) << divider << t(:activity_types)
              when "pomoz"
                breadcrumb << divider << t(:get_involved) << divider << t(:actively)
              when "pomoz_financne"
                breadcrumb << divider << t(:get_involved) << divider << t(:financially)
              when "media"
                breadcrumb << divider << t(:media)
            end
            breadcrumb << divider << link_to(@html_article.title, @html_article, class: "section")
          when "new"
            case params[:category]
              when "o_nas"
                breadcrumb << divider << t(:about_us)
              when "aktivity"
                breadcrumb << divider << t(:activities) << divider << t(:activity_types)
              when "pomoz"
                breadcrumb << divider << t(:get_involved) << divider << t(:actively)
              when "pomoz_financne"
                breadcrumb << divider << t(:get_involved) << divider << t(:financially)
              when "media"
                breadcrumb << divider << t(:media)
            end
            breadcrumb << divider << link_to(t(:add_article_to_menu), new_html_article_path(cat: params[:cat]), class: "section")
          when "edit"
            case @html_article.category
              when "o_nas"
                breadcrumb << divider << t(:about_us)
              when "aktivity"
                breadcrumb << divider << t(:activities) << divider << t(:activity_types)
              when "pomoz"
                breadcrumb << divider << t(:get_involved) << divider << t(:actively)
              when "pomoz_financne"
                breadcrumb << divider << t(:get_involved) << divider << t(:financially)
              when "media"
                breadcrumb << divider << t(:media)
            end
            breadcrumb << divider << link_to(@html_article.title, @html_article, class: "section")
            breadcrumb << divider << link_to(t(:edit_article), edit_html_article_path(@html_article), class: "section")
        end
      when "events"
        case action
          when "show_public"
            breadcrumb << divider << link_to(t(:search_events), search_homepage_index_path, class: "section")
            breadcrumb << divider << link_to(@event.translated_title, show_public_event_path(@event), class: "section")
        end
      when "homepage_partners"
        case action
          when "new"
            breadcrumb << divider << link_to(t(:create_partner), new_homepage_partner_path, class: "section")
          when "edit"
            breadcrumb << divider << link_to("#{t(:edit_partner)} #{@partner.try(:text)}", edit_homepage_partner_path(@partner), class: "section")
        end
      when "event_types"
        case action
          when "application_conditions"
            breadcrumb << divider << @event_type.title
            breadcrumb << divider << link_to(t(:the_conditions_of_participation), application_conditions_event_type_path(@event_type), class: "section")
        end
      when "recommenders"
        case action
          when "edit"
            if @recommender.html_article
              breadcrumb << divider << link_to(@recommender.html_article.try(:title), @recommender.html_article)
            elsif @recommender.blog_post
              breadcrumb << divider << link_to(@recommender.blog_post.try(:title), @recommender.blog_post)
            end
            breadcrumb << divider << "Recommendation system"
        end
    end

    return breadcrumb
  end

  def mercury_update_link
    if current_controller?("blog_posts") && action_name == 'show'
      mercury_update_blog_post_path(@blog_post)
    elsif current_controller?("html_articles") && action_name == 'show'
      mercury_update_html_article_path(@html_article)
    else
      mercury_update_homepage_index_path
    end
  end

  # def paginator(entity)
  #
  # end

end
