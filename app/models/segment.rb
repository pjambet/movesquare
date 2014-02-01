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

  def located?
    neighborhood || city || state || country
  end

end
