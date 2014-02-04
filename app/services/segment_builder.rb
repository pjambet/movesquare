module SegmentBuilder
  UnknownSegmentType = Class.new(StandardError)
  NoLocationAvailable = Class.new(StandardError)

  class Builder

    attr_reader :segment_data, :context

    def initialize(segment_data, context)
      @segment_data = segment_data
      @context = context
    end

    def build
      unless %w(place move).include?(segment_data['type'])
        raise SegmentBuilder::UnknownSegmentType
      end
      if segment_data['type'] == 'place'
        SegmentBuilder::PlaceBuilder.new(segment_data, context).persist
      elsif segment_data['type'] == 'move'
        SegmentBuilder::MoveBuilder.new(segment_data, context).persist
      end
    end

    def persist
      segment_location = SegmentLocator.new(params[:lat], params[:lng]).locate_segment
      Segment.create params.update(neighborhood: segment_location.neighborhood,
                                   city: segment_location.city,
                                   state: segment_location.state,
                                   country: segment_location.country)
    rescue
      # Couldn't locate
    end

    def activities_data
      # TODO : Check activity type before adding it
      if segment_data['activities']
        activities = segment_data['activities']
        {
          distance: activities.map{ |act| act['distance'] || 0 }.reduce(&:+),
          steps: activities.map{ |act| act['steps'] || 0 }.reduce(&:+),
          duration: activities.map{ |act| act['duration'] || 0 }.reduce(&:+),
        }
      else
        {}
      end
    end

    def params
      {
        lat: location_hash['lat'],
        lng: location_hash['lon'],
      }
    end
  end

  class PlaceBuilder < Builder
    def params
      segment_params = super.update({segment_type: 'place'})
      segment_params.update(activities_data)
    end

    def location_hash
      segment_data['place']['location']
    end
  end

  class MoveBuilder < Builder
    def params
      segment_params = super.update({segment_type: 'move'})
      segment_params.update(activities_data)
    end

    def location_hash
      closest_place['place']['location']
    end

    def closest_place
      index = context.index(segment_data)
      prev_index = index - 1
      raise NoLocationAvailable if prev_index < 0
      prev_segment = context[prev_index]
      while index >= 0 && prev_segment['type'] != 'place' do
        prev_index -= 1
        prev_segment = context[prev_index]
      end
      prev_segment ? prev_segment : raise(NoLocationAvailable)
    end

  end
end
