class AddGradeIdToClientAndItem < ActiveRecord::Migration
  def change
    add_column :clients, :grade_id, :integer
    add_column :items, :grade_id, :integer
    add_column :items, :account_id, :integer
  end
end
