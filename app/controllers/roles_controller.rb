class RolesController < ApplicationController
  before_action :set_role, only: %i[show update destroy]

  # GET /roles
  def index
    @roles = Role.all
    render json: @roles
  end

  # GET /roles/:id
  def show
    render json: @role
  end

  # POST /roles
  def create
    @role = Role.new(role_params)
    if @role.save
      render json: @role, status: :created, location: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /roles/:id
  def update
    if @role.update(role_params)
      render json: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  # DELETE /roles/:id
  def destroy
    @role.destroy
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def role_params
    params.require(:role).permit(:name)
  end
end
