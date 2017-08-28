SimpleInvoice::Engine.routes.draw do
  scope "(:locale)" do
    post '/invoices/send_note_only' => 'invoices#send_note_only'
    get 'invoices/unpaid_invoices' => 'invoices#unpaid_invoices'

    resources :invoices

    post '/invoices/delete_invoices_with_payments' => 'invoices#delete_invoices_with_payments'
    post '/invoices/dispute_invoice' => 'invoices#dispute_invoice'
    post '/invoices/pay_with_credit_card' => 'invoices#pay_with_credit_card'
  end
end
