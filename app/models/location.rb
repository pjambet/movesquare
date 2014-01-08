class Location < ActiveRecord::Base

  acts_as_nested_set

  ALL_LEVELS = %i(neighborhood city state country)

  validates :slug, :location_type, presence: true

  before_save { |location| location.slug = location.slug.downcase }

  def self.find_or_create_location(attr)
    slug = attr[:slug] ? attr[:slug].downcase : attr[:slug]
    Location.find_or_create_by(
      slug: slug,
      name: attr[:name],
      location_type: attr[:location_type])
  end

  def self.valid_location_type?(location_type)
    ALL_LEVELS.include?(location_type) || ALL_LEVELS.map(&:to_s).include?(location_type)
  end

end
