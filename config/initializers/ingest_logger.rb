# frozen_string_literal: true
# config/initializers/ingest_logger.rb
require "logger"
require "fileutils"

def build_ingest_logger
  # Em produção (Render), log em STDOUT.
  if Rails.env.production? || ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = Logger.new($stdout)
  else
    # Em dev/test, garanta que a pasta exista e use arquivo.
    FileUtils.mkdir_p(Rails.root.join("log"))
    logger = Logger.new(Rails.root.join("log", "ingest.log"))
  end

  logger.level = Logger::INFO
  logger.progname = "ingest"
  logger
end

INGEST_LOGGER = build_ingest_logger


#INGEST_LOGGER = ActiveSupport::TaggedLogging.new(
#  Logger.new(Rails.root.join("log/ingest.log"), 10, 10.megabytes) # 10 arquivos rotativos
#).tap { |lg| lg.level = Logger::INFO }
