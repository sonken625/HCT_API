class UsersController < ApplicationController
  before_action :set_user_component, only: [:show, :edit, :update, :destroy]
  authorize_resource


  # GET /components
  # GET /components.json
  def index
    @users = User.all
  end

  # GET /components/1
  # GET /components/1.json
  def show
    respond_to do |format|
      format.json {
        render json: @user
      }
      format.html {

      }
    end
  end

  # GET /components/new
  def new
    @user = User.new
  end

  # GET /components/1/edit
  def edit
  end

  # POST /components
  # POST /components.json
  def create
    @user = User.new(component_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'UserComponent was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /components/1
  # PATCH/PUT /components/1.json
  def update
    respond_to do |format|
      if @user.update(component_params)
        format.html { redirect_to @user, notice: 'UserComponent was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /components/1
  # DELETE /components/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to components_url, notice: 'UserComponent was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_component
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def component_params
      params.require(:user).permit(:name)
    end
end
