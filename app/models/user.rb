class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  # devise :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  devise :registerable, :omniauthable, :rememberable, :trackable

  def self.find_or_create(params)
    params.slice! *%w(token refresh_token expires_at)
    User.create params
  end

end
