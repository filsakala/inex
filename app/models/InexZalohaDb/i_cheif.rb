class ICheif < DatabaseTransformator
  self.table_name = "i_cheif"
  # Ignore:
  # OK: _title (toto je meno a priezvisko), _degree (napr. Bc.), _active (1=su aktivni teraz, u mna asi netreba...),
  # _name, _surname, _street, _city, _postalcode, _birthplace, _op (obciansky asi neukladas?), _email, _phone,
  # _login (meno.priezvisko), _password (SHA), _chief_job_id (i_chief_job.id), _birthdate, _conditions (0/1 ???)
  # _rc, _acc_number (asi neukladas), _chief_role_id (1=veduci vs 2=local partner?)
  #
  # Toto su user data + User.local_partner/user.leader
  has_many :i_chief2camps, :foreign_key => '_chief_id'
  has_many :i_chief2workcamps, :foreign_key => '_chief_id'


  def self.transform
    # ICheif.all.each do |ch|
    #   next if ch.deletedtime != 0 # Ak je zmazany
    #
    # end
  end
end