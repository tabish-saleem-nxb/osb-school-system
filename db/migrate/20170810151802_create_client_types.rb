class CreateClientTypes < ActiveRecord::Migration
  def change
    create_table :client_types do |t|
      t.string :title
      t.integer :penalty_rule_id
      t.integer :term_rule_id
      t.timestamps
    end
  end
end
