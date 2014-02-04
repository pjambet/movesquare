require 'spec_helper'

describe User do

  context 'new record' do
    subject { create :user }

    it { expect validate_uniqueness_of :email }
    it { expect validate_uniqueness_of :token }
    it { expect validate_presence_of :token }
    it { expect validate_presence_of :refresh_token }
    it { expect validate_presence_of :expires_at }
  end


  describe '.find_or_create' do
    context 'with correct params' do
      let(:params) do
        {
          'token' =>  'XXX',
          'refresh_token' => 'YYY',
          'expires_at' => true,
          'expires_at' => 1234,
          'first_record_on' => '20131213',
        }
      end
      let(:extra) do
        {
          'moves_profile' => {
            'userId' => 55101285779628360,
            'profile' => {
              'firstDate' => "20111201",
              'currentTimeZone' => {
                'id' => "America/New_York",
                'offset' => -18000
              },
              'caloriesAvailable' => false,
              'platform' => "android"
            }
          }
        }
      end
      subject(:user) { User.find_or_create(params, extra) }

      it { expect(user).to be_persisted }
      it { expect(user.first_record_on).to eq(Date.new(2013,12,13)) }
      it { expect(user.moves_profile).to be_an_instance_of(Hash) }
    end

    context 'with incorrect params' do
      let(:params) do
        {'foo' =>  'XXX', 'refresh_token' => 'YYY', 'expires_at' => true, 'expires_at' => 1234}
      end
      subject(:user) { User.find_or_create(params) }

      it { expect(user).not_to be_persisted }
    end

    context 'with existing user' do
      before(:each) { User.create params }
      let(:params) do
        {'token' =>  'XXX', 'refresh_token' => 'YYY', 'expires_at' => true, 'expires_at' => 1234}
      end
      subject(:user) { User.find_or_create(params.update('token' => 'AAA')) }

      it { expect(user).to be_persisted }
    end
  end
end
