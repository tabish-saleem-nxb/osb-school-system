module SimpleInvoice
  class InvoiceTask < ActiveRecord::Base

    belongs_to :invoice

  end
end
