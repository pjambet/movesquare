require 'spec_helper'

describe DistanceCalculator do
  describe 'total_distance' do
    context 'no segments' do
      let(:segments) { [] }
      subject(:calculator) { DistanceCalculator.new segments }

      it { expect(calculator.total_distance).to eq(0) }
    end

    context 'with one segment' do
      let(:segments) { [double("segment", distance: 5)] }
      subject(:calculator) { DistanceCalculator.new segments }

      it { expect(calculator.total_distance).to eq(5) }
    end

    context 'with segments' do
      let(:segments) { [double("segment", distance: 5), double("segment", distance: 10)] }
      subject(:calculator) { DistanceCalculator.new segments }

      it { expect(calculator.total_distance).to eq(15) }
    end
  end
end
