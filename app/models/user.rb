class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  # devise :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  devise :registerable, :omniauthable, :rememberable, :trackable

  validates :token, presence: true

  def self.find_or_create(params)
    params.slice! *%w(token refresh_token expires_at)
    User.find_or_create_by params
  end

end
