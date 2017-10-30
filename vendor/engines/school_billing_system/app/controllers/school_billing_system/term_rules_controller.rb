require_dependency "school_billing_system/application_controller"

module SchoolBillingSystem
  class TermRulesController < ApplicationController
    load_and_authorize_resource :only => [:index, :show, :create, :destroy, :update, :new, :edit]
    before_filter :authenticate_user!
    before_action :set_term_rule, only: [:show, :edit, :update, :destroy]
    layout :choose_layout

    # GET /term_rules
    # GET /term_rules.json
    def index
      @term_rules = TermRule.all
    end

    # GET /term_rules/1
    # GET /term_rules/1.json
    def show
    end

    # GET /term_rules/new
    def new
      @term_rule = TermRule.new
    end

    # GET /term_rules/1/edit
    def edit
    end

    # POST /term_rules
    # POST /term_rules.json
    def create
      @term_rule = TermRule.new(term_rule_params)

      respond_to do |format|
        if @term_rule.save
          format.html { redirect_to term_rules_path, notice: 'Term Rule was successfully created.' }
          format.json { render :show, status: :created, location: @term_rule }
        else
          format.html { render :new }
          format.json { render json: @term_rule.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /term_rules/1
    # PATCH/PUT /term_rules/1.json
    def update
      respond_to do |format|
        if @term_rule.update(term_rule_params)
          format.html { redirect_to term_rules_path, notice: 'Term Rule was successfully updated.' }
          format.json { render :show, status: :ok, location: @term_rule }
        else
          format.html { render :edit }
          format.json { render json: @term_rule.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /term_rules/1
    # DELETE /term_rules/1.json
    def destroy
      @term_rule.destroy
      respond_to do |format|
        format.html { redirect_to term_rules_url, notice: 'Term Rule was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

    def set_per_page_session
      session["#{controller_name}-per_page"] = params[:per] || session["#{controller_name}-per_page"] || 10
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_term_rule
      @term_rule = TermRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def term_rule_params
      params.require(:term_rule).permit(:name, :description, :frequency)
    end

  end
end
