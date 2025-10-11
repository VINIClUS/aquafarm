INGEST_LOGGER = ActiveSupport::TaggedLogging.new(
  Logger.new(Rails.root.join("log/ingest.log"), 10, 10.megabytes) # 10 arquivos rotativos
).tap { |lg| lg.level = Logger::INFO }
