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
        {'token' =>  'XXX', 'refresh_token' => 'YYY', 'expires_at' => true,
         'expires_at' => 1234, 'first_record_on' => '20131213'}
      end
      subject(:user) { User.find_or_create(params) }

      it { expect(user).to be_persisted }
      it { expect(user.first_record_on).to eq(Date.new(2013,12,13)) }
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
