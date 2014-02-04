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
      it { expect(segment.segment_type).to eq('place') }
      it { expect(segment.distance).to be > 0 }
      it { expect(segment.steps).to be > 0 }
      it { expect(segment.duration).to be > 0 }
    end

    context 'move' do
      context 'surrounded by places' do
        let(:segment_data) { fixture('segment_move_wlk.json') }

        it { expect(segment).to be_persisted }
        it { expect(segment).to be_located }
        it { expect(segment.segment_type).to eq('move') }
        it { expect(segment.distance).to be > 0 }
        it { expect(segment.steps).to be > 0 }
        it { expect(segment.duration).to be > 0 }
      end

      context 'consecutive moves surrounded by places' do
        subject(:segment) do
          VCR.use_cassette('SegmentBuilder/not_surrounded') do
            SegmentBuilder::Builder.new(segment_data, context).build
          end
        end
        let(:segment_data) { fixture('segment_move_wlk_consecutive.json') }
        let(:context) { fixture('segments_with_consecutive_moves.json') }

        it { expect(segment).to be_persisted }
        it { expect(segment).to be_located }
        it { expect(segment.segment_type).to eq('move') }
        it { expect(segment.distance).to be > 0 }
        it { expect(segment.steps).to be > 0 }
        it { expect(segment.duration).to be > 0 }
      end

      context 'with nothing around' do
        subject(:segment) do
          VCR.use_cassette('SegmentBuilder/place_after') do
            SegmentBuilder::Builder.new(segment_data, context).build
          end
        end
        let(:segment_data) { fixture('segment_move_wlk_nothing_around.json') }
        let(:context) { fixture('segments_with_nothing_around.json') }

        it { expect(segment).to be_nil }
      end

      context 'with nothing after and a place before' do
        subject(:segment) do
          VCR.use_cassette('SegmentBuilder/nothing_after_place_before') do
            SegmentBuilder::Builder.new(segment_data, context).build
          end
        end
        let(:segment_data) { fixture('segment_move_wlk_nothing_after_place_before.json') }
        let(:context) { fixture('segments_with_nothing_after_place_before.json') }

        it { expect(segment).to be_persisted }
        it { expect(segment).to be_located }
        it { expect(segment.lat).to eq(44.8401344963) }
        it { expect(segment.lng).to eq(-0.568250559) }
        it { expect(segment.segment_type).to eq('move') }
        it { expect(segment.distance).to eq(1070) }
        it { expect(segment.steps).to be > 0 }
        it { expect(segment.duration).to be > 0 }
      end
    end
  end
end
