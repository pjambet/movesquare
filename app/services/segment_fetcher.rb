class SegmentFetcher

  PAUSE_TIME = 0.3

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def self.crawl
    User.order('last_fetched_at ASC').each do |user|
      fetcher = SegmentFetcher.new user
      fetcher.fetch_all
    end
  end

  def storyline(date=nil)
    begin
      client.daily_storyline(date)
    rescue RestClient::BadRequest
      nil
    end
  end

  def fetch_all
    date = Date.today
    while fetch(date) do
      date -= 1.day
    end
  end

  def fetch(date=nil)
    return nil unless storyline(date)
    segments = storyline(date).first['segments']
    p date
    p segments
    segments.map do |segment_data|
      sleep(PAUSE_TIME)
      SegmentBuilder::Builder.new(segment_data, segments).build
    end
  end

  def client
    @client ||= Moves::Client.new(user.token)
  end
end
