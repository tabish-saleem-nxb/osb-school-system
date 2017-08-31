#TODO: 3 Add this migration with generator for TERM INVOICES
class CreateClientTypes < ActiveRecord::Migration
  def change
    create_table :client_types do |t|
      t.string :title

      t.timestamps
    end
  end
end
