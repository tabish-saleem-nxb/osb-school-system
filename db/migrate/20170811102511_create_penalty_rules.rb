class CreatePenaltyRules< ActiveRecord::Migration
  def change

    create_table :penalty_rules do |t|
      t.string :name
      t.text :description
      t.date :due_date
      t.integer :percentage
      t.integer :client_type_id

      t.timestamps
    end
  end
end
