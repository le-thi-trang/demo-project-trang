class RenameTypeToProjectTypeInProjects < ActiveRecord::Migration[8.0]
  def change
    rename_column :projects, :type, :project_type
  end
end
