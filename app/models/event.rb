class Event < ActiveRecord::Base
  belongs_to :organization
  belongs_to :event_type

  has_many :event_with_categories, dependent: :destroy
  has_many :event_categories, through: :event_with_categories

  has_many :extra_fees, dependent: :destroy
  accepts_nested_attributes_for :extra_fees, allow_destroy: true,
                                reject_if:                  proc { |attributes| attributes['name'].blank? }

  has_many :event_documents, dependent: :destroy
  accepts_nested_attributes_for :event_documents, allow_destroy: true,
                                reject_if:                       proc { |attributes| attributes['title'].blank? }


  has_many :event_in_lists, dependent: :destroy
  has_many :event_lists, through: :event_in_lists

  has_many :volunteers
  has_many :trainers
  has_many :local_partners
  has_many :leaders

  validates_presence_of :title, message: I18n.t(:title_have_to_be_filled)
  validates :capacity_men, numericality: {
    greater_than_or_equal_to: 0, message: I18n.t(:capacity_have_to_be_at_least_zero) }
  validates :capacity_women, numericality: {
    greater_than_or_equal_to: 0, message: I18n.t(:capacity_have_to_be_at_least_zero) }
  validates :capacity_total, numericality: {
    greater_than_or_equal_to: 0, message: I18n.t(:capacity_have_to_be_at_least_zero) }
  validates :free_men, numericality: {
    greater_than_or_equal_to: 0, message: I18n.t(:capacity_have_to_be_at_least_zero) }
  validates :free_women, numericality: {
    greater_than_or_equal_to: 0, message: I18n.t(:capacity_have_to_be_at_least_zero) }
  validates :free_total, numericality: {
    greater_than_or_equal_to: 0, message: I18n.t(:capacity_have_to_be_at_least_zero) }
  validates :min_age, numericality: {
    greater_than_or_equal_to: 0, message: I18n.t(:age_should_be_at_least_zero) }
  validates :max_age, numericality: {
    greater_than_or_equal_to: 0, message: I18n.t(:age_should_be_at_least_zero) }
  validate :capacity_free_total_are_sum

  # Kontroluje, že total kapacita je súčtom ženy + muži
  def capacity_free_total_are_sum
    if ignore_sex_for_capacity != true
      if capacity_total != capacity_men + capacity_women
        errors.add(:capacity_total, I18n.t(:total_capacity_should_be_sum_of_men_and_women))
      end
      if free_total != free_men + free_women
        errors.add(:free_total, "Free places #{I18n.t(:total_capacity_should_be_sum_of_men_and_women).downcase}")
      end
    end
  end

  def from_to
    if !from.blank? && !to.blank? # from, to
      return "#{from.strftime("%d.%m.")} - #{to.strftime("%d.%m.%Y")}" if is_only_date
      return "#{from.strftime("%d.%m.%Y")} #{from.strftime("%H:%M")} - #{to.strftime("%d.%m.%Y")} #{to.strftime("%H:%M")}"
    end
    if !from.blank? # from
      return "#{from.strftime("%d.%m.%Y")}" if is_only_date
      return "#{from.strftime("%d.%m.%Y")} #{from.strftime("%H:%M")}"
    end
    if !to.blank? # to
      return "#{to.strftime("%d.%m.%Y")}" if is_only_date
      return "#{to.strftime("%d.%m.%Y")} #{to.strftime("%H:%M")}"
    end
    "" # nothing
  end

  def code_or_code_alliance
    if !code.blank?
      code
    else
      code_alliance
    end
  end

  # title for selected language
  def translated_title
    if I18n.locale == :en && !title_en.blank?
      title_en
    else
      title
    end
  end

  # Pre kalendár
  def start_time
    self.from #.to_date # is an attribute of type 'Date' accessible through MyModel's relationship
  end

  def can_be_added_to_bag(current_user)
    if is_cancelled || !is_published || capacity_total == 0 || free_total == 0 ||
      (registration_deadline && registration_deadline < DateTime.now)
      false
    else
      if ignore_sex_for_capacity != true
        if current_user && ((current_user.sex == 'M' && (capacity_men == 0 || free_men == 0)) ||
          ((current_user.sex == 'Ž' || current_user.sex == 'W') && (capacity_women == 0 || free_women == 0)) ||
          (current_user.age && (current_user.age < min_age || current_user.age > max_age)))
          false
        else
          true
        end
      else
        if current_user && current_user.age && (current_user.age < min_age || current_user.age > max_age)
          false
        else
          true
        end
      end
    end
  end

  def can_be_registered(current_user)
    if can_be_added_to_bag(current_user)
      true
    else
      false
    end
  end

  # GPS treba refreshnut, ak je v tomto evente prazdne alebo parametre formulara su prazdne (sme vymazali)
  # A zaroven ak je vyplnena adresa a/alebo mesto a/alebo stat
  def gps_needs_to_be_refreshed?(param_lat, param_lon)
    is_not_filled_gps = (param_lat.blank? && param_lon.blank?)
    is_filled_address = (!address.blank? || !city.blank? || !country.blank?)
    if is_not_filled_gps && is_filled_address
      true
    else
      false
    end
  end

end
