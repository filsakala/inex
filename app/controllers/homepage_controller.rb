class HomepageController < ApplicationController
  layout 'page_part'

  # GET
  def set_lang
    if session[:lang] == "sk"
      session[:lang] = "en"
    else
      session[:lang] = "sk"
    end
    redirect_to :back
  end

  def web
    if current_user && current_user.is_inex_member?
      @all_events = Event.where.not(from: nil).where.not(to: nil).includes(:event_categories)
      @upcoming_events = Event.where.not(from: nil).where.not(to: nil).where('`from` BETWEEN ? AND ?', Date.today, Date.today + 30).order('`from` asc').includes(:event_categories).limit(10)
      @last_added_events = Event.order('created_at desc').includes(:event_categories).limit(20)
      @calendar_events = Event.where.not(from: nil).where.not(to: nil).where('`from` BETWEEN ? AND ?', Date.today - Date.today.day, Date.today + 180).includes(:event_categories)
    else
      public_events = Event.where(is_published: true)
      @all_events = public_events.where.not(from: nil).where.not(to: nil)
      @upcoming_events = public_events.where.not(from: nil).where.not(to: nil).where('`from` BETWEEN ? AND ?', Date.today, Date.today + 30).order('`from` asc').limit(10)
      @last_added_events = public_events.order('created_at desc').limit(20)
      @calendar_events = public_events.where.not(from: nil).where.not(to: nil).where('`from` BETWEEN ? AND ?', Date.today - Date.today.day, Date.today + 180).includes(:event_categories)
    end
    @flags = {}
    Country.where(name: @all_events.pluck(:country).uniq).each { |c| @flags[c.name] = c.flag_code }
    @content = @articles[:footer].take.content
    @search_events = @all_events.where.not(gps_latitude: nil).where.not(gps_longitude: nil)
    if !params[:q].blank? || !params[:age].blank? || !params[:sex].blank? || !params[:from].blank? || !params[:to].blank? || !params[:types].blank? || !params[:include_full].blank?
      @search_events = @search_events.where("`title` LIKE ? OR `code` LIKE ? OR `code_alliance` LIKE ? OR `country` LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%") if !params[:q].blank?
      @search_events = @search_events.where('? >= `min_age`', params[:age]).where('? <= `max_age`', params[:age]) if !params[:age].blank?
      from = Event.arel_table[:from]
      # to = Event.arel_table[:to]
      @search_events = @search_events.where(from.gteq(Date.parse(params[:from]))) if !params[:from].blank?
      @search_events = @search_events.where(from.lteq(Date.parse(params[:to]))) if !params[:to].blank?
      @search_events = @search_events.joins(:event_with_categories).where(event_with_categories: { event_category_id: params[:types] }) if !params[:types].blank?
      if params[:include_full] != 'on' # Do not include full events - get entered sex and check capacities
        ignore_sex_events = @search_events.where(ignore_sex_for_capacity: true).pluck(:id)
        if params[:sex] == 'M'
          filtered_by_sex = @search_events.where("`capacity_men` > ?", 0).where("`capacity_total` > ?", 0).where('`free_men` > ?', 0).where('`free_total` > ?', 0).pluck(:id)
        elsif params[:sex] == 'W'
          filtered_by_sex = @search_events.where("`capacity_women` > ?", 0).where("`capacity_total` > ?", 0).where('`free_women` > ?', 0).where('`free_total` > ?', 0).pluck(:id)
        else # check total capacity
          filtered_by_sex = @search_events.where("`capacity_total` > ?", 0).where('`free_total` > ?', 0).pluck(:id)
        end
        @search_events = Event.find(ignore_sex_events + filtered_by_sex)
      end
      # Fix same location places
      # (:gps_latitude, :gps_longitude, :address, :city, :country)
      coords = {}
      @search_events.each do |l|
        if (!l.gps_latitude.blank? && !l.gps_longitude.blank?) # Add only places with gps
          c = [l.gps_latitude, l.gps_longitude]
          coords[c] ||= []
          coords[c] << l
        end
      end

      radius = 0.001
      coords.each do |c, ary|
        if c && ary.size > 1
          ary.each_with_index do |event, index|
            angle = index * (360 / ary.size)
            event.gps_latitude = "#{c[0].to_f + (Math.cos(((angle + 0.0) / 180) * Math::PI) * radius)}"
            event.gps_longitude = "#{c[1].to_f + (Math.sin(((angle + 0.0) / 180) * Math::PI) * radius)}"
            # raise "#{[event.gps_latitude, event.gps_longitude]}"
            # binding.pry
          end
        end
      end
      # TODO Workcamp, Specialne projekty, Ine...
      render json: @search_events.to_json
    end
  end

  # PUT
  def send_question
    email = params[:email]
    text = params[:text]
    if ['inex@inex.sk', 'out@inex.sk', 'finance@inex.sk', 'evs@inex.sk'].include?(email)
      if !text.blank?
        UserMailer.send_question_mail(email, text).deliver_now
        redirect_to :back, success: t(:message_was_successfully_sent)
      else
        redirect_to :back, error: t(:you_cannot_send_empty_message)
      end
    else
      redirect_to :back, error: t(:you_cannot_send_message_to_address_which_does_not_belongs_to_inex)
    end
  end

  # Karty su v @articles[:tabory_panel]
  # TODO: Uzivatelske prava
  # GET/PUT
  def edit_cards
    @cards = HomepageCard.all
    if !params[:commit].blank?
      @cards.each do |card|
        if !params["#{card.id}"].blank? # update
          p = {}
          params["#{card.id}"].each do |k, v|
            p[k.to_sym] = v
          end
          card.update(p)
        else # destroy, move next positions -1
          # next_cards = HomepageCard.where("priority > ?", card.priority)
          # next_cards.each do |n|
          #   n.update(priority: n.priority - 1)
          # end
          # card.destroy
        end
      end
      redirect_to edit_cards_homepage_index_path, success: "#{t :cards} #{define_notice('ž', :update, true)}"
    end
  end

  # Vyhladava vo vybranych HTML clankoch a nazvoch eventov
  def search_page
    # {
    #   "title": "Result Title",
    #   "url": "/optional/url/on/click",
    #   #"price": "Optional Price",
    #   "description": "Optional Description"
    # }
    query = params[:q]
    articles = HtmlArticle.where(category: ['o_nas', 'aktivity', 'pomoz',
                                            'pomoz_financne', 'media',
                                            'podpora', 'footer', 'faq',
                                            'membership', 'terms_and_conditions'
    ]).where("`title` LIKE ?", "%#{query}%")
    res = []
    articles.each do |article|
      res << {
        "title": article.title,
        "url": html_article_path(article),
        "price": '<span class="ui label">Menu</span>',
        "description": t(:article_in_menu)
      }
    end
    if t(:my_events).match(/#{query}/i) && current_user
      res << {
        "title": t(:my_events),
        "url": show_events_user_path(current_user),
        "description": t(:events)
      }
    end
    if t(:my_bags).match(/#{query}/i) && current_user
      res << {
        "title": t(:my_bags),
        "url": show_bags_user_path(current_user),
        "description": t(:applications)
      }
    end
    if t(:my_profile).match(/#{query}/i) && current_user
      res << {
        "title": t(:my_profile),
        "url": user_path(current_user),
        "description": t(:info_about_you)
      }
    end
    if t(:my_events).match(/#{query}/i) && current_user
      res << {
        "title": t(:my_events),
        "url": show_events_user_path(current_user),
        "description": t(:events)
      }
    end

    if current_user && current_user.is_inex_member?
      events = Event.where.not(from: nil).where.not(to: nil).where("`title` LIKE ?", "%#{query}%")
      blogs = BlogPost.where("`title` LIKE ?", "%#{query}%")
    else
      events = Event.where(is_published: true).where.not(from: nil).where.not(to: nil).where("`title` LIKE ?", "%#{query}%")
      blogs = BlogPost.where(is_published: true).where("`title` LIKE ?", "%#{query}%")
    end
    events.each do |event|
      res << {
        "title": event.translated_title,
        "url": show_public_event_path(event),
        "price": '<span class="ui green label">Event</span>',
        "description": t(:events)
      }
    end
    blogs.each do |blog|
      res << {
        "title": blog.title,
        "url": blog_post_path(blog),
        "price": '<span class="ui yellow label">Blog</span>',
        "description": t(:article_in_blog)
      }
    end
    render json: {
      "results": res
    }
  end

  def search
    if current_user && current_user.is_inex_member?
      @all_events = Event.where.not(from: nil).where.not(to: nil)
    else
      @all_events = Event.where(is_published: true).where.not(from: nil).where.not(to: nil)
    end
    @search_events = @all_events
    if !params[:q].blank? || !params[:age].blank? || !params[:sex].blank? || !params[:from].blank? || !params[:to].blank? || !params[:types].blank?
      @search_events = @search_events.where("`title` LIKE ? OR `code` LIKE ? OR `code_alliance` LIKE ? OR `country` LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%") if !params[:q].blank?
      @search_events = @search_events.where('? >= `min_age`', params[:age]).where('? <= `max_age`', params[:age]) if !params[:age].blank?
      @search_events = @search_events.where(from: params[:from]) if !params[:from].blank?
      @search_events = @search_events.where(to: params[:to]) if !params[:to].blank?
      @search_events = @search_events.joins(:event_with_categories).where(event_with_categories: { event_category_id: params[:types] }) if !params[:types].blank?
      # Do not include full events - get entered sex and check capacities
      if params[:sex] == 'M'
        @search_events = @search_events.where("`capacity_men` > ?", 0).where("`capacity_total` > ?", 0).where('`free_men` > ?', 0).where('`free_total` > ?', 0)
      elsif params[:sex] == 'W'
        @search_events = @search_events.where("`capacity_women` > ?", 0).where("`capacity_total` > ?", 0).where('`free_women` > ?', 0).where('`free_total` > ?', 0)
      else # check total capacity
        @search_events = @search_events.where("`capacity_total` > ?", 0).where('`free_total` > ?', 0)
      end
      # TODO Workcamp, Specialne projekty, Ine...
      render json: @search_events.to_json
    end
  end

  def kontakty
    @kontakty[:adresa] = HtmlArticle.where(category: 'kontakty_adresa').take
    @kontakty[:cislo] = HtmlArticle.where(category: 'kontakty_cislo').take
    @kontakty[:ico] = HtmlArticle.where(category: 'kontakty_ico').take
    @kontakty[:ucet] = HtmlArticle.where(category: 'kontakty_ucet').take
    @kontakty[:otvaracie_description] = HtmlArticle.where(category: 'kontakty_otvaracie_description').take
    @kontakty[:otvaracie_pon] = HtmlArticle.where(category: 'kontakty_otvaracie_pon').take
    @kontakty[:otvaracie_uto] = HtmlArticle.where(category: 'kontakty_otvaracie_uto').take
    @kontakty[:otvaracie_str] = HtmlArticle.where(category: 'kontakty_otvaracie_str').take
    @kontakty[:otvaracie_stv] = HtmlArticle.where(category: 'kontakty_otvaracie_stv').take
    @kontakty[:otvaracie_pia] = HtmlArticle.where(category: 'kontakty_otvaracie_pia').take
    @kontakty[:otvaracie_vik] = HtmlArticle.where(category: 'kontakty_otvaracie_vik').take
    @kontakty[:person_incoming_number] = HtmlArticle.where(category: 'kontakty_person_incoming_number').take
    @kontakty[:person_incoming_description] = HtmlArticle.where(category: 'kontakty_person_incoming_description').take
    @kontakty[:person_incoming_description2] = HtmlArticle.where(category: 'kontakty_person_incoming_description2').take
    @kontakty[:person_outgoing_number] = HtmlArticle.where(category: 'kontakty_person_outgoing_number').take
    @kontakty[:person_outgoing_description] = HtmlArticle.where(category: 'kontakty_person_outgoing_description').take
    @kontakty[:person_outgoing_description2] = HtmlArticle.where(category: 'kontakty_person_outgoing_description2').take
    @kontakty[:person_eds_number] = HtmlArticle.where(category: 'kontakty_person_eds_number').take
    @kontakty[:person_eds_description] = HtmlArticle.where(category: 'kontakty_person_eds_description').take
    @kontakty[:person_eds_description2] = HtmlArticle.where(category: 'kontakty_person_eds_description2').take
    @faq = HtmlArticle.where(category: 'faq').take
  end

  # PUT
  def mercury_update
    if params[:content]
      HtmlArticle.where(category: 'footer').take.update(content: params[:content][:footer][:value]) if params[:content][:footer]
      # @articles[:tabory_panel].each do |tabor|
      #   tabor.url = params[:content]["tabor_image_#{tabor.id}"][:value] if params[:content]["tabor_image_#{tabor.id}"]
      #   tabor.title = params[:content]["tabor_title_#{tabor.id}"][:value] if params[:content]["tabor_title_#{tabor.id}"]
      #   tabor.content = params[:content]["tabor_content_#{tabor.id}"][:value] if params[:content]["tabor_content_#{tabor.id}"]
      #   tabor.save
      # end
      HtmlArticle.where(category: 'kontakty_adresa').take.update(content: params[:content][:adresa][:value]) if params[:content][:adresa]
      HtmlArticle.where(category: 'kontakty_cislo').take.update(content: params[:content][:cislo][:value]) if params[:content][:cislo]
      HtmlArticle.where(category: 'kontakty_ico').take.update(content: params[:content][:ico][:value]) if params[:content][:ico]
      HtmlArticle.where(category: 'kontakty_ucet').take.update(content: params[:content][:ucet][:value]) if params[:content][:ucet]
      HtmlArticle.where(category: 'kontakty_otvaracie_description').take.update(content: params[:content][:otvaracie_description][:value]) if params[:content][:otvaracie_description]
      HtmlArticle.where(category: 'kontakty_otvaracie_pon').take.update(content: params[:content][:otvaracie_pon][:value]) if params[:content][:otvaracie_pon]
      HtmlArticle.where(category: 'kontakty_otvaracie_uto').take.update(content: params[:content][:otvaracie_uto][:value]) if params[:content][:otvaracie_uto]
      HtmlArticle.where(category: 'kontakty_otvaracie_str').take.update(content: params[:content][:otvaracie_str][:value]) if params[:content][:otvaracie_str]
      HtmlArticle.where(category: 'kontakty_otvaracie_stv').take.update(content: params[:content][:otvaracie_stv][:value]) if params[:content][:otvaracie_stv]
      HtmlArticle.where(category: 'kontakty_otvaracie_pia').take.update(content: params[:content][:otvaracie_pia][:value]) if params[:content][:otvaracie_pia]
      HtmlArticle.where(category: 'kontakty_otvaracie_vik').take.update(content: params[:content][:otvaracie_vik][:value]) if params[:content][:otvaracie_vik]
      HtmlArticle.where(category: 'kontakty_person_incoming_name').take.update(content: params[:content][:person_incoming_name][:value]) if params[:content][:person_incoming_name]
      HtmlArticle.where(category: 'kontakty_person_incoming_mail').take.update(content: params[:content][:person_incoming_mail][:value]) if params[:content][:person_incoming_mail]
      HtmlArticle.where(category: 'kontakty_person_incoming_number').take.update(content: params[:content][:person_incoming_number][:value]) if params[:content][:person_incoming_number]
      HtmlArticle.where(category: 'kontakty_person_incoming_description').take.update(content: params[:content][:person_incoming_description][:value]) if params[:content][:person_incoming_description]
      HtmlArticle.where(category: 'kontakty_person_incoming_description2').take.update(content: params[:content][:person_incoming_description2][:value]) if params[:content][:person_incoming_description2]
      HtmlArticle.where(category: 'kontakty_person_outgoing_name').take.update(content: params[:content][:person_outgoing_name][:value]) if params[:content][:person_outgoing_name]
      HtmlArticle.where(category: 'kontakty_person_outgoing_mail').take.update(content: params[:content][:person_outgoing_mail][:value]) if params[:content][:person_outgoing_mail]
      HtmlArticle.where(category: 'kontakty_person_outgoing_number').take.update(content: params[:content][:person_outgoing_number][:value]) if params[:content][:person_outgoing_number]
      HtmlArticle.where(category: 'kontakty_person_outgoing_description').take.update(content: params[:content][:person_outgoing_description][:value]) if params[:content][:person_outgoing_description]
      HtmlArticle.where(category: 'kontakty_person_outgoing_description2').take.update(content: params[:content][:person_outgoing_description2][:value]) if params[:content][:person_outgoing_description2]
      HtmlArticle.where(category: 'kontakty_person_eds_name').take.update(content: params[:content][:person_eds_name][:value]) if params[:content][:person_eds_name]
      HtmlArticle.where(category: 'kontakty_person_eds_mail').take.update(content: params[:content][:person_eds_mail][:value]) if params[:content][:person_eds_mail]
      HtmlArticle.where(category: 'kontakty_person_eds_number').take.update(content: params[:content][:person_eds_number][:value]) if params[:content][:person_eds_number]
      HtmlArticle.where(category: 'kontakty_person_eds_description').take.update(content: params[:content][:person_eds_description][:value]) if params[:content][:person_eds_description]
      HtmlArticle.where(category: 'kontakty_person_eds_description2').take.update(content: params[:content][:person_eds_description2][:value]) if params[:content][:person_eds_description2]
    end
    render text: ''
  end
end
