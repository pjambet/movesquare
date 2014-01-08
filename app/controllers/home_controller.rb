class HomeController < ApplicationController
  def index
    @profile = Moves::Client.new(current_user.token)
  end
end
