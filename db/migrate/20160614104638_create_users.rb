class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.belongs_to :employee, index: true
      t.belongs_to :education, index: true

      t.string :login_mail, limit: 128
      t.string :password_digest, limit: 128
      t.string :state, default: 'active', limit: 128
      t.string :role, limit: 128

      t.string :name, limit: 128
      t.string :surname, limit: 128

      t.date :birth_date
      t.string :place_of_birth, limit: 128
      t.string :nationality, limit: 128
      t.string :occupation, limit: 128

      t.string :nickname, limit: 128
      t.string :sex, default: 'M', limit: 32
      t.string :personal_mail, limit: 128
      t.string :personal_phone, limit: 128
      t.text :other_contacts, limit: 1024

      t.timestamps null: false
    end
  end
end
