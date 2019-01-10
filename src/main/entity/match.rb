require 'date'
class Match
  attr_reader :date, :opponent, :stadium

  def initialize(date:, opponent:, stadium:)
    @date     = date
    @opponent = opponent
    @stadium  = stadium
  end

end
