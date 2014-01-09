require 'spec_helper'

describe Segment do

  context 'new instance' do
    subject(:segment) { Segment.new }

    it { expect belong_to :user }
    it { expect validate_presence_of(:lat) }
    it { expect validate_presence_of(:lng) }
    it { expect(segment.distance).to eq(0) }
    it { expect(segment.steps).to eq(0) }
  end

  describe '.for_location' do
    let!(:nyc_segment) { create :segment, city: nyc }
    let!(:bdx_segment) { create :segment, city: bdx }
    let!(:nyc) { create :nyc }
    let!(:bdx) { create :bdx }
    subject(:segments) { Segment.for_location(nyc).to_a }

    it 'returns only included segments' do
      expect(segments.count).to be(1)
      expect(segments).to include(nyc_segment)
      expect(segments).not_to include(bdx_segment)
    end
  end

  describe '.for_user' do
    let(:user) { create :user }
    before(:each) do
      2.times { create :segment }
      2.times { create :segment, user: user }
    end
    subject(:segments) { Segment.for_user user }

    it { expect(segments.count).to eq(2) }
    it { expect(segments.map(&:user).uniq).to eq([user]) }
  end

  describe '.create_segment' do
    subject(:segment) { Segment.create_segment segment_data, context }
    let(:context) { fixture('storyline.json').first['segments'] }

    context 'place' do
      let(:segment_data) { fixture('segment_place.json') }

      it { expect(segment).to be_persisted }
      it { expect(segment.distance).to be > 0 }
      it { expect(segment.steps).to be > 0 }
      it { expect(segment.duration).to be > 0 }
    end

    context 'move' do
      let(:segment_data) { fixture('segment_move_wlk.json') }

      it { expect(segment).to be_persisted }
      # it { expect(segment.distance).to be > 0 }
      # it { expect(segment.steps).to be > 0 }
      # it { expect(segment.duration).to be > 0 }

      context 'trp' do
        # let(:segment_data) { fixture('storyline.json').first['segments'][1] }

        # it { expect(segment).to be_persisted }
        # it { expect(segment.distance).to be > 0 }
        # it { expect(segment.steps).to be > 0 }
        # it { expect(segment.duration).to be > 0 }
      end
    end
  end
end
