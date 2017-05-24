class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  add_flash_types :error, :warning, :success
  before_action :is_active
  before_action :set_articles
  before_action :set_locale
  before_action :log_activity
  before_action :permission_control

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

  def set_articles
    @partners = HomepagePartner.order(:text)
    @articles ||= {
      o_nas: HtmlArticle.where(category: 'o_nas'),
      aktivity: HtmlArticle.where(category: 'aktivity'),
      pomoz: HtmlArticle.where(category: 'pomoz'),
      pomoz_financne: HtmlArticle.where(category: 'pomoz_financne'),
      media: HtmlArticle.where(category: 'media'),
      tabory_panel: HomepageCard.where(is_visible: true),
      podpora: HtmlArticle.where(category: 'podpora'),
      footer: HtmlArticle.where(category: 'footer'),
    }
    @faq = HtmlArticle.where(category: 'faq').take
    @membership = HtmlArticle.where(category: 'membership').take
    @terms_and_conditions = HtmlArticle.where(category: 'terms_and_conditions').take
    if current_user
      @my_bag = current_user.user_event_list(false)
      @events_in_bag_count = @my_bag ? @my_bag.events.count : 0
      # Employee menu
      @undone_tasks = 0
      if current_user.employee
        @undone_tasks = current_user.employee.tasks.joins(:task_lists).where(task_lists: { state: "nedokončená" }).pluck("tasks.id").uniq.count
      end
    else
      @events_in_bag_count = 0
      @undone_tasks = 0
    end
    @kontakty = {}
    @kontakty[:person_incoming_name] = HtmlArticle.where(category: 'kontakty_person_incoming_name').take
    @kontakty[:person_incoming_mail] = HtmlArticle.where(category: 'kontakty_person_incoming_mail').take
    @kontakty[:person_outgoing_name] = HtmlArticle.where(category: 'kontakty_person_outgoing_name').take
    @kontakty[:person_outgoing_mail] = HtmlArticle.where(category: 'kontakty_person_outgoing_mail').take
    @kontakty[:person_eds_name] = HtmlArticle.where(category: 'kontakty_person_eds_name').take
    @kontakty[:person_eds_mail] = HtmlArticle.where(category: 'kontakty_person_eds_mail').take
  end

=begin
    Vytvorí notice hlášku typu: XYZ bol úspešne vytvorený.
    @param rod mužský/ženský/stredný
    @param metoda create/update/destroy
    @return notice Notice hláška
=end

  def define_notice_en(rod = "m", metoda = nil, plural = false)
    notice = ""
    if plural
      notice << "were"
    else
      notice << "was"
    end
    notice << " successfully "

    if metoda == :create
      notice << "created"
    elsif metoda == :update
      notice << "updated"
    elsif metoda == :destroy
      notice << "destroyed"
    else
      notice << metoda.to_s
    end

    notice << "."
    return notice
  end

  def define_notice(rod = "m", metoda = nil, plural = false)
    return define_notice_en(rod, metoda, plural) if params[:lang] == "en"
    notice = ""
    pripona_bol = ""
    pripona_metoda = ""

    if !plural
      case rod
        when "m"
          pripona_metoda="ý"
        when "ž"
          pripona_bol="a"
          pripona_metoda="á"
        when "s"
          pripona_bol="o"
          pripona_metoda="é"
      end
    else
      case rod
        when "m"
          pripona_bol="i"
          pripona_metoda="í"
        when "ž"
          pripona_bol="i"
          pripona_metoda="é"
        when "s"
          pripona_bol="i"
          pripona_metoda="é"
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
    if !session[:lang].blank?
      I18n.locale = session[:lang]
    else
      if params[:lang] == "en" || params[:lang] == "sk"
        I18n.locale = params[:lang]
      else
        I18n.locale = I18n.default_locale
      end
    end
  end

  def log_activity
    if current_user && current_user.is_inex_member?
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
    action = action_name
    controller = controller_name
    if !Permission.can?(controller, action, current_user)
      redirect_to root_path, error: t(:you_dont_have_permissions_to_perform_this_action)
    end
  end
end
