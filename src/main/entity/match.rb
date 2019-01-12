require 'date'
class Match
  attr_reader :date, :opponent, :stadium

  def initialize(date:, opponent:, stadium:)
    @date     = date
    @opponent = opponent
    @stadium  = stadium
  end

  def export_for_event
    {
      start_date_in: @date,
      end_date_in: @date,
      summary: "#{@opponent}戦 @#{stadium}"
    }
  end
end
