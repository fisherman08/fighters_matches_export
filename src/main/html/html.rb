
class Html
  attr_reader :year, :month, :html
  def initialize(year:, month:, html:)
    @year = year
    @month = month
    @html = html
  end
end