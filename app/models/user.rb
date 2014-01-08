class User < ActiveRecord::Base
  devise :registerable, :omniauthable, :rememberable, :trackable

  validates :token, presence: true

  def self.find_or_create(params)
    params.slice! *%w(token refresh_token expires_at first_record_on)
    User.find_or_create_by(params)
  end

end
