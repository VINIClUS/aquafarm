# app/controllers/sensor_readings_controller.rb
require "csv"

class SensorReadingsController < ApplicationController
  before_action :authenticate_user!
  #before_action :set_pond, if: -> { params[:pond_id].present? }
  before_action :set_sensor_reading, only: %i[show edit update destroy]

  # GET /ponds/:pond_id/sensor_readings/timeseries.json?n=...&metrics=...&stride=...&start_at=...&end_at=...
  def timeseries
    set_pond if params[:pond_id].present? 
    authorize @pond, :show?

    n       = params[:n].presence&.to_i || 200
    stride  = [params[:stride].presence&.to_i || 1, 1].max
    metrics = (params[:metrics].presence || "temp_c,ph,do_mg_l,turbidity_ntu,salinity_ppt")
                .split(",").map(&:strip) & %w[temp_c ph do_mg_l turbidity_ntu salinity_ppt]

    scope = @pond.sensor_readings.order(reading_time: :desc)
    if params[:start_at].present? && params[:end_at].present?
      start_at = Time.zone.parse(params[:start_at])
      end_at   = Time.zone.parse(params[:end_at])
      scope = scope.where(reading_time: start_at..end_at)
    end

    # pega mais pontos para depois dizimar por stride
    rows = scope.limit([n * stride, 5000].min).to_a
    rows = rows.each_slice(stride).map(&:first).first(n) # dizimação simples
    rows.reverse! # ordem cronológica

    data = rows.map do |r|
      h = { "t" => r.reading_time&.iso8601 }
      metrics.each { |m| h[m] = r.public_send(m)&.to_f }
      h
    end

    render json: {
      pond_id: @pond.id,
      metrics: metrics,
      count: data.size,
      series: data
    }
  end

  # GET /ponds/:pond_id/sensor_readings ou /sensor_readings
  def index
    #base = @pond ? @pond.sensor_readings : policy_scope(SensorReading)
     # pega o tanque escolhido no select (se tiver)
    #selected_pond_id = params[:pond_id].presence
    #@pond = policy_scope(Pond).find(selected_pond_id) if selected_pond_id

    # base: tudo do usuário OU só do tanque escolhido
    #base = if @pond
    #        policy_scope(SensorReading).where(pond_id: @pond.id)
    #      else
    #        policy_scope(SensorReading)
    #      end
     # 1) pegue o pond_id do QUERY STRING (select) com prioridade
    query_pond_id = request.query_parameters[:pond_id].presence
    path_pond_id  = request.path_parameters[:pond_id].presence

    selected_pond_id =
      if query_pond_id.present?
        query_pond_id
      else
        path_pond_id
      end

    # 2) se veio pelo select e é diferente do path, redirecione para a rota aninhada correta
    if query_pond_id.present? && query_pond_id != path_pond_id
      # preserva outros filtros (exceto pond_id)
      redirect_to pond_sensor_readings_path(query_pond_id,
                                            start_at: params[:start_at],
                                            end_at:   params[:end_at]) and return
    end

    @pond = policy_scope(Pond).find_by(id: selected_pond_id)
    base  = policy_scope(SensorReading)
    base  = base.where(pond_id: @pond.id) if @pond


    # filtros de data (opcionais)
    if params[:start_at].present? && params[:end_at].present?
      start_at = Time.zone.parse(params[:start_at])
      end_at   = Time.zone.parse(params[:end_at])
      base = base.where(reading_time: start_at..end_at)
    end
                                            
    @sensor_readings = base.recent

    #if params[:start_at].present? && params[:end_at].present?
    #  start_at = Time.zone.parse(params[:start_at])
    #  end_at   = Time.zone.parse(params[:end_at])
    #  @sensor_readings = @sensor_readings.between(start_at, end_at)
    #end

    # endpoint de agregação rápida via query param:
    if params[:aggregate] == "daily"
      render json: Readings::Aggregator.daily_averages(relation: @sensor_readings)
      return
    end

    respond_to do |format|
      format.html
      format.json { render json: @sensor_readings.as_json(include: { pond: { only: [:id, :pond_name] } }) }
      format.csv  { send_data csv_for(@sensor_readings), filename: csv_filename, type: "text/csv; charset=utf-8" }
    end
  end

  # GET /ponds/:pond_id/sensor_readings/:id ou /sensor_readings/:id
  def show
    #respond_to do |format|
    #  format.html
    #  format.json { render json: @sensor_reading.as_json(include: { pond: { only: [:id, :pond_name] } }) }
    #end
    authorize @sensor_reading
  end

  # GET /ponds/:pond_id/sensor_readings/new
  def new
    authorize @pond, :show?
    @sensor_reading = @pond.sensor_readings.new(reading_time: Time.zone.now)
    authorize @sensor_reading
  end

  # GET /sensor_readings/:id/edit
  def edit
    authorize @sensor_reading
  end

  # POST /ponds/:pond_id/sensor_readings
  def create
    authorize @pond, :show?
    @sensor_reading = @pond.sensor_readings.new(sensor_reading_params)
    authorize @sensor_reading
    if @sensor_reading.save
      redirect_to [@pond, @sensor_reading], notice: "Leitura criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sensor_readings/:id
  def update
    authorize @sensor_reading
    if @sensor_reading.update(sensor_reading_params)
      redirect_to [@sensor_reading.pond, @sensor_reading], notice: "Leitura atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /sensor_readings/:id
  def destroy
    authorize @sensor_reading
    #pond = @sensor_reading.pond
    @sensor_reading.destroy
    redirect_to sensor_readings_path, notice: "Leitura removida."
  end

  private

  def set_pond
    # restringe ao escopo do usuário
    # pond_id = params[:pond_id] || params[:id]
    @pond = policy_scope(Pond).find(params[:pond_id])
  end

  def set_sensor_reading
    if params[:pond_id]
      @sensor_reading = policy_scope(SensorReading).find(params[:id])
    else
      @sensor_reading = policy_scope(SensorReading).find(params[:id])
    end
  end

  def sensor_reading_params
    params.require(:sensor_reading).permit(
      :reading_time, :temp_c, :ph, :do_mg_l, :turbidity_ntu, :salinity_ppt, :flagged, :flag_reason
    )
  end

  # substitua por Pundit/CanCanCan se usar
  def authorize_pond!
    return unless @pond
    # exemplo trivial: só permite se o pond pertence à farm do usuário (ajuste à sua regra)
    # raise ActiveRecord::RecordNotFound a menos que condição seja satisfeita
  end

  private

  def csv_for(scope)
    headers = %w[id pond_id pond_name reading_time temp_c ph do_mg_l turbidity_ntu salinity_ppt flagged flag_reason]
    CSV.generate(headers: true) do |csv|
      csv << headers
      scope.includes(:pond).find_each do |r|
        csv << [
          r.id,
          r.pond_id,
          r.pond&.name,
          r.reading_time&.iso8601,
          r.temp_c,
          r.ph,
          r.do_mg_l,
          r.turbidity_ntu,
          r.salinity_ppt,
          r.flagged,
          r.flag_reason
        ]
      end
    end
  end

  def csv_filename
    base = @pond ? "sensor_readings_pond_#{@pond.id}" : "sensor_readings"
    "#{base}_#{Time.zone.now.strftime('%Y%m%d_%H%M%S')}.csv"
  end

  #def set_pond
   # @pond = Pond.find(params[:pond_id])
  #end

  #def set_sensor_reading
    #@sensor_reading = params[:pond_id] ? Pond.find(params[:pond_id]).sensor_readings.find(params[:id]) : SensorReading.find(params[:id])
  #end

  #def sensor_reading_params
  #  params.require(:sensor_reading).permit(:reading_time, :temp_c, :ph, :do_mg_l, :turbidity_ntu, :salinity_ppt, :flagged, :flag_reason)
  #end

   # GET /ponds/:pond_id/sensor_readings/timeseries.json?n=200&metrics=temp_c,ph&stride=1&start_at=...&end_at=...
  
end
