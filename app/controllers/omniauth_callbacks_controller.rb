class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def moves
    @user = User.find_or_create(auth_hash.credentials.to_hash.update('first_record_on' => first_record_on))
    sign_in @user if @user.persisted?
    redirect_to '/'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  def first_record_on
    auth_hash.info.firstDate
  end
end
