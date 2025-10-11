module JobLogging
  extend ActiveSupport::Concern
  include JsonLog

  included do
    around_perform do |job, block|
      jid = job.job_id
      name = self.class.name
      t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      Rails.logger.info j(event: "job.start", job: name, jid: jid, args: job.arguments&.map { |a| a.is_a?(Hash) ? a.slice("pond_id","pond_external_id","reading_time") : a })

      begin
        block.call
        ms = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - t0) * 1000).round(1)
        Rails.logger.info j(event: "job.ok", job: name, jid: jid, duration_ms: ms)
      rescue => e
        ms = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - t0) * 1000).round(1)
        Rails.logger.error j(event: "job.fail", job: name, jid: jid, duration_ms: ms, error: e.class.to_s, message: e.message)
        raise
      end
    end
  end
end
