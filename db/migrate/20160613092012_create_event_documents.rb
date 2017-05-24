class CreateEventDocuments < ActiveRecord::Migration
  def change
    create_table :event_documents do |t|
      t.belongs_to :event, index: true

      t.string :title, limit: 128
      t.boolean :is_mandatory

      t.timestamps null: false
    end
  end
end
