class AddArrearsInvoiceIdToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :arrear_invoice_id, :integer
  end
end
