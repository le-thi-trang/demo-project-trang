class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :information
      t.datetime :deadline
      t.integer :type, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
