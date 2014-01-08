require 'spec_helper'

describe OmniauthCallbacksController do
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.env['omniauth.auth'] = double(
      credentials: OmniAuth::AuthHash.new(token: 'XXX', refresh_token: 'YYY', expires_at: '1234'))
  end

  describe 'GET /moves' do
    it "creates a user" do
      expect{get :moves}.to change{User.count}.by(1)
    end
  end
end
