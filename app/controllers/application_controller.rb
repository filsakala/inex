class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  add_flash_types :error, :warning, :success
  before_action :is_active, :set_variables, :set_locale, :log_activity, :permission_control

  # automatically set context (:lang)
  def default_url_options
    { lang: I18n.locale }
  end

  private
  helper_method :current_user

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
      return @current_user
    end
  end

  def is_active
    if current_user && !current_user.is_active?
      session[:user_id] = nil
      redirect_to root_url, error: t(:your_account_is_disabled)
    end
  end

  def set_variables
    @partners     = HomepagePartner.order(:text)
    articles_cats = %w(o_nas aktivity pomoz pomoz_financne media podpora footer faq membership terms_and_conditions)
    @articles     = {}
    HtmlArticle.where(category: articles_cats).each { |a| (@articles[a.category.to_sym] ||= []).push(a) }
    @articles[:tabory_panel] = HomepageCard.where(is_visible: true)

    if current_user
      @my_bag              = current_user.user_event_list(false)
      @events_in_bag_count = @my_bag.try(:events).try(:count).to_i
      @undone_tasks        = if current_user.employee # Employee menu
                               current_user.employee.tasks.joins(:task_lists)
                                 .where(task_lists: { state: "nedokončená" })
                                 .pluck("tasks.id").uniq.count
                             else
                               0
                             end
    else
      @events_in_bag_count = 0
      @undone_tasks        = 0
    end
    kontakty_cats = %w(kontakty_person_incoming_name kontakty_person_incoming_mail kontakty_person_outgoing_name kontakty_person_outgoing_mail kontakty_person_eds_name kontakty_person_eds_mail)
    @kontakty     ||= Hash[HtmlArticle.where(category: kontakty_cats).collect { |a| [a.category.to_sym, a] }]
  end

=begin
    Vytvorí notice hlášku typu: XYZ bol úspešne vytvorený.
    @param rod mužský/ženský/stredný
    @param metoda create/update/destroy
    @return notice Notice hláška
=end
  def define_notice_en(metoda = nil, plural = false)
    notice = ""
    notice << plural ? "were successfully" : "was successfully "
    notice << case metoda
                when :create
                  "created."
                when :update
                  "updated."
                when :destroy
                  "destroyed."
                else
                  metoda.to_s + "."
              end
    notice
  end

  def define_notice(rod = "m", metoda = nil, plural = false)
    return define_notice_en(metoda, plural) if I18n.locale == :en
    notice         = ""
    pripona_bol    = ""
    pripona_metoda = ""

    if !plural
      case rod
        when "m"
          pripona_metoda = "ý"
        when "ž"
          pripona_bol    = "a"
          pripona_metoda = "á"
        when "s"
          pripona_bol    = "o"
          pripona_metoda = "é"
      end
    else
      case rod
        when "m"
          pripona_bol    = "i"
          pripona_metoda = "í"
        when "ž"
          pripona_bol    = "i"
          pripona_metoda = "é"
        when "s"
          pripona_bol    = "i"
          pripona_metoda = "é"
      end
    end

    notice << "bol"<< pripona_bol << " úspešne "

    if metoda == :create
      notice << "vytvoren"
    elsif metoda == :update
      notice << "aktualizovan"
    elsif metoda == :destroy
      notice << "vymazan"
    else
      notice << metoda.to_s
    end

    notice << pripona_metoda << "."
    return notice
  end

  def set_locale
    I18n.locale = if !session[:lang].blank?
                    session[:lang]
                  else
                    if %w(en sk).include? params[:lang]
                      params[:lang]
                    else
                      I18n.default_locale
                    end
                  end
  end

  def log_activity
    if current_user.try(:is_inex_office?)
      aname = action_name
      case action_name
        when "index"
          aname = "showed list of "
        when "show"
          aname = "showed detail for"
        when "destroy"
          aname = "removed"
        when "new"
          aname = "displayed new page for"
        when "edit"
          aname = "displayed edit page for"
        when "create"
          aname = "created"
        when "update"
          aname = "updated"
      end
      current_user.log_activities.create(action: aname, what: request.path)
    end
  end

  def permission_control
    if !Permission.can?(controller_name, action_name, current_user)
      redirect_to root_path, error: t(:you_dont_have_permissions_to_perform_this_action)
    end
  end
end
