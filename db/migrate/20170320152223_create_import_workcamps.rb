class CreateImportWorkcamps < ActiveRecord::Migration
  def change
    create_table :import_workcamps do |t|

      t.timestamps null: false
    end
  end
end
