# db/seeds.rb
# Seeds idempotentes para ambiente dev
require "securerandom"

TZ = Time.zone || ActiveSupport::TimeZone["America/Sao_Paulo"]

def maybe_has_column?(klass, col)
  klass.column_names.include?(col.to_s)
rescue
  false
end

# 1) Usuário (se houver Devise/User)
user = nil
if defined?(User)
  email = "admin@example.com"
  user = User.find_by(email: email)
  if user.nil?
    password = "password123"
    user = User.create!(email: email, password: password, password_confirmation: password)
    puts "👤 User criado: #{email} / #{password}"
  else
    puts "👤 User existente: #{user.email}"
  end
else
  puts "⚠️ Modelo User não encontrado — criando dados sem usuário."
end

# 2) Farm pertencente ao user (se houver a coluna user_id)
if defined?(Farm)
  farm_attrs = { name: "Fazenda Demo" }
  farm_attrs[:user_id] = user.id if user && maybe_has_column?(Farm, :user_id)
  farm = Farm.where(farm_attrs).first_or_create!
  puts "🏡 Farm: #{farm.name} (user_id: #{farm.respond_to?(:user_id) ? farm.user_id : 'N/A'})"

  # 3) Ponds
  ponds = []
  %w[Tanque\ A Tanque\ B].each_with_index do |nome, idx|
    attrs = { name: nome, volume: 1000 + idx * 250, farm_id: farm.id }
    # se existir external_id, preenche
    if maybe_has_column?(Pond, :external_id)
      attrs[:external_id] = "POND-#{idx + 1}"
    end
    pond = Pond.where(attrs.except(:volume)).first_or_initialize
    pond.volume ||= attrs[:volume]
    pond.save!
    ponds << pond
    puts "🐟 Pond: #{pond.name} (id: #{pond.id})"
  end
else
  puts "❌ Modelo Farm/Pond não está disponível. Verifique as migrações."
  exit 1
end

# 4) SensorReadings — série horária realista 7 dias
if defined?(SensorReading)
  start_time = TZ.now.change(min: 0, sec: 0) - 7.days
  end_time   = TZ.now.change(min: 0, sec: 0)

  ponds.each do |pond|
    t = start_time
    created = 0
    while t <= end_time
      # gera valores plausíveis com pequena variação diária
      base_temp = 26.0 + Math.sin(t.to_f / 86_400 * 2 * Math::PI) * 3 # ciclo diário
      temp      = (base_temp + rand(-0.5..0.5)).round(2)
      ph        = (7.2 + rand(-0.3..0.3)).round(2)
      do_mg_l   = (6.0 + rand(-1.2..1.2)).round(2)
      turb      = (10.0 + rand(-5.0..20.0)).round(2).clamp(0, 300)
      sal       = (0.3 + rand(-0.05..0.05)).round(3).clamp(0, 5)

      reading = SensorReading.where(pond_id: pond.id, reading_time: t).first_or_initialize
      reading.temp_c        = temp
      reading.ph            = ph
      reading.do_mg_l       = do_mg_l
      reading.turbidity_ntu = turb
      reading.salinity_ppt  = sal
      reading.save!
      created += 1 if reading.previous_changes.present?

      t += 1.hour
    end
    puts "📈 SensorReadings no #{pond.name}: #{created} criadas/atualizadas"
  end
else
  puts "❌ Modelo SensorReading não encontrado."
end

puts "✅ Seeds concluídos."
