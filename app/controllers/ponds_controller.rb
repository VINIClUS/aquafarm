class PondsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pond, only: %i[index show edit update destroy]
  before_action :set_farm, only: %i[new create]

  # GET /ponds
  def index
    @ponds = policy_scope(Pond)
  end

  # GET /ponds/:id
  def show
    authorize @pond
  end

  # GET /ponds/new
  def new
    # farm deve ser do usuário
    #@farm = policy_scope(Farm).find(params[:farm_id])
    #@farm = policy_scope(Farm).first!
    #@pond = @farm.ponds.new
    @farm = policy_scope(Farm).first! if policy_scope(Farm).count == 1
    @pond = Pond.new(farm: @farm)
    authorize @pond
  end

  # POST /ponds
  def create
    #@farm = policy_scope(Farm).find(params[:farm_id])
    #@pond = @farm.ponds.new(pond_params)
    @pond = policy_scope(Pond).new(pond_params)
    #@farm = policy_scope(Farm).find_by(id: pond_params[:farm_id])
    #@pond = @farm.ponds.new(pond_params.except(:farm_id))

    
    authorize @pond
    if @pond.save
      redirect_to @pond, notice: "Tanque criado."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /ponds/:id/edit
  def edit
    authorize @pond
  end

  # PATCH/PUT /ponds/:id
  def update
    authorize @pond
    if @pond.update(pond_params)
      redirect_to @pond, notice: "Tanque atualizado."
    else
      # reenvie @farm se só houver 1 para o form saber usar hidden novamente
      @farm = policy_scope(Farm).first if policy_scope(Farm).count == 1
      render :new, status: :unprocessable_entity

    end
  end

  # DELETE /ponds/:id
  def destroy
    authorize @pond
    @pond.destroy
    redirect_to ponds_path, notice: "Tanque removido."
  end

  private

  def set_farm
    @farm = policy_scope(Farm).find_by(id: params[:farm_id])  # garante que é do usuário
  rescue ActiveRecord::RecordNotFound
    redirect_to farms_path, alert: 'Fazenda não encontrada.'
  end

  def set_pond
    @pond = policy_scope(Pond).find_by(id: params[:id])
    @farm = policy_scope(Farm).find_by(id: @pond.farm_id) if @pond.present?
  end

  def pond_params
    params.require(:pond).permit(:name, :volume, :farm_id)
  end
end
