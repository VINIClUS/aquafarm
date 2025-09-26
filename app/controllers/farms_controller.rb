# app/controllers/farms_controller.rb
class FarmsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_farm, only: %i[show edit update destroy]

  def index
    @farms = policy_scope(Farm)
  end

  def show
    authorize @farm
  end

  def new
    @farm = current_user.farms.new
    authorize @farm
  end

  def create
    @farm = current_user.farms.new(farm_params)
    authorize @farm

    if @farm.save
      redirect_to @farm, notice: "Fazenda criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @farm
  end

  def update
    authorize @farm
    if @farm.update(farm_params)
      redirect_to @farm, notice: "Fazenda atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @farm
    @farm.destroy
    redirect_to farms_path, notice: "Fazenda removida."
  end

  private

  def set_farm
    @farm = policy_scope(Farm).find(params[:id])
  end

  def farm_params
    params.require(:farm).permit(:name, :location, :description)
  end
end
