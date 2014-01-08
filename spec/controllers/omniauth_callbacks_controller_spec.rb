require 'spec_helper'

describe OmniauthCallbacksController do
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.env['omniauth.auth'] = double(
      credentials: {'token' =>  'XXX', 'refresh_token' =>  'YYY', 'expires_at' =>  '1234'},
      info: double(firstDate: '20130101')
    )
  end

  describe 'GET /moves' do
    context 'with valid params' do
      it "creates a user" do
        expect{get :moves}.to change{User.count}.by(1)
        expect(assigns(:user)).to be_persisted
        expect(assigns(:user).first_record_on).to eq(Date.new(2013,1,1))
      end

      it "log the user in" do
        get :moves
        expect(controller.current_user).not_to be_nil
      end

    end
  end
end
