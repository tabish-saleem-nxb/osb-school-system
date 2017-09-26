require_dependency "school_billing_system/application_controller"

module SchoolBillingSystem
  class ParentClientsController < ApplicationController
    before_action :set_parent_client, only: [:show, :edit, :update, :destroy]
    load_and_authorize_resource only: [:index, :show, :create, :destroy, :update, :new, :edit]
    before_filter :set_per_page_session
    helper_method :sort_column, :sort_direction
    layout :choose_layout

    # GET /parent_clients
    # GET /parent_clients.json
    def index
      set_company_session
      params[:status] = params[:status] || 'active'
      mappings = {active: 'unarchived', archived: 'archived', deleted: 'only_deleted'}
      method = mappings[params[:status].to_sym]
      @parent_clients = ParentClient.all
      @status = params[:status]
      respond_to do |format|
        format.html # index.html.erb
        format.js
        format.json { render json: @parent_clients }
      end
    end

    # GET /parent_clients/1
    # GET /parent_clients/1.json
    def show
    end

    # GET /parent_clients/new
    def new
      @parent_client = ParentClient.new
    end

    # GET /parent_clients/1/edit
    def edit
    end

    # POST /parent_clients
    # POST /parent_clients.json
    def create
      @parent_client = ParentClient.new(parent_client_params)

      respond_to do |format|
        if @parent_client.save
          format.html { redirect_to @parent_client, notice: 'Parent client was successfully created.' }
          format.json { render :show, status: :created, location: @parent_client }
        else
          format.html { render :new }
          format.json { render json: @parent_client.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /parent_clients/1
    # PATCH/PUT /parent_clients/1.json
    def update
      respond_to do |format|
        if @parent_client.update(parent_client_params)
          format.html { redirect_to @parent_client, notice: 'Parent client was successfully updated.' }
          format.json { render :show, status: :ok, location: @parent_client }
        else
          format.html { render :edit }
          format.json { render json: @parent_client.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /parent_clients/1
    # DELETE /parent_clients/1.json
    def destroy
      @parent_client.destroy
      respond_to do |format|
        format.html { redirect_to parent_clients_url, notice: 'Parent client was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    def bulk_actions
      options = params.merge(per: session["#{controller_name}-per_page"], user: current_user, sort_column: sort_column, sort_direction: sort_direction, current_company: session['current_company'], company_id: get_company_id)
      result = Services::ParentClientBulkActionsService.new(options).perform
      @clients = result[:clients]#.order("#{sort_column} #{sort_direction}")
      @message = get_intimation_message(result[:action_to_perform], result[:client_ids])
      @action = result[:action]
      respond_to { |format| format.js }
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
      # Use callbacks to share common setup or constraints between actions.
      def set_parent_client
        @parent_client = ParentClient.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def parent_client_params
        params.require(:parent_client).permit(:organization_name, :first_name, :last_name, :email, :mobile_number, :home_number, :business_phone, :country, :address_street1, :address_street2, :city, :industry, :province, :postal_zip_code, :fax, :internal_notes, :archive_number, :archived_at, :deleted_at, :available_credit, :currency_id)
      end
  end
end
