class CreateParticipationFees < ActiveRecord::Migration
  def change
    create_table :participation_fees do |t|
      t.belongs_to :user, index: true
      t.belongs_to :event_list, index: true

      t.float :amount
      t.date :date
      t.text :notes, limit: 2048
      t.string :pay_type, limit: 128

      t.timestamps null: false
    end
  end
end
