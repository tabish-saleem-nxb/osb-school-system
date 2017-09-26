json.array!(@parent_clients) do |parent_client|
  json.extract! parent_client, :id, :first_name, :last_name, :email, :mobile_number, :home_number, :business_phone, :string, :country, :address_street1, :address_street2, :city, :industry, :province, :postal_zip_code, :fax, :internal_notes, :archive_number, :archived_at, :deleted_at, :available_credit, :currency_id
  json.url parent_client_url(parent_client, format: :json)
end
