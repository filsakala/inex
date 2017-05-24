class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.belongs_to :user, index: true

      t.string :department, limit: 128
      t.string :work_mail, limit: 128
      t.string :work_phone, limit: 128

      t.timestamps null: false
    end
  end
end
