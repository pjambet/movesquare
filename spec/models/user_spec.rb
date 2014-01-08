require 'spec_helper'

describe User do

  it { expect validate_presence_of :token }
  it { expect validate_presence_of :refresh_token }
  it { expect validate_presence_of :expires_at }

  describe '.find_or_create' do
    context 'with correct params' do
      let(:params) do
        {'token' =>  'XXX', 'refresh_token' => 'YYY', 'expires_at' => true, 'expires_at' => 1234}
      end
      subject(:user) { User.find_or_create(params) }

      it { expect(user).to be_persisted }
    end

    context 'with incorrect params' do
      let(:params) { {foo: 'XXX', refresh_token: 'YYY', expires_at: true, expires_at: 1234} }
      subject(:user) { User.find_or_create(params) }

      it { expect{user}.to raise_error(ActiveRecord::StatementInvalid) }
    end
  end
end
