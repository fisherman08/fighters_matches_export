require 'google/apis/calendar_v3'

class CalendarCreator
  def initialize(service:, calendar_id:)
    @service = service
    @calendar_id = calendar_id
  end

  def create
    start_date = Google::Apis::CalendarV3::EventDateTime.new date: "2019-01-20", timezone: 'Asia/Tokyo'
    end_date = Google::Apis::CalendarV3::EventDateTime.new date: "2019-01-20", timezone: 'Asia/Tokyo'
    event = Google::Apis::CalendarV3::Event.new(start: start_date, end: end_date, summary: 'test')
    @service.insert_event( @calendar_id, event)
  end

  private
  def event_date_time
    
  end

  def event

  end
end