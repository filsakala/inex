class CreateEmployeeWithKnowledges < ActiveRecord::Migration
  def change
    create_table :employee_with_knowledges do |t|
      t.belongs_to :employee, index: true
      t.belongs_to :knowledge, index: true

      t.timestamps null: false
    end
  end
end
