class RemoveClientTypeFromTermRule < ActiveRecord::Migration
  def change
    remove_column :term_rules, :client_type_id, :string
  end
end
