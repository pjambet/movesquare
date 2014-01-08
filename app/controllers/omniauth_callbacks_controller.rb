class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def moves
    user = User.find_or_create(auth_hash.credentials.to_hash)
    sign_in user if user.persisted?
    redirect_to '/'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
