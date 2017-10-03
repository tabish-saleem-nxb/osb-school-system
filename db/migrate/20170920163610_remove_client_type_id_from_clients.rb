class RemoveClientTypeIdFromClients < ActiveRecord::Migration
  def change
    remove_column :clients, :client_type_id, :integer
  end
end
