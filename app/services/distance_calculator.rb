class DistanceCalculator

  attr_reader :segments

  def initialize(segments)
    @segments = segments
  end

  def total_distance
    segments.map(&:distance).reduce(&:+) || 0
  end
end
