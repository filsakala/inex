class CreateLanguageSkills < ActiveRecord::Migration
  def change
    create_table :language_skills do |t|
      t.belongs_to :language, index: true
      t.belongs_to :event_list, index: true

      t.string :level, limit: 128

      t.timestamps null: false
    end
  end
end
