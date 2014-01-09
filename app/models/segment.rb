class Segment < ActiveRecord::Base

  belongs_to :user
  belongs_to :neighborhood, class_name: 'Location'
  belongs_to :city, class_name: 'Location'
  belongs_to :state, class_name: 'Location'
  belongs_to :country, class_name: 'Location'

  validates :lat, :lng, presence: true

  scope :for_location, ->(location) do
    if Location.valid_location_type? location.location_type
      param_hash = {}
      param_hash[location.location_type] = location

      where(param_hash)
    end
  end

  scope :for_user, ->(user) do
    where(user: user)
  end

  after_initialize do
    self.distance ||= 0 # Might be a better solution to enforce that at DB level
    self.steps ||= 0 # Might be a better solution to enforce that at DB level
  end

  def self.create_segment(segment_data, context)
    # Move that to a PORO
    if segment_data['type'] == 'place'
      location = segment_data['place']['location']
      data = {
        lat: location['lat'],
        lng: location['lon']
      }
      if segment_data['activities']
        activities = segment_data['activities']
        activities_data = {
          distance: activities.map{|act| act['distance']}.reduce(&:+),
          steps: activities.map{|act| act['steps']}.reduce(&:+),
          duration: activities.map{|act| act['duration']}.reduce(&:+),
        }
        data.update(activities_data)
      end
    elsif segment_data['type'] == 'move'
      # try to find previous place
      index = context.index(segment_data)
      prev = context[index - 1] # should be a place
      location = prev['place']['location']
      data = {
        lat: location['lat'],
        lng: location['lon']
      }
    end
    Segment.create data
  end
end
