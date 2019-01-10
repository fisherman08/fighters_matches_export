require_relative '../spec_helper'
require 'pp'
require './src/main/html/html'
require './src/main/scraper/scraper'

describe 'Scraper' do
  raw_html = File.open(File.expand_path(__dir__) + '/../resource/scraper/sample.html', 'r') do |f|
    f.read
  end
  htmls = [
    Html.new(year: '2019', month: '03', html: raw_html)
  ]
  scraper = Scraper.new(htmls: htmls)
  matches = scraper.scrape

  it 'can scrape all rows' do
    expect(matches.size).to eq 16
  end

  match_on_10th = matches[5]
  it 'can scrape day' do
    expect(match_on_10th.date).to eq Date.new(2019, 3, 10)
  end

  it 'can scrape opponent' do
    expect(match_on_10th.opponent).to eq 'オリ'
  end

  it 'can scrape stadium' do
    expect(match_on_10th.stadium).to eq '京セラD大阪'
  end

end