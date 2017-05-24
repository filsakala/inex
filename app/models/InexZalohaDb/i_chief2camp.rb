class IChief2camp < DatabaseTransformator
  self.table_name = "i_chief2camp"
  # OK: _chief_id, _camp_id (toto je spojovacia tabulka i_cheif.id a i_camp.id)
  belongs_to :i_cheif, :foreign_key => '_chief_id'
  belongs_to :i_camp, :foreign_key => '_camp_id'

end