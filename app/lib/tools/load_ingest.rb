# frozen_string_literal: true
require "json"
require "net/http"
require "uri"

URL   = ENV.fetch("URL",   "http://localhost:3000/ingest/sensor_readings")
POND  = ENV.fetch("POND",  "1").to_i
TOTAL = ENV.fetch("N",     "1000").to_i
POOL  = ENV.fetch("POOL",  "50").to_i
TOKEN = ENV["INGEST_TOKEN"] # opcional

uri  = URI(URL)
q    = Queue.new
TOTAL.times { |i| q << i }
mutex = Mutex.new
stats = Hash.new(0)

workers = POOL.times.map do
  Thread.new do
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = 30
    while (i = (q.pop(true) rescue nil))
      ts = (Time.now.utc - i)
      body = {
        pond_id: POND,
        reading_time: ts,
        metrics: {
          temp_c: 24 + rand * 8,
          ph: 6.5 + rand * 2.0,
          do_mg_l: 5 + rand * 5
        }
      }.to_json
      req = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")
      req["X-INGEST-TOKEN"] = TOKEN if TOKEN
      req.body = body

      begin
        res = http.request(req)
        code = res.code
      rescue => e
        code = "ERR"
      end

      mutex.synchronize { stats[code] += 1 }
    end
  end
end

t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
workers.each(&:join)
elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - t0

puts "---- RESULTADO ----"
stats.sort_by { |k,_| k.to_s }.each { |k,v| puts "HTTP #{k}: #{v}" }
puts format("Total: %d | Pool: %d | Tempo: %.2fs | RPS: %.1f",
            TOTAL, POOL, elapsed, TOTAL/elapsed)
