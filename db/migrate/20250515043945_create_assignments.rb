# frozen_string_literal: true

# Migration to create the assignments table, representing
# the association between members and projects with a specific role.
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
