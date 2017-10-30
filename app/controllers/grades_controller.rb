class GradesController < ApplicationController
  load_and_authorize_resource :only => [:index, :show, :create, :destroy, :update, :new, :edit]
  before_action :set_grade, only: [:show, :edit, :update, :destroy]

  include GradesHelper

  # GET /grades
  # GET /grades.json
  def index
    @grades = Grade.all
  end

  # GET /grades/1
  # GET /grades/1.json
  def show
  end

  # GET /grades/new
  def new
    @grade = Grade.new
  end

  # GET /grades/1/edit
  def edit
  end

  # POST /grades
  # POST /grades.json
  def create
    company_id = session['current_company'] || current_user.current_company || current_user.first_company_id
    if Grade.is_exists?(params[:grade][:title], company_id)
      @grade_exists = true
      redirect_to(new_grade_path, :alert => "Grade with same name already exists") unless params[:quick_create]
      return
    end
    @grade = Grade.new(grade_params)

    respond_to do |format|
      if @grade.save
        format.js
        format.json { render :json => @grade, :status => :created, :location => @grade }
        new_grade_message = new_grade(@grade.id)
        redirect_to({:action => "edit", :controller => "grades", :id => @grade.id}, :notice => new_grade_message) unless params[:quick_create]
        return
      else
        format.html { render :new }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grades/1
  # PATCH/PUT /grades/1.json
  def update
    respond_to do |format|
      if @grade.update(grade_params)
        format.html { redirect_to edit_grade_path(@grade), notice: 'Grade was successfully updated.' }
        format.json { render :show, status: :ok, location: @grade }
      else
        format.html { render :edit }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grades/1
  # DELETE /grades/1.json
  def destroy
    if @grade.clients.exists?
      redirect_to grades_url, alert: "Please delete all students of <strong>Grade #{@grade.title}</strong> first!".html_safe
    else
      @grade.destroy
      respond_to do |format|
        format.html { redirect_to grades_url, notice: 'Grade was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  def select_fee_item_for_grade
    if params[:grade_id].present?
      grade = Grade.find params[:grade_id]
      if grade.present?
        @fee_items = grade.items
      else
        @fee_items = nil
      end
      respond_to do |format|
        format.js
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grade
      @grade = Grade.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grade_params
      params.require(:grade).permit(:title, :description)
    end
end
