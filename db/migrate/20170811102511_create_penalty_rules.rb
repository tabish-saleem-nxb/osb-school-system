class CreatePenaltyRules< ActiveRecord::Migration
  def change
    create_table :penalties do |t|
      t.string :name
      t.text :description
      t.date :due_date
      t.integer :percentage

      t.timestamps
    end
  end
end
