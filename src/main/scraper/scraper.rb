require 'open-uri'
require 'nokogiri'

class Scraper
  # 公式ホームページにつないで試合データを取ってくるクラス

  def initialize(base_url, year, months)
    @base_url = base_url
    @year = year
    @months = months

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
    charset = ""
    # 月ごとに見ていく
    @months.each do |month|
      doc = document(month)
      trs = doc.css('table.pl_gameCalendar02 tbody tr')
      next  unless trs

      trs.each do |tr|
        day    = date(tr)
        stadium = stadium(tr)
        opponent = opponent(tr)

        date = "#{@year}/#{month}/#{"%#02d" % day.to_i}"
        match = Match.new(date: date, stadium: stadium, opponent: opponent)
        result.push match
      end

    end

    result.freeze
  end


  private
  # documentを取ってくる
  def document(month)
    url = "#{@base_url}/#{@year}#{month}/index.html"
    charset = ""
    html = open(url) do |f|
      charset = f.charset
      f.read
    end

    Nokogiri::HTML.parse(html, nil, charset)
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


  class Match
    attr_reader :date, :opponent, :stadium
    @date     = ""
    @opponent = ""
    @stadium  = ""

    def initialize(date:, opponent:, stadium:)
      @date     = date
      @opponent = opponent
      @stadium  = stadium
    end

  end


end