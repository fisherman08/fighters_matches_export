
require 'pp'

require_relative './scraper/scraper'
require_relative './html/web_html'

begin

  base_url = 'https://www.fighters.co.jp/game/schedule'
  year = '2019'
  months = %w(03)

  htmls = WebHtml.new(base_url, year, months).htmls

  matches = Scraper.new(htmls: htmls).scrape

  pp matches

rescue => e
    pp e
end

