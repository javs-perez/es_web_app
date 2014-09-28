class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :set_status, only: :update
  before_action :set_user, only: :show

  after_action :publish_funding, only: [:update, :create]
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
    @users = User.all
  end

  # GET /projects/1/edit
  def edit
    @users = User.all

  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @users = User.all

    if @project.save
     redirect_to @project, notice: 'Project was successfully created'
    else
      render :new
    end


    # respond_to do |format|
    #   if @project.save
    #     format.html { redirect_to @project, notice: 'Project was successfully created.' }
    #     format.json { render :show, status: :created, location: @project }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @project.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_status
      @previous_status = @project.status
    end

    def publish_funding
      set_user
      
      if ((@project.status == "Funding") && (@previous_status != "Funding" ))
        Publisher.publish("projects", { 
          header: {
            ref_id:       @project.status, 
            client_id:    "es_web",
            timestamp:    @project.created_at,
            priority:     "Normal",
            auth_token:   @project.id,
            event_type:   "project_status_update"
          }, 
          body: {
            user_id:      @project.user_id,
            channel:      "Email",
            email:        @user.email,
            user_name:    @user.name,
            user_mobile:  @user.phone
          } 
        })
      end
    end

    def set_user
      @user = User.find_by(id: @project.user_id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:status, :user_id, :name)
    end
  end
