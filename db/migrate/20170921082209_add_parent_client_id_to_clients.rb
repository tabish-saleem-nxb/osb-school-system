class AddParentClientIdToClients < ActiveRecord::Migration
  def change
    add_column :clients, :parent_client_id, :integer
  end
end
