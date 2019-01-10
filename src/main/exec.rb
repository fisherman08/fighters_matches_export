require 'open-uri'
require 'nokogiri'
require 'pp'

begin

  result = []
  base_url = 'https://www.fighters.co.jp/game/schedule'
  year = '2019'
  months = %w(04)

  # 月ごとに見ていく
  months.each do |month|
    url = "#{base_url}/#{year}#{month}/index.html"
    html = open(url) do |f|
      charset = f.charset
      f.read
    end
    pp html
  end

  m = Match.new(date = "", opponent = "")
rescue => e
    pp e
end


class Match
    attr_reader :date, :opponent, :stadium
    @date     = ""
    @opponent = ""
    @stadium  = ""

    def initialize(date, opponent, stadium = "")
        @date     = date
        @opponent = opponent
        @stadium  = stadium
    end

end