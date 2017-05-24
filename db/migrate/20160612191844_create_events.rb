class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.belongs_to :organization, index: true
      t.belongs_to :event_type, index: true

      t.string :title, limit: 512
      t.string :title_en, limit: 512
      t.datetime :from
      t.datetime :to
      t.boolean :is_only_date
      t.string :code, limit: 256
      t.string :code_alliance, limit: 256

      t.string :country, limit: 64
      t.string :city, limit: 2048
      t.text :address, limit: 512
      t.string :gps_latitude, limit: 32
      t.string :gps_longitude, limit: 32

      t.text :notes, limit: 2048
      t.string :airport, limit: 2048
      t.string :bus_train, limit: 2048

      t.integer :capacity_men, default: 0
      t.integer :capacity_women, default: 0
      t.integer :capacity_total, default: 0
      t.integer :free_men, default: 0
      t.integer :free_women, default: 0
      t.integer :free_total, default: 0

      t.integer :min_age, default: 0
      t.integer :max_age, default: 100

      t.text :fees_sk, limit: 2048
      t.text :fees_en, limit: 2048

      t.datetime :registration_deadline
      t.boolean :is_simple_registration
      t.boolean :can_create_member_registration

      t.string :evaluation_url_leader, limit: 256
      t.datetime :evaluation_deadline_leader
      t.string :evaluation_url_local_partner, limit: 256
      t.datetime :evaluation_deadline_local_partner
      t.string :evaluation_url_volunteer, limit: 256
      t.datetime :evaluation_deadline_volunteer

      t.boolean :is_published, default: false # Bude publikovany manualne

      # SCI DB
      t.text :introduction_sk, limit: 2048
      t.text :type_of_work_sk, limit: 2048
      t.text :study_theme_sk, limit: 2048
      t.text :accomodation_sk, limit: 2048
      t.text :camp_advert_sk, limit: 2048
      t.text :language_description_sk, limit: 2048
      t.text :requirements_sk, limit: 2048
      t.text :location_sk, limit: 2048
      t.text :additional_camp_notes_sk, limit: 2048

      t.text :introduction_en, limit: 2048
      t.text :type_of_work_en, limit: 2048
      t.text :study_theme_en, limit: 2048
      t.text :accomodation_en, limit: 2048
      t.text :camp_advert_en, limit: 2048
      t.text :language_description_en, limit: 2048
      t.text :requirements_en, limit: 2048
      t.text :location_en, limit: 2048
      t.text :additional_camp_notes_en, limit: 2048

      t.string :required_spoken_language, limit: 256
      t.boolean :is_cancelled, default: false

      t.timestamps null: false
    end
  end
end
