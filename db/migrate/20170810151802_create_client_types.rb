class CreateClientTypes < ActiveRecord::Migration
  def change
    create_table :client_types do |t|
      t.string :title
      t.integer :late_fee_id

      t.timestamps
    end
  end
end
