class HomeController < ApplicationController
  def index
    @profile = Moves::Client.new(current_user.token).profile if current_user
  end
end
