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
  end

  def self.rating_for_user(user, location)
    # city level
    distance = Segment.total_distance(Segment.for_user(user))
  end
end
