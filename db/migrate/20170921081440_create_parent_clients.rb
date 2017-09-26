class CreateParentClients < ActiveRecord::Migration
  def change
    create_table :parent_clients do |t|
      t.string :organization_name
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :mobile_number
      t.string :home_number
      t.string :business_phone
      t.string :country
      t.string :address_street1
      t.string :address_street2
      t.string :city
      t.string :industry
      t.string :province
      t.string :postal_zip_code
      t.string :fax
      t.text :internal_notes
      t.string :archive_number
      t.datetime :archived_at
      t.datetime :deleted_at
      t.decimal :available_credit
      t.integer :currency_id

      t.timestamps
    end
  end
end
