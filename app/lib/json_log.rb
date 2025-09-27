# app/lib/json_log.rb
module JsonLog
  def j(event:, **fields)
    { ts: Time.now.utc.iso8601, event: event, **fields }.to_json
  end
end
