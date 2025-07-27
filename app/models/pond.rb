class Pond < ApplicationRecord
before_action :authenticate_user!         # do Devise
  before_action :set_pond, only: %i[show edit update destroy]

  def index
    @ponds = policy_scope(Pond)            # só pega os permitidos
  end

  def show
    authorize @pond
  end

  def new
    @pond = Pond.new
    authorize @pond
  end

  def create
    @pond = Pond.new(pond_params)
    @pond.farm = current_user.farm         # vincula ao tenant
    authorize @pond

    if @pond.save
      redirect_to @pond, notice: 'Tanque criado com sucesso.'
    else
      render :new
    end
  end

  def edit
    authorize @pond
  end

  def update
    authorize @pond
    if @pond.update(pond_params)
      redirect_to @pond, notice: 'Tanque atualizado.'
    else
      render :edit
    end
  end

  def destroy
    authorize @pond
    @pond.destroy
    redirect_to ponds_path, notice: 'Tanque removido.'
  end

  private

  def set_pond
    @pond = Pond.find(params[:id])
  end

  def pond_params
    params.require(:pond).permit(:name, :volume)
  end
end
