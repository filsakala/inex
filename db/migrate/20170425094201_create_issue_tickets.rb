class CreateIssueTickets < ActiveRecord::Migration
  def change
    create_table :issue_tickets do |t|
      t.belongs_to :user, index: true
      t.string :description
      t.integer :priority
      t.boolean :is_done
      t.attachment :image

      t.timestamps null: false
    end
  end
end
