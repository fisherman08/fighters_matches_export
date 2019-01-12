
require 'pp'

require_relative './scraper/scraper'
require_relative './html/web_html_downloader'
require_relative './google/connector'
require_relative './google/calendar_manager'

begin

  base_url = 'https://www.fighters.co.jp/game/schedule'
  year = '2019'
  months = %w(03 04 05 06 07 08 09)

  pp 'Get Htmls: Start'
  htmls = WebHtmlDownloader.new(base_url, year, months).htmls
  pp "Get Htmls: End: #{htmls.size}"

  pp 'Get matches Start'
  matches = Scraper.new(htmls: htmls).scrape
  pp "#{matches.size} matches have been found"

  credentials = (File.dirname(__dir__) + '/../config/credentials.json').freeze
  token = (File.dirname(__dir__) + '/../config/token.yaml').freeze
  config = YAML.load_file((File.dirname(__dir__) + '/../config/config.yml'))
  calendar_id = config[:calendar_id]

  calendar_service = Connector.new(credential: credentials, token: token).service
  manager = CalendarManager.new service: calendar_service, calendar_id: calendar_id

  matches.each do |match|
    pp 'Start insert: ' + match.date.iso8601
    old_event = manager.find_event(date: match.date)
    manager.delete_event(event_id: old_event.id) if old_event
    event = manager.create match.export_for_event
    manager.insert_event(event: event)
  end

  pp 'Finish!!'

rescue => e
  pp e
  pp e.backtrace

end

