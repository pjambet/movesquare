require 'spec_helper'

describe SegmentFetcher do
  before(:each) { stub_const('SegmentFetcher::PAUSE_TIME', 0) }
  context 'new instance' do
    let(:user) { instance_double('User') }
    subject(:fetcher) { SegmentFetcher.new(user) }

    it { expect(fetcher).not_to be_nil }
  end
  let(:token) { 'BGr3iE1BWtqiAnRBeRRjB8MwpwMcB5hG10r5695Ibvs1G6mq_cOPh69ry1tZW7bb' }

  describe '#storyline' do
    let(:user) { mock_model('User', token: token) }
    subject(:fetcher) { SegmentFetcher.new(user) }

    let(:result) do
      VCR.use_cassette('SegmentFetcher/fetch_specific') { fetcher.storyline '2014-01-01' }
    end

    it { expect(result).to be_an_instance_of(Array) }
    it { expect(result[0]['date']).to eq('20140101') }
    it { expect(result[0]['segments']).to be_an_instance_of(Array) }
  end

  describe '#fetch' do
    let(:user) { mock_model('User', token: token) }
    subject(:fetcher) { SegmentFetcher.new(user) }

    context 'with a result' do
      let(:result) do
        VCR.use_cassette('SegmentFetcher/fetch_specific') { fetcher.fetch '2014-01-01' }
      end

      it { expect(result).to be_an_instance_of(Array) }
      it { expect(result.length).to be > 1  }
      it { expect(result.first).to be_an_instance_of(Segment)  }
      it { expect(result.first).to be_persisted }
    end

    context 'no record' do
      let(:result) do
        VCR.use_cassette('SegmentFetcher/no_results') { fetcher.fetch '2011-01-01' }
      end

      it { expect(result).to be_nil }
    end

  end

  describe '#fetch_all' do
    let(:user) { mock_model('User', token: token) }
    subject(:fetcher) { SegmentFetcher.new(user) }
    let(:today) { Date.today }

    context 'with ???' do

      it 'calls fetch with today' do
        expect(fetcher).to receive(:fetch).with(today).exactly(1).times
        fetcher.fetch_all
      end
    end
  end

  describe '.crawl' do
    before(:each) { 3.times { mock_model(User, token: token) } }

    it 'crawls without error' do
      VCR.use_cassette('SegmentFetcher/crawl') do
        expect{ SegmentFetcher.crawl }.not_to raise_error
      end
    end
  end

end
