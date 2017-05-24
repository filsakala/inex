class CreateExtraFees < ActiveRecord::Migration
  def change
    create_table :extra_fees do |t|
      t.belongs_to :event, index: true

      t.float :amount
      t.string :name, limit: 128
      t.string :currency, limit: 32
      t.boolean :is_paid_to_inex

      t.timestamps null: false
    end
  end
end
