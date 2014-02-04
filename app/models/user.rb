class User < ActiveRecord::Base
  devise :registerable, :omniauthable, :rememberable, :trackable

  validates :token, :refresh_token, :expires_at, presence: true

  def self.find_or_create(params, extra={})
    params.slice! *%w(token refresh_token expires_at first_record_on)
    user = User.find_or_create_by(params)
    user.update moves_profile: extra
    user
  end

end
