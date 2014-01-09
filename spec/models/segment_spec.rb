require 'spec_helper'

describe Segment do

  it { expect belong_to :user }
  it { expect validate_presence_of(:lat) }
  it { expect validate_presence_of(:lng) }
  it { expect(Segment.new.distance).to eq(0) }

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

end
