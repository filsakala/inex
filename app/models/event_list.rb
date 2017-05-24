class EventList < ActiveRecord::Base
  attr_accessor :conditions_agreement
  attr_accessor :check_conditions_agreement
  attr_accessor :form_type
  attr_accessor :inex_member

  belongs_to :user
  belongs_to :education

  has_many :event_in_lists, dependent: :destroy
  has_many :events, through: :event_in_lists
  has_many :language_skills, dependent: :destroy
  has_many :addresses, dependent: :destroy # is not the same as for user
  has_many :participation_fees, dependent: :nullify # Do not destroy
  has_many :volunteers, dependent: :destroy

  accepts_nested_attributes_for :language_skills, allow_destroy: true,
                                reject_if: proc { |attributes| !["Mother tongue", "Very good", 'Good', 'Basic', nil].include?(attributes['level']) ||
                                  attributes['language_id'].blank? }
  accepts_nested_attributes_for :addresses, allow_destroy: true,
                                reject_if: proc { |attributes| attributes['address'].blank? || attributes['title'].blank? ||
                                  attributes['postal_code'].blank? || attributes['city'].blank? || attributes['country'].blank? }

  validate :phone_format
  validate :conditions_agreement_set

  # +421 905 501 078
  def phone_format
    if !personal_phone.blank? && !/^\+([[:digit:]]{1,3}[[:blank:]]){3,}[[:digit:]]{1,3}$/.match(personal_phone.strip)
      errors.add(:personal_phone, I18n.t(:phone_number_is_not_in_correct_format))
    end
    if !emergency_phone.blank? && !/^\+([[:digit:]]{1,3}[[:blank:]]){3,}[[:digit:]]{1,3}$/.match(emergency_phone.strip)
      errors.add(:emergency_phone, I18n.t(:phone_number_is_not_in_correct_format))
    end
  end

  def conditions_agreement_set
    if check_conditions_agreement != false
      if form_type == 'full'
        if (!conditions_agreement || conditions_agreement == '0')
          errors.add(:conditions_agreement, I18n.t(:application_without_aggreement_of_terms_is_not_possible))
        end
        unless addresses.any?
          errors.add(:addresses, I18n.t(:address_have_to_be_filled))
        end
        validates_presence_of :name, message: I18n.t(:name_have_to_be_filled)
        validates_presence_of :surname, message: I18n.t(:surname_have_to_be_filled)
        validates_presence_of :sex, message: I18n.t(:gender_have_to_be_filled)
        validates_inclusion_of :sex, { in: ["M", 'W'],
                                       message: I18n.t(:gender_have_to_be_m_or_w) }
        validates_presence_of :birth_date, message: I18n.t(:birth_date_have_to_be_filled)
        validates_presence_of :place_of_birth, message: I18n.t(:place_of_birth_have_to_be_filled)
        validates_presence_of :nationality, message: I18n.t(:nationality_have_to_be_filled)
        validates_presence_of :occupation, message: I18n.t(:occupation_have_to_be_filled)
        validates_inclusion_of :occupation, { in: ['Student', 'Employed', 'Unemployed', 'Other'],
                                              message: I18n.t(:occupation_should_be_in) }
        validates_presence_of :education_id, message: I18n.t(:education_have_to_be_filled)
        validates_presence_of :personal_mail, message: I18n.t(:personal_mail_have_to_be_filled)
        validates_exclusion_of :personal_mail, :in => ["in@inex.sk", "inex@inex.sk", "out@inex.sk", "eds@inex.sk", "finance@inex.sk", "noreply@inex.sk", "info@inex.sk"], message: "Email musí byť tvoj, nie náš."
        #validates_format_of :personal_mail, with: /@/, message: I18n.t(:enter_email_in_correct_format)
        validates_presence_of :personal_phone, message: I18n.t(:phone_have_to_be_filled)
        validates_exclusion_of :personal_phone, :in => ["+421 905 501 078"], message: "Telefónne číslo musí byť tvoje a nie naše."
        validates_presence_of :emergency_name, message: I18n.t(:emergency_name_have_to_be_filled)
        validates_presence_of :emergency_mail, message: I18n.t(:emergency_mail_have_to_be_filled)
        validates_exclusion_of :emergency_mail, :in => ["in@inex.sk", "inex@inex.sk", "out@inex.sk", "eds@inex.sk", "finance@inex.sk", "noreply@inex.sk", "info@inex.sk"], message: "Email musí byť tvoj, nie náš."
        #validates :emergency_mail, format: { with: /@/, message: I18n.t(:enter_email_in_correct_format) }
        validates_presence_of :emergency_phone, message: I18n.t(:emergency_phone_have_to_be_filled)
        validates_exclusion_of :emergency_phone, :in => ["+421 905 501 078"], message: "Telefónne číslo musí byť tvoje a nie naše."
        validates_presence_of :experiences, message: I18n.t(:experiences_have_to_be_filled)
        validates_presence_of :why, message: I18n.t(:why_have_to_be_filled)
        validates_length_of :why, minimum: 350, message: I18n.t(:why_350_have_to_be_filled)
        if is_child == true && User.age(birth_date).to_i > 15
          errors.add(:birth_date, I18n.t(:child_registration_under_15_only))
        end
        if (self.personal_phone == self.emergency_phone)
          errors.add(:emergency_phone, "Emergency telefónne číslo musí byť rôzne od tvojho.")
        end
        if (self.personal_mail == self.emergency_mail)
          errors.add(:emergency_mail, "Emergency mail musí byť rôzne od tvojho.")
        end
      elsif form_type == 'simple'
        if (!conditions_agreement || conditions_agreement == '0')
          errors.add(:conditions_agreement, I18n.t(:application_without_aggreement_of_terms_is_not_possible))
        end
        validates_presence_of :name, message: I18n.t(:name_have_to_be_filled)
        validates_presence_of :surname, message: I18n.t(:surname_have_to_be_filled)
        validates_presence_of :personal_mail, message: I18n.t(:personal_mail_have_to_be_filled)
        validates_format_of :personal_mail, with: /@/, message: I18n.t(:enter_email_in_correct_format)
        validates_exclusion_of :personal_mail, :in => ["in@inex.sk", "inex@inex.sk", "out@inex.sk", "eds@inex.sk", "finance@inex.sk", "noreply@inex.sk", "info@inex.sk"], message: "Email musí byť tvoj, nie náš."
        validates_presence_of :personal_phone, message: I18n.t(:phone_have_to_be_filled)
        validates_exclusion_of :personal_phone, :in => ["+421 905 501 078"], message: "Telefónne číslo musí byť tvoje a nie naše."
        if inex_member == '1'
          validates_presence_of :birth_date, message: I18n.t(:birth_date_have_to_be_filled)
          unless addresses.any?
            errors.add(:addresses, I18n.t(:address_have_to_be_filled))
          end
        end
      else
        errors.add(:conditions_agreement, I18n.t(:wrong_form_type_was_submitted))
      end
    end
  end

  def event_type
    events.first.event_type if events.any?
  end

  def event_types
    types = Set.new
    if events.any?
      events.each do |event|
        types << event.event_type if event.event_type
      end
    end
    types
  end

  def is_first_application_this_year?(event_type, creation_year)
    return true if !event_type
    created_at_field = EventList.arel_table[:created_at]
    uels = user.event_lists
      .where(created_at_field.gteq(Date.new(creation_year, 1, 1)))
      .where(created_at_field.lteq(Date.new(creation_year, 12, 31)))
      .where("`state` != ?", 'storno') # Nerataj storno prihlasky
      .where("`state` != ?", 'opened') # Nerataj nesubmitted prihlasky
      .where("`state` != ?", 'reopened') # Nerataj nesubmitted prihlasky
    uels.each do |uel| # Cekni, ze aspon za jeden z nich platil tu plnu sumu
      if uel.event_type == event_type # Nasiel sa dalsi s rovnakym typom
        paid_for_this = uel.participation_fees.sum(:amount)
        if uel.user.je_clen? && event_type.fee_member_first.to_f <= paid_for_this
          return false
        elsif event_type.fee_non_member_first.to_f <= paid_for_this
          return false
        end
      end
    end
    return true
  end

  def to_pay(user)
    to_pay = 0.0
    to_pay += events.joins(:extra_fees).where(extra_fees: { is_paid_to_inex: true }).sum(:amount)
    if event_type
      if event_type.try(:title) == 'Prihlášky za člena'
        if user.je_clen_a_platil?
          to_pay = 0
        else
          to_pay = 2
        end
      else
        if user.je_clen?
          if is_first_application_this_year?(event_type, created_at.year)
            to_pay += event_type.fee_member_first.to_f
          else
            to_pay += event_type.fee_member_other.to_f
          end
        else
          if is_first_application_this_year?(event_type, created_at.year)
            to_pay += event_type.fee_non_member_first.to_f
          else
            to_pay += event_type.fee_non_member_other.to_f
          end
        end
      end
    end
    to_pay
  end

  def is_paid?(user)
    paid = participation_fees.sum(:amount)
    return paid >= to_pay(user)
  end
end
