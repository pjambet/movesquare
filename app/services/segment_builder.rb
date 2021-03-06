module SegmentBuilder
  UnknownSegmentType = Class.new(StandardError)
  NoLocationAvailable = Class.new(StandardError)

  class Builder

    attr_reader :segment_data, :context, :user

    def initialize(segment_data, context, user)
      @segment_data = segment_data
      @context = context
      @user = user
    end

    def build
      if segment_data['type'] == 'place'
        SegmentBuilder::PlaceBuilder.new(segment_data, context, user).persist
      elsif segment_data['type'] == 'move'
        SegmentBuilder::MoveBuilder.new(segment_data, context, user).persist
      elsif segment_data['type'] == 'off'
        nil
      elsif not %w(place move).include?(segment_data['type'])
        raise SegmentBuilder::UnknownSegmentType
      end
    end

    def persist
      segment_location = SegmentLocator.new(params[:lat], params[:lng]).locate_segment
      Segment.create params.update(neighborhood: segment_location.neighborhood,
                                   city: segment_location.city,
                                   state: segment_location.state,
                                   country: segment_location.country,
                                   activity_type: 'wlk',
                                   user: user)
    rescue
      # Couldn't locate
    end

    def activities_data
      activities = segment_data['activities']
      if activities
        calc = Calculator.new activities
        {
          distance: calc.total_distance,
          steps: calc.total_steps,
          duration: calc.total_duration,
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
