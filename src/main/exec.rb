
require 'pp'

require_relative './scraper/scraper'
require_relative './html/web_html_downloader'
require_relative './google/connector'
require_relative './google/calendar_creator'

begin

  #base_url = 'https://www.fighters.co.jp/game/schedule'
  #year = '2019'
  #months = %w(03)

  #htmls = WebHtmlDownloader.new(base_url, year, months).htmls

  #matches = Scraper.new(htmls: htmls).scrape

  #pp matches

  credentials = (File.dirname(__dir__) + '/../config/credentials.json').freeze
  token = (File.dirname(__dir__) + '/../config/token.yaml').freeze
  config = YAML.load_file((File.dirname(__dir__) + '/../config/config.yml'))
  calendar_id = config[:calendar_id]

  calendar_service = Connector.new(credential: credentials, token: token).service
  creator = CalendarCreator.new service: calendar_service, calendar_id: calendar_id
  creator.create


  response = calendar_service.list_events(calendar_id,
                                 max_results: 10,
                                 single_events: true,
                                 order_by: 'startTime',
                                 time_min: Time.now.iso8601)
  puts 'Upcoming events:'
  puts 'No upcoming events found' if response.items.empty?
  response.items.each do |event|
    start = event.start.date || event.start.date_time
    puts "- #{event.summary} (#{start})"
  end

rescue => e
  pp e
  pp e.backtrace

end

