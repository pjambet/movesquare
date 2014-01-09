require 'spec_helper'

describe SegmentFetcher do
  context 'new instance' do
    let(:user) { instance_double('User') }
    subject(:fetcher) { SegmentFetcher.new(user) }

    it { expect(fetcher).not_to be_nil }
  end

  describe '#fetch' do
    let(:user) { mock_model('User', token: '5t49q6Tpe8nCNEQ7bJxchcRJ4oQU25ebOumrWTe1RTqmEivJvrJjOcu2w5kMeFms') }
    subject(:fetcher) { SegmentFetcher.new(user) }

    context 'specific date' do
      let(:result) do
        VCR.use_cassette('SegmentFetcher/fetch_specific') { fetcher.fetch '2013-01-01' }
      end

      it { expect(result).to be_an_instance_of(Array) }
      it { expect(result[0]['date']).to eq('20130101') }
    end
  end
end
