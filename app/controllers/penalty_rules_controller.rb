class PenaltyRulesController < ApplicationController
  load_and_authorize_resource :only => [:index, :show, :create, :destroy, :update, :new, :edit]
  before_filter :authenticate_user!
  before_action :set_penalty_rule, only: [:show, :edit, :update, :destroy]
  layout :choose_layout

  # GET /penalty_rules
  # GET /penalty_rules.json
  def index
    @penalty_rules = PenaltyRule.all
  end

  # GET /penalty_rules/1
  # GET /penalty_rules/1.json
  def show
  end

  # GET /penalty_rules/new
  def new
    @penalty_rule = PenaltyRule.new
  end

  # GET /penalty_rules/1/edit
  def edit
  end

  # POST /penalty_rules
  # POST /penalty_rules.json
  def create
    @penalty_rule = PenaltyRule.new(penalty_rule_params)

    respond_to do |format|
      if @penalty_rule.save
        format.html { redirect_to penalty_rules_path, notice: 'Penalty Rule was successfully created.' }
        format.json { render :show, status: :created, location: @penalty_rule }
      else
        format.html { render :new }
        format.json { render json: @penalty_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /penalty_rules/1
  # PATCH/PUT /penalty_rules/1.json
  def update
    respond_to do |format|
      if @penalty_rule.update(penalty_rule_params)
        format.html { redirect_to penalty_rules_path, notice: 'Penalty Rule was successfully updated.' }
        format.json { render :show, status: :ok, location: @penalty_rule }
      else
        format.html { render :edit }
        format.json { render json: @penalty_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /penalty_rules/1
  # DELETE /penalty_rules/1.json
  def destroy
    @penalty_rule.destroy
    respond_to do |format|
      format.html { redirect_to penalty_rules_url, notice: 'Penalty Rule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_penalty_rule
    @penalty_rule = PenaltyRule.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def penalty_rule_params
    params.require(:penalty_rule).permit(:name, :description, :due_date, :percentage, :client_type_id)
  end

end
