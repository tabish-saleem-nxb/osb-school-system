class AddClientTypeIdToClient < ActiveRecord::Migration
  def change
    add_column :clients, :client_type_id, :integer
  end
end
