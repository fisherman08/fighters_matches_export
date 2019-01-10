
require 'nokogiri'
require 'date'
require_relative '../entity/match'

class Scraper
  # 公式ホームページにつないで試合データを取ってくるクラス

  def initialize(htmls:)
    @htmls = htmls

    # 試合詳細の画像ファイル名からチーム名に変換するdict
    @team_map = {
      pf: 'ハム',
      pe: '楽天',
      pl: '西武',
      pm: 'ロッテ',
      pb: 'オリ',
      ph: 'ソフバン',
      cg: '読売',
      cs: 'ヤクルト',
      db: '横浜',
      cd: '中日',
      ct: '阪神',
      cc: '広島'
    }

  end

  def scrape
    result = []
    # 月ごとに見ていく
    @htmls.each do |html|
      doc = document(html.html)
      trs = doc.css('table.pl_gameCalendar02 tbody tr')
      next  unless trs

      trs.each do |tr|
        day    = date(tr)
        stadium = stadium(tr)
        opponent = opponent(tr)

        date = Date.new(html.year.to_i, html.month.to_i, day.to_i)
        match = Match.new(date: date, stadium: stadium, opponent: opponent).freeze
        result.push match
      end

    end

    result.freeze
  end


  private
  # documentを取ってくる
  def document(html)
    Nokogiri::HTML.parse(html, nil, 'utf-8')
  end

  # trから開催日を取得する
  def date(tr)
    tr["id"]
  end

  # trから球場を取得する
  def stadium(tr)
    tr.at_css("td.pl_tCenter").text
  end

  # trから対戦相手を取得する
  def opponent(tr)
    td = tr.css("td")[1]

    # 対戦相手は画像でしかないので、画像のファイル名から逆引きしてチーム名を取得
    team_name = ""
    td.css("figure.pl_gameTeam img").each do |img|
      _team_name = img["src"].to_s.split("/").last.gsub(/_s.png/, "")
      if _team_name != "pf"
        # fightersは除外
        team_name = _team_name
        break
      end
    end

    @team_map[team_name.to_sym]
  end


end