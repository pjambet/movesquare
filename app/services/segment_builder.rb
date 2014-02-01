module SegmentBuilder
  UnknownSegmentType = Class.new(StandardError)

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
      Segment.create params
    end

    def activities_data
      # TODO : Check activity type before adding it
      if segment_data['activities']
        activities = segment_data['activities']
        activities_data = {
          distance: activities.map{ |act| act['distance'] || 0 }.reduce(&:+),
          steps: activities.map{ |act| act['steps'] || 0 }.reduce(&:+),
          duration: activities.map{ |act| act['duration'] || 0 }.reduce(&:+),
        }
      else
        {}
      end
    end
  end

  class PlaceBuilder < Builder
    def params
      location = segment_data['place']['location']
      segment_params = {
        lat: location['lat'],
        lng: location['lon'],
        segment_type: 'move'
      }
      segment_params.update(activities_data)
    end
  end

  class MoveBuilder < Builder
    def params
      # try to find previous place
      index = context.index(segment_data)
      prev = context[index - 1] # should be a place
      location = prev['place']['location']
      segment_params = {
        lat: location['lat'],
        lng: location['lon'],
        segment_type: 'place'
      }
      segment_params.update(activities_data)
    end
  end
end
