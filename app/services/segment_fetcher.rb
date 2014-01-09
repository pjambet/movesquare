class SegmentFetcher
  attr_reader :user
  # Fetch all segments from moves api and locate them
  def initialize(user)
    @user = user
  end

  def fetch(date=nil)
    client.daily_activities date
  end

  def client
    Moves::Client.new(user.token)
  end
end
