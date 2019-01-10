require 'open-uri'
require_relative './html'

class WebHtml
  def initialize(base_url, year, months)
    @base_url = base_url
    @year = year
    @months = months
  end

  def htmls
    result = []

    @months.each do |month|
      url = "#{@base_url}/#{@year}#{month}/index.html"
      raw_html = open(url) do |f|
        f.read
      end

      html = Html.new(year: @year, month: month, html: raw_html)
      result.push html
    end

    result
  end
end