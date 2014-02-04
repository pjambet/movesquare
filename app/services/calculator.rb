require 'ostruct'

class Calculator

  attr_reader :activities

  def initialize(activities)
    @activities = activities
  end

  def total_distance
    sum 'distance'
  end

  def total_steps
    sum 'steps'
  end

  def total_duration
    sum 'duration'
  end

  def sum(attribute)
    activities.map{ |act| act[attribute] }.reduce(&:+) || 0
  end
end
