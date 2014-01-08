require 'spec_helper'

describe SegmentLocator do
  describe '.create_segment' do

    context 'Menahan Avenue', :vcr do
      before(:all) do
        lat, lng = 40.7028983,-73.91233849999999
        VCR.use_cassette('SegmentLocator/menahan') do
          @segment = SegmentLocator.new(lat, lng).create_segment
        end
      end

      subject(:segment) { @segment }
      it { expect(segment).to be_an_instance_of Segment }

      context 'neighborhood' do
        let(:neighborhood) { segment.neighborhood }

        it { expect(neighborhood).to be_an_instance_of Location }
        it { expect(neighborhood.slug).to eq('ridgewood') }
        it { expect(neighborhood.name).to eq('Ridgewood') }
      end

      context 'city' do
        let(:city) { segment.city }

        it { expect(city).to be_an_instance_of Location }
        it { expect(city.name).to eq('New York') }
        it { expect(city.slug).to eq('new york') }
      end

      context 'state' do
        let(:state) { segment.state }

        it { expect(state).to be_an_instance_of Location }
        it { expect(state.name).to eq('NY') }
        it { expect(state.slug).to eq('ny') }
      end

      context 'country' do
        let(:country) { segment.country }

        it { expect(country).to be_an_instance_of Location }
        it { expect(country.slug).to eq('us') }
        it { expect(country.name).to eq('United States') }
      end

    end

    context '76 rue leyteire', :vcr do
      before(:all) do
        lat, lng = 44.83175929999999, -0.5697435
        VCR.use_cassette('SegmentLocator/leyteire') do
          @segment = SegmentLocator.new(lat, lng).create_segment
        end
      end
      subject(:segment) { @segment }

      it { expect(segment).to be_an_instance_of Segment }
      it { expect(segment.country).to be_an_instance_of Location }
      it { expect(segment.country.slug).to eq('fr') }
    end
  end

  describe '.create_missing_locations' do
    before(:all) do
      VCR.use_cassette('SegmentLocator/menahan') do
        @segment_locator = SegmentLocator.new(40.7028983,-73.91233849999999)
      end
      @neighborhood = @segment_locator.neighborhood.reload
      @city = @segment_locator.city.reload
      @state = @segment_locator.state.reload
      @country = @segment_locator.country.reload
    end

    it { expect(@neighborhood.parent).to eq(Location.find_by(slug: 'new york', location_type: 'city')) }
    it { expect(@city.parent).to eq(Location.find_by(slug: 'ny', location_type: 'state')) }
    it { expect(@state.parent).to eq(Location.find_by(slug: 'us', location_type: 'country')) }
    it { expect(@country.parent).to be nil }
  end
end
