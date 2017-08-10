class CreateLateFees < ActiveRecord::Migration
  def change
    create_table :late_fees do |t|

      t.timestamps
    end
  end
end
