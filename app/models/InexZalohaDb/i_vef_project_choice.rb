class IVefProjectChoice < DatabaseTransformator
  self.table_name = "i_vef_project_choices"
  # !!! Niektore nemaju _workcamp_id (=0), tie drzo ignorujem...
  belongs_to :i_workcamp, :foreign_key => '_workcamp_id'
end