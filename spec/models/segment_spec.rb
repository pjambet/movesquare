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

  describe '#located?' do
    context 'new instance' do
      subject(:segment) { Segment.new }
      it { expect(segment).not_to be_located }
    end

    context 'with neighborhood' do
      let(:neighborhood) { mock_model(Location) }
      subject(:segment) { Segment.new(neighborhood: neighborhood) }
      it { expect(segment).to be_located }
    end

    context 'with city' do
      let(:city) { mock_model(Location) }
      subject(:segment) { Segment.new(city: city) }
      it { expect(segment).to be_located }
    end

    context 'with state' do
      let(:state) { mock_model(Location) }
      subject(:segment) { Segment.new(state: state) }
      it { expect(segment).to be_located }
    end

    context 'with country' do
      let(:country) { mock_model(Location) }
      subject(:segment) { Segment.new(country: country) }
      it { expect(segment).to be_located }
    end
  end

end
