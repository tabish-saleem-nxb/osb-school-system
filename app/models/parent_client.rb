class ParentClient < ActiveRecord::Base

  #scopes
  scope :multiple, lambda { |ids| where('id IN(?)', ids.is_a?(String) ? ids.split(',') : [*ids]) }

  has_many :clients, dependent: :destroy


  acts_as_archival
  acts_as_paranoid

  paginates_per 10

  def organization_name
    self[:organization_name].blank? ? self.contact_name : self[:organization_name]
  end

  def contact_name
    "#{first_name} #{last_name}"
  end
  #
  # def self.get_clients(params)
  #   account = params[:user].current_account
  #
  #   # get the clients associated with companies
  #   company_clients = Company.find(params[:company_id]).clients.send(params[:status])
  #   #company_clients
  #
  #   # get the unique clients associated with companies and accounts
  #   clients = (account.clients.send(params[:status]) + company_clients).uniq
  #
  #   # sort clients in ascending or descending order
  #   clients.sort! do |a, b|
  #     b, a = a, b if params[:sort_direction] == 'desc'
  #     params[:sort_column] = 'contact_name' if params[:sort_column].starts_with?('concat')
  #     a.send(params[:sort_column]) <=> b.send(params[:sort_column])
  #   end if params[:sort_column] && params[:sort_direction]
  #
  #   Kaminari.paginate_array(clients).page(params[:page]).per(params[:per])
  #
  # end

end
