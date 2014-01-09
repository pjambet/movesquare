class SegmentFetcher
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def self.crawl
    self
  end

  def storyline(date=nil)
    @storyline ||= client.daily_storyline(date)
  end

  def fetch(date=nil)
    segments = storyline(date).first['segments']
    segments.map do |segment_data|
      segment = Segment.create_segment segment_data, segments
      segment
    end
  end

  def client
    @client ||= Moves::Client.new(user.token)
  end
end
