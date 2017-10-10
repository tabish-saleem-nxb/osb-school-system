#
# Open Source Billing - A super simple software to create & send invoices to your customers and
# collect payments.
# Copyright (C) 2013 Mark Mian <mark.mian@opensourcebilling.org>
#
# This file is part of Open Source Billing.
#
# Open Source Billing is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Open Source Billing is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Open Source Billing.  If not, see <http://www.gnu.org/licenses/>.
#
class ClientsController < ApplicationController
  load_and_authorize_resource :client
  helper_method :sort_column, :sort_direction
  before_filter :set_per_page_session

  # GET /clients
  # GET /clients.json
  include ClientsHelper

  def parents
    load_parents_or_students
  end

  def students
    load_parents_or_students
  end

  def filter_clients
    mappings = {active: 'unarchived', archived: 'archived', deleted: 'only_deleted'}
    method = mappings[params[:status].to_sym]
    @clients = Client.get_clients(params.merge(get_args(method)))
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @client = Client.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.json
  def new
    @client = Client.new
    @client.client_contacts.build()
    if client_type_student(params[:type])
      @client.fee_date = Date.tomorrow
      @parents = get_all_parents(params)
      @grades = Grade.all
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @client }
    end
  end

  # GET /clients/1/edit
  def edit
    @client = Client.find(params[:id])
    @client.payments.build({:payment_type => "credit", :payment_date => Date.today})
    if client_type_student(params[:type])
      @parents = get_all_parents(params)
      @grades = Grade.all
    end
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)
    company_id = get_company_id()
    options = params[:quick_create] ? params.merge(company_ids: company_id) : params

    associate_entity(options, @client)

    @client.add_available_credit(params[:available_credit], company_id) if params[:available_credit].present? && params[:available_credit].to_i > 0

    respond_to do |format|
      if @client.save
        format.js
        format.json { render :json => @client, :status => :created, :location => @client }
        new_client_message = new_client(@client.id, params[:type])
        redirect_to("/#{params[:type]}s/#{@client.id}/edit", :notice => new_client_message) unless params[:quick_create]
        return
      else
        format.html { render :action => "new" }
        format.json { render :json => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.json
  def update
    @client = Client.find(params[:id])
    associate_entity(params, @client)

    #add/update available credit
    if params[:available_credit].present?
    @client.payments.first.blank? ? @client.add_available_credit(params[:available_credit], get_company_id()) : @client.update_available_credit(params[:available_credit])
    end

    respond_to do |format|
      if @client.update_attributes(client_params)
        format.html { redirect_to @client, :notice => 'Client was successfully updated.' }
        format.json { head :no_content }
        redirect_to("/#{params[:type]}s/#{@client.id}/edit", :notice => "Your #{params[:type]} has been updated successfully.")
        return
      else
        format.html { render :action => "edit" }
        format.json { render :json => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client = Client.find(params[:id])
    @client.destroy

    respond_to do |format|
      format.html { redirect_to clients_url }
      format.json { head :no_content }
    end
  end

  def import_parents_and_students
  end

  def import_json_or_xml_for_parents_and_students
    redirect_to :back, alert: 'Sorry! File not found.' and return if params[:file].nil?
    extension  = File.extname(params[:file].original_filename)
    if extension.eql?('.json')
      import_json_parents_and_students
    elsif extension.eql?('.xml')
      import_xml_parents_and_students
    end
  end

  def import_xml_parents_and_students
    require 'crack/xml'
    json = Crack::XML.parse(File.open(params[:file].path))
    create_parents_and_students(json['root']['row'])
  end

  def import_json_parents_and_students
    @invalid_parents = []
    @invalid_children = []
    @saved_parents = []
    @saved_children = []

    file = File.read(params[:file].path)
    begin JSON.parse(file)
    data_hash = JSON.parse(file)
    rescue JSON::ParserError => error
      redirect_to :back, notice: "File is not in valid JSON format. Found error: #{error}"
      return
    end
    create_parents_and_students(data_hash)
  end

  def create_parents_and_students(data_hash)
    data_hash.each do |data_item|
      parent_data = data_item['parent']
      if parent_data.present? && valid_parent?(parent_data)
        parent = Client.find_by_email(parent_data['email'])
        if parent.nil?
          parent = Client.create(first_name: parent_data['first_name'], last_name: parent_data['last_name'], email: parent_data['email'])
          @saved_parents << parent
        end
        if parent
          find_or_create_children(data_item, parent)
        end
      else
        @invalid_parents << parent_data
      end
    end
    respond_to do |format|
      format.html { render template: 'clients/create_parents_and_students.html.slim' }
    end
  end

  def find_or_create_children(data_item, parent)
    children_data = data_item['children']
    children_data.each do |child_data|
      if child_data.present? && valid_child?(child_data)
        if Client.find_by_email_and_parent_client_id(child_data['email'], parent.try(:id)).nil?
          @saved_children << Client.create(first_name: child_data['first_name'], last_name: child_data['last_name'], email: child_data['email'], parent_client_id: parent.try(:id))
        end
      else
        child_data = child_data.merge(parent: parent)
        @invalid_children << child_data
      end
    end
  end

  def bulk_actions
    options = params.merge(per: session["#{controller_name}-per_page"], user: current_user, sort_column: sort_column, sort_direction: sort_direction, current_company: session['current_company'], company_id: get_company_id)
    result = Services::ClientBulkActionsService.new(options).perform
    @clients = result[:clients]#.order("#{sort_column} #{sort_direction}")
    @message = get_intimation_message(result[:action_to_perform], result[:client_ids])
    @action = result[:action]
    respond_to { |format| format.js }
  end


  def undo_actions
    params[:archived] ? Client.recover_archived(params[:ids]) : Client.recover_deleted(params[:ids])
    @clients = Client.get_clients(params.merge(get_args('unarchived')))
    respond_to { |format| format.js }
  end

  def get_last_invoice
    client = Client.find_by_id(params[:id]).present? ? Client.find(params[:id]) : Client.unscoped.find_by_id(params[:id])
    render :text => [client.last_invoice || "no invoice", client.organization_name || ""]
  end

  def default_currency
    @client = Client.find_by_id(params[:id]).present? ? Client.find(params[:id]) : Client.unscoped.find_by_id(params[:id])
  end

  def client_detail
    @client = Client.find(params[:id])
    @invoices = @client.invoices
    @payments = Payment.payments_history(@client)
    @detail = Services::ClientDetail.new(@client).get_detail #client.outstanding_amount
    render partial: 'client_detail'
  end

  def get_last_estimate
    client = Client.find_by_id(params[:id]).present? ? Client.find(params[:id]) : Client.unscoped.find_by_id(params[:id])
    render :text => [client.last_estimate || "no estimate", client.organization_name || ""]
  end

  def get_all_parents(params)
    mappings = {active: 'unarchived', archived: 'archived', deleted: 'only_deleted'}
    params[:status] = 'active'
    method = mappings[params[:status].to_sym]
    params = params.merge(type: 'parent')
    @parents = Client.get_clients(params.merge(get_args(method)), true)
  end

  private

  def get_intimation_message(action_key, invoice_ids)
    helper_methods = {archive: 'clients_archived', destroy: 'clients_deleted'}
    helper_method = helper_methods[action_key.to_sym]
    helper_method.present? ? send(helper_method, invoice_ids) : nil
  end

  def set_per_page_session
    session["#{controller_name}-per_page"] = params[:per] || session["#{controller_name}-per_page"] || 10
  end

  def sort_column
    params[:sort] ||= 'created_at'
    sort_col = params[:sort]
  end

  def sort_direction
    params[:direction] ||= 'desc'
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def get_args(status)
    {status: status, per: @per_page, user: current_user, sort_column: sort_column, sort_direction: sort_direction, current_company: session['current_company'], company_id: get_company_id}
  end
  private

  def client_params
    params.require(:client).permit(:address_street1, :address_street2, :business_phone, :city,
                                   :company_size, :country, :fax, :industry, :internal_notes,
                                   :organization_name, :postal_zip_code, :province_state,
                                   :send_invoice_by, :email, :home_phone, :first_name, :last_name,
                                   :mobile_number, :client_contacts_attributes, :archive_number,
                                   :archived_at, :deleted_at,:currency_id, :parent_client_id,
                                   :fee_date, :parent_alt_email, :grade_id,
                                   client_contacts_attributes: [:id, :client_id, :email, :first_name, :last_name, :home_phone, :mobile_number, :_destroy]
    )
  end

  def load_parents_or_students
    set_company_session
    params[:status] = params[:status] || 'active'
    mappings = {active: 'unarchived', archived: 'archived', deleted: 'only_deleted'}
    method = mappings[params[:status].to_sym]
    @clients = Client.get_clients(params.merge(get_args(method)))
    @status = params[:status]
    respond_to do |format|
      format.html { render template: 'clients/index.html.erb' }
      format.js   { render template: 'clients/index.js.erb' }
      format.json { render json: @clients }
    end
  end


end