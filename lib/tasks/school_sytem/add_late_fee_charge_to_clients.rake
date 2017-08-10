require 'rake'
namespace :school_system do
  desc 'Add late fee charge to clients after due date'
  task :add_late_fee_charge_to_clients => :environment do

    logger = Logger.new(Rails.root.join('log', 'add_late_fee_charge_to_clients.log'))
    logger.info "====== TASK STARTING at #{Time.now} ========="


    clients = Client.joins(:client_type).where('client_types.title = ?', 'student')


    logger.info "====== TASK ENDED at #{Time.now} ========="

  end
end
