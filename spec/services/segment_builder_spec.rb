require 'spec_helper'

describe SegmentBuilder do
  subject(:builder) { SegmentBuilder::Builder.new(segment_data, segments) }
  let(:segment_data) { double }
  let(:segments) { [] }

  it { expect(builder).not_to be_nil }

  describe '#create_segment' do
    subject(:segment) do
      VCR.use_cassette('SegmentBuilder/create_segment') do
        SegmentBuilder::Builder.new(segment_data, context).build
      end
    end
    let(:context) { fixture('storyline.json').first['segments'] }

    context 'wrong type' do
      let(:segment_data) { {'type' => 'foo'} }

      it { expect{segment}.to raise_error(SegmentBuilder::UnknownSegmentType) }
    end

    context 'place' do
      let(:segment_data) { fixture('segment_place.json') }

      it { expect(segment).to be_persisted }
      it { expect(segment).to be_located }
      it { expect(segment.segment_type).to eq('move') }
      it { expect(segment.distance).to be > 0 }
      it { expect(segment.steps).to be > 0 }
      it { expect(segment.duration).to be > 0 }
    end

    context 'move' do
      let(:segment_data) { fixture('segment_move_wlk.json') }

      it { expect(segment).to be_persisted }
      it { expect(segment).to be_located }
      it { expect(segment.segment_type).to eq('place') }
      it { expect(segment.distance).to be > 0 }
      it { expect(segment.steps).to be > 0 }
      it { expect(segment.duration).to be > 0 }
    end

  end
end
