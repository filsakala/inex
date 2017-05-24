class User < ActiveRecord::Base
  has_secure_password
  attr_accessor :terms_of_service

  has_many :trainers # do not destroy
  has_many :local_partners # do not destroy
  has_many :leaders # do not destroy

  has_one :employee, dependent: :destroy # Employee without access does not make sense
  has_many :addresses, dependent: :destroy
  has_many :participation_fees # do not destroy!

  has_many :event_lists, dependent: :destroy
  has_many :volunteers, through: :event_lists
  belongs_to :education

  has_many :issue_tickets
  has_many :log_activities # do not destroy

  # attr_accessor :password, :password_confirmation
  validates :login_mail, presence: { message: I18n.t(:login_mail_have_to_be_filled) },
            uniqueness: { message: I18n.t(:login_mail_already_exists) },
            format: {
              with: /@/,
              message: I18n.t(:enter_email_in_correct_format)
            }

  validates :name, presence: { message: I18n.t(:name_have_to_be_filled) }
  validates :surname, presence: { message: I18n.t(:surname_have_to_be_filled) }

  # Zadávanie hesla
  validates :password, presence: { :message => I18n.t(:password_have_to_be_filled) },
            if: :perform_validation?
  validates :password_confirmation, presence: { :message => I18n.t(:password_confirmation_have_to_be_filled) },
            if: :perform_validation?
  validates :sex, inclusion: { in: ["M", "Ž", 'W', nil],
                               message: I18n.t(:gender_have_to_be_m_or_z) }

  validates_acceptance_of :terms_of_service, :message => I18n.t(:application_without_aggreement_of_terms_for_registration_is_not_possible)

  accepts_nested_attributes_for :addresses, allow_destroy: true,
                                reject_if: proc { |attributes| attributes['address'].blank? }

  attr_accessor :perform_password_validation

  def is_employee?
    role == "employee"
  end

  def is_evs?
    role == "evs" || role == "eds"
  end

  def is_inex_member?
    is_employee? || is_evs?
  end

  def is_active?
    state == 'active' || state == 'aktívny'
  end

  def authenticate_active(pwd)
    authenticate(pwd) && is_active?
  end

  def name_with_mail
    "#{name || "???"} #{surname || "???"} (#{nickname || "???"}) - #{login_mail}"
  end

  def name_surname
    "#{name} #{surname}"
  end

  def surname_name
    "#{surname} #{name}"
  end

  def nickname_or_name
    if nickname.blank? || nickname == "???"
      name
    else
      nickname
    end
  end

  def both_mails
    "#{login_mail}, #{personal_mail}" if !personal_mail.blank?
    login_mail if personal_mail.blank?
  end

  def personal_mail_or_login_mail
    if personal_mail.blank?
      login_mail
    else
      personal_mail
    end
  end

  def user_event_list(is_child)
    if @el.blank?
      @el = event_lists.where(is_child: is_child).where(state: 'opened').take
      if !@el # skip validation!
        @el = event_lists.new
        @el.state = 'opened'
        @el.is_child = false
        @el.save(validate: false)
      end
      @el
    end
  end

  # TODO: potrebujes vek v case konania eventu
  def age
    User.age(birth_date)
  end

  def self.age(birth_date)
    unless birth_date.blank?
      today = Date.today
      age = today.year - birth_date.year
      age -= 1 if birth_date.strftime("%m%d").to_i > today.strftime("%m%d").to_i
      age
    end
  end

  def sex_en
    if sex == 'Ž' || sex == 'W'
      'W'
    elsif sex == 'M'
      'M'
    end
  end

  # Vypisal prihlasku v tomto roku (nemusi mat zaplatene!!!)
  def je_clen?(year = Date.today.year)
    created_at_field = EventList.arel_table[:created_at]
    this_year_event_lists = event_lists.where(is_child: false).where(created_at_field.gteq(Date.parse("01-01-#{year}"))
                                                                       .and(created_at_field.lteq(Date.parse("31-12-#{year}"))))
    this_year_event_lists.each do |event_list|
      if event_list.event_type && event_list.event_type.title == 'Prihlášky za člena'
        return true
      end
    end
    return false
  end

  # Platil clenske v tomto roku
  def je_clen_a_platil?(year = Date.today.year)
    created_at_field = EventList.arel_table[:created_at]
    this_year_event_lists = event_lists.where(is_child: false).where(created_at_field.gteq(Date.parse("01-01-#{year}"))
                                                                       .and(created_at_field.lteq(Date.parse("31-12-#{year}"))))
    this_year_event_lists.each do |event_list|
      if event_list.event_type && event_list.event_type.title == 'Prihlášky za člena'
        if event_list.participation_fees.sum(:amount) == 2
          return true
        end
      end
    end
    return false
  end

  private
  def perform_validation?
    perform_password_validation || perform_password_validation.nil?
  end

end
