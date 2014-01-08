class SegmentLocator

  def initialize(lat, lng)
    @lat, @lng = lat, lng
    locate
  end

  def create_segment
    Segment.create(lat: @lat, lng: @lng, neighborhood: neighborhood, state: state,
                   city: city, country: country)
  end

  def locate
    @address = Geokit::Geocoders::GoogleGeocoder.reverse_geocode([@lat, @lng])
  end

  def neighborhood
    # TODO : Handle the case where the parent chain is broken
    @neighborhood ||= Location.find_or_create_location(
      slug: @address.neighborhood, name: @address.neighborhood, location_type: 'neighborhood')
    @neighborhood.update(parent: city) if @neighborhood.parent.nil?
    @neighborhood
  end

  def city
    @city ||= Location.find_or_create_location(
      slug: @address.city, name: @address.city, location_type: 'city')
    @city.update(parent: state) if @city.parent.nil?
    @city
  end

  def state
    @state ||= Location.find_or_create_location(
      slug: @address.state, name: @address.state, location_type: 'state')
    @state.update(parent: country) if @state.parent.nil?
    @state
  end

  def country
    @country ||= Location.find_or_create_location(
      slug: @address.country_code, name: @address.country, location_type: 'country')
  end

  def location_components
    return neighborhood, state, city, country
  end
end
