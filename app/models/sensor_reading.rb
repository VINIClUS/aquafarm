class SensorReading < ApplicationRecord
  belongs_to :pond

  # ----- Validações -----
  validates :reading_time, presence: true
  validates :temp_c, numericality: { greater_than: -5, less_than: 50 }, allow_nil: true
  validates :ph, numericality: { greater_than: 0, less_than: 14 }, allow_nil: true
  validates :do_mg_l, numericality: { greater_than_or_equal_to: 0, less_than: 30 }, allow_nil: true
  validates :turbidity_ntu, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :salinity_ppt, numericality: { greater_than_or_equal_to: 0, less_than: 100 }, allow_nil: true

  # ----- Escopos úteis -----
  scope :recent, -> { order(reading_time: :desc) }
  scope :between, ->(start_at, end_at) { where(reading_time: start_at..end_at) }
  scope :flagged, -> { where(flagged: true) }

  # ----- Callbacks (ex.: auto-flag por limites) -----
  before_save :auto_flag_limits

  def auto_flag_limits
    reasons = []
    reasons << "pH fora do ideal (6.5-8.5)" if ph.present? && (ph < 6.5 || ph > 8.5)
    reasons << "Temperatura fora do ideal (24-32°C)" if temp_c.present? && (temp_c < 24 || temp_c > 32)
    reasons << "Oxigênio dissolvido baixo (< 5 mg/L)" if do_mg_l.present? && do_mg_l < 5
    self.flagged = reasons.any?
    self.flag_reason = reasons.join("; ").presence
  end
end
