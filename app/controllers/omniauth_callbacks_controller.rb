class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def moves
    User.find_or_create(auth_hash.credentials.to_hash)
    redirect_to '/'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
