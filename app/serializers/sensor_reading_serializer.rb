# app/serializers/sensor_reading_serializer.rb (opcional, se usar active_model_serializers)
class SensorReadingSerializer < ActiveModel::Serializer
  attributes :id, :pond_id, :reading_time, :temp_c, :ph, :do_mg_l, :turbidity_ntu, :salinity_ppt, :flagged, :flag_reason
end
