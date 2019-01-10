
require 'pp'

require_relative './scraper/scraper'

begin

  base_url = 'https://www.fighters.co.jp/game/schedule'
  year = '2019'
  months = %w(03)

  scraper = Scraper.new(base_url = base_url, year = year, months = months)

  matches = scraper.scrape

  pp matches

rescue => e
    pp e
end

