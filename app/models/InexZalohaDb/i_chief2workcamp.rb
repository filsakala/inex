class IChief2workcamp < DatabaseTransformator
  self.table_name = "i_chief2workcamp"
  # OK: _chief_id, _workcamp_id (toto je spojovacia tabulka i_cheif.id a i_workcamp.id)
  belongs_to :i_cheif, :foreign_key => '_chief_id'
  belongs_to :i_workcamp, :foreign_key => '_workcamp_id'

end