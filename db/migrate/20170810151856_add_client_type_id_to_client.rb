#TODO: 3 Add this migration with generator for TERM INVOICES
class AddClientTypeIdToClient < ActiveRecord::Migration
  def change
    add_column :clients, :client_type_id, :integer
  end
end
