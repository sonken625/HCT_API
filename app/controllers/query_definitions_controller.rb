class QueryDefinitionsController < ApplicationController
  before_action :set_query_definition, only: [:show, :edit, :update, :destroy]

  # GET /query_definitions
  # GET /query_definitions.json
  def index
    @query_definitions = QueryDefinition.all
  end

  # GET /query_definitions/1
  # GET /query_definitions/1.json
  def show
  end

  # GET /query_definitions/new
  def new
    @query_definition = QueryDefinition.new
  end

  # GET /query_definitions/1/edit
  def edit
  end

  # POST /query_definitions
  # POST /query_definitions.json
  def create
    @query_definition = QueryDefinition.new(query_definition_params)

    respond_to do |format|
      if @query_definition.save
        format.html { redirect_to @query_definition, notice: 'Query definition was successfully created.' }
        format.json { render :show, status: :created, location: @query_definition }
      else
        format.html { render :new }
        format.json { render json: @query_definition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /query_definitions/1
  # PATCH/PUT /query_definitions/1.json
  def update
    respond_to do |format|
      if @query_definition.update(query_definition_params)
        format.html { redirect_to @query_definition, notice: 'Query definition was successfully updated.' }
        format.json { render :show, status: :ok, location: @query_definition }
      else
        format.html { render :edit }
        format.json { render json: @query_definition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /query_definitions/1
  # DELETE /query_definitions/1.json
  def destroy
   if @query_definition.destroy
     respond_to do |format|
       format.html { redirect_to query_definitions_url, notice: 'Query definition was successfully destroyed.' }
       format.json { head :no_content }
     end
   else
     respond_to do |format|
       format.html { redirect_to query_definitions_url, alert: @query_definition.errors.full_messages}
       format.json { head :error }
     end
   end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_query_definition
      @query_definition = QueryDefinition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def query_definition_params
      params.require(:query_definition).permit(:params_string)
    end
end
