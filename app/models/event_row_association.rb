class EventRowAssociation < ActiveRecord::Base

  # Najde dany column v ulozenych asociaciach, Ak je v their_X viac vyplnenych, potom vrati [my, [their_X], id]
  def self.identify(col_name, eras = EventRowAssociation.all)
    t = EventRowAssociation.arel_table
    # Hladaj eras, kde niektory z parametrov je col_name (OR), reject vymaze blank elementy pola, BINARY = case sensitive search
    # eras.where(t[:my].eq(col_name).or(t[:their_1].eq(col_name)).or(t[:their_2].eq(col_name)).or(t[:their_3].eq(col_name)))
    eras.where("(BINARY `my` = ?) OR (BINARY `their_1` = ?) OR (BINARY `their_2` = ?) OR (BINARY `their_3` = ?)", col_name, col_name, col_name, col_name)
      .collect { |one| {my: one.my, their: [one.their_1, one.their_2, one.their_3].reject(&:blank?), era_id: one.id} }
  end

  def self.add(pairs = {})
    corrected_pairs = pairs
    if !pairs[:my].blank? && !pairs[:their_1].blank?
      if pairs[:their_2].blank? && !pairs[:their_3].blank?
        corrected_pairs[:their_2] = pairs[:their_3]
        corrected_pairs[:their_3] = nil
      end
      return EventRowAssociation.create(corrected_pairs)
    end
  end
end
