SimpleInvoice::Engine.routes.draw do

  post '/invoices/send_note_only' => 'invoices#send_note_only'
  get "invoices/unpaid_invoices" => "invoices#unpaid_invoices"

  resources :invoice_line_items
  resources :invoices do
    collection do
      get 'term_invoices', as: :term
      post 'generate_term_invoices', as: :generate_term
      # get 'invoice_pdf', as: :pdf
    end

    resources :invoice_line_items
    collection do
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

  resources :items do
    collection do
      get 'filter_items'
      get 'bulk_actions'
      post 'load_item_data'
      get 'duplicate_item'
      get 'undo_actions'
    end
  end

  resources :taxes do
    collection do
      get 'filter_taxes'
      get 'bulk_actions'
      get 'undo_actions'
    end
  end

end
