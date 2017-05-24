class CreateEventLists < ActiveRecord::Migration
  def change
    create_table :event_lists do |t|
      t.belongs_to :user, index: true
      t.belongs_to :education, index: true
      t.boolean :is_child

      t.string :state, default: 'opened', limit: 128

      t.string :name, limit: 128
      t.string :surname, limit: 128

      t.date :birth_date
      t.string :place_of_birth, limit: 128
      t.string :nationality, limit: 128
      t.string :occupation, limit: 128

      t.string :sex, limit: 32
      t.string :personal_mail, limit: 128
      t.string :personal_phone, limit: 128

      # Prihlaska priamo
      t.string :emergency_phone, limit: 128
      t.string :emergency_name, limit: 128
      t.string :emergency_mail, limit: 128

      t.text :experiences, limit: 2048
      t.text :why, limit: 2048
      t.text :remarks, limit: 2048
      t.text :on_health, limit: 2048

      t.timestamps null: false
    end
  end
end
