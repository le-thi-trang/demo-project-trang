class CreateAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :assignments do |t|
      t.references :project, null: false, foreign_key: true
      t.references :member, null: false, foreign_key: true
      t.integer :role, null: false

      t.timestamps
    end
  end
end
