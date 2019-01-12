require 'google/apis/calendar_v3'


class CalendarManager
  def initialize(service:, calendar_id:)
    @service = service
    @calendar_id = calendar_id
  end

  def create(summary:, start_date_in:, end_date_in:)
    # イベントを作成する
    start_date = event_date_time( date: start_date_in)
    end_date   = event_date_time( date: end_date_in)

    event(start_date: start_date, end_date: end_date, summary: summary)
  end

  def insert_event(event: nil)
    # イベントをinsertする
    return unless event
    @service.insert_event( @calendar_id, event)
  end


  def find_event(date:)
    list = @service.list_events(@calendar_id,
                         single_events: true,
                         order_by: 'startTime',
                         time_min: (date.to_datetime.new_offset('+09:00') - 1).iso8601,
                         #time_max: date.to_datetime.new_offset('+09:00').iso8601,
                         max_results: 1,
                         )
    if list.items.size > 0
      list.items.first
    else
      nil
    end
  end

  def delete_event(event_id:)
    @service.delete_event(@calendar_id, event_id)
  end

  private
  def event_date_time(date:)
    Google::Apis::CalendarV3::EventDateTime.new( date: date.strftime('%Y-%m-%d'), timezone: 'Asia/Tokyo' )
  end

  def event(start_date:, end_date:, summary:)
    Google::Apis::CalendarV3::Event.new(start: start_date, end: end_date, summary: summary)
  end
end