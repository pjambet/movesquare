require 'spec_helper'

describe Calculator do
  describe 'total_distance' do
    context 'no activities' do
      let(:activities) { [] }
      subject(:calculator) { Calculator.new activities }

      it { expect(calculator.total_distance).to eq(0) }
    end

    context 'with one activity' do
      let(:activities) { [{'distance' => 5}] }
      subject(:calculator) { Calculator.new activities }

      it { expect(calculator.total_distance).to eq(5) }
    end

    context 'with activities' do
      let(:activities) { [{'distance' => 5}, {'distance' => 10}] }
      subject(:calculator) { Calculator.new activities }

      it { expect(calculator.total_distance).to eq(15) }
    end
  end
end
