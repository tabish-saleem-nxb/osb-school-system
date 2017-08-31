#TODO: 3 Add this migration with generator for TERM INVOICES
class CreateTermRules < ActiveRecord::Migration
  def change
    create_table :term_rules do |t|
      t.string :name
      t.text :description
      t.string :frequency
      t.integer :client_type_id

      t.timestamps
    end
  end
end
