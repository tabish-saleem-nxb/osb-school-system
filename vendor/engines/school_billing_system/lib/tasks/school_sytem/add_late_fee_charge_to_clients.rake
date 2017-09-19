# require 'rake'
# namespace :school_system do
#   desc 'Add late fee charge to clients after due date'
#   task :add_late_fee_charge_to_clients => :environment do
#
#     logger = Logger.new(Rails.root.join('log', 'add_late_fee_charge_to_clients.log'))
#     logger.info "====== TASK STARTING at #{Time.now} ========="
#
#     clients = Client.joins(:client_type, :invoices).where('client_types.title = ? AND invoices.due_date > ?', 'student', Date.today)
#
#     clients.each do |client|
#       client.invoices.each do |invoice|
#         # invoice.update_column(:column, OSB::CONFIG::LATE_FEE_PERCENTAGE * total_invoice_amount)
#       end
#     end
#
#     # add 5% after every month on total invoice
#     # save history to show late_fee charge in invoice
#
#     logger.info "====== TASK ENDED at #{Time.now} ========="
#
#   end
# end
