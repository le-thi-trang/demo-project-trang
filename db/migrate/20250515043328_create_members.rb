# frozen_string_literal: true

# Migration to create the `members` table.
# Includes personal information, contact details, position, and timestamps.
class CreateMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :members do |t|
      t.string :name, null: false, limit: 50
      t.string :information, limit: 300
      t.string :phone_number, null: false, limit: 20
      t.date :date_of_birth, null: false
      t.integer :position, null: false

      t.timestamps
    end
  end
end
