require 'spec_helper'

describe OmniauthCallbacksController do
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET /moves' do
    context 'valid parameters' do
      before(:each) do
        @request.env['omniauth.auth'] = double(
          credentials: OmniAuth::AuthHash.new(token: 'XXX', refresh_token: 'YYY', expires_at: '1234'))
      end
      it "creates a user" do
        expect{get :moves}.to change{User.count}.by(1)
      end

      it "log the user in" do
        get :moves
        expect(controller.current_user).not_to be_nil
      end
    end
  end
end
