class AddFeeDateAltEmailGrade < ActiveRecord::Migration
  def change
    add_column :clients, :fee_date, :date
    add_column :clients, :parent_alt_email, :string
    add_column :clients, :grade, :string
  end
end
