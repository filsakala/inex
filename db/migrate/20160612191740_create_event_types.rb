class CreateEventTypes < ActiveRecord::Migration
  def change
    create_table :event_types do |t|
      t.belongs_to :super_event_type, index: true
      t.string :title, limit: 128
      t.belongs_to :employee, index: true # Zodpovedny zamestnanec
      t.boolean :can_send_registration_mail

      t.float :fee_member_first
      t.float :fee_non_member_first
      t.float :fee_member_other
      t.float :fee_non_member_other
      t.text :fee_description, limit: 2048

      t.text :application_conditions_html, limit: 4096
      t.text :application_conditions_agreement_html, limit: 2048
      t.text :application_info_html, limit: 4096

      t.timestamps null: false
    end
  end
end
