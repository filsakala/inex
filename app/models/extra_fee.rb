class ExtraFee < ActiveRecord::Base
  belongs_to :event

  def name_amount_currency
    if name.blank?
      "#{amount} #{currency}"
    else
      "#{name} #{amount} #{currency}"
    end
  end
end
