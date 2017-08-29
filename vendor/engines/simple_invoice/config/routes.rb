SimpleInvoice::Engine.routes.draw do
  scope "(:locale)" do
    post '/invoices/send_note_only' => 'invoices#send_note_only'
    get 'invoices/unpaid_invoices' => 'invoices#unpaid_invoices'

    resources :invoices do
      collection do
        get 'invoice_pdf/:id' => 'invoices#invoice_pdf' #fix route
        get 'invoice_payments_history/:id' => 'payments#invoice_payments_history' #fix route
        get 'filter_invoices'
        get 'bulk_actions'
        get 'undo_actions'
        post 'duplicate_invoice'
        get 'enter_single_payment'
        get 'send_invoice'
        post 'paypal_payments'
        get  'paypal_payments'
        post 'preview'
        get 'preview'
        get 'credit_card_info'
        get 'selected_currency'
      end
    end

    post '/invoices/delete_invoices_with_payments' => 'invoices#delete_invoices_with_payments'
    post '/invoices/dispute_invoice' => 'invoices#dispute_invoice'
    post '/invoices/pay_with_credit_card' => 'invoices#pay_with_credit_card'
  end
end
