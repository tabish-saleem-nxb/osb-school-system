class RemoveGradeColumnFromClients < ActiveRecord::Migration
  def change
    remove_column :clients, :grade, :string
  end
end
