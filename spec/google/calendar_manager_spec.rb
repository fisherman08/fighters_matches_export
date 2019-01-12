require_relative '../spec_helper'
require 'pp'
require './src/main/google/calendar_manager'
require './src/main/entity/match'

describe 'CalendarManager' do

  describe 'can create an event from a match' do
    manager = CalendarManager.new service: nil, calendar_id: nil
    match = Match.new(opponent: "オリ", date: Date.new(2019, 4, 14), stadium: "札幌ドーム")
    event = manager.create(match.export_for_event)

    it 'and can create summary' do
      expect(event.summary).to eq 'オリ戦 @札幌ドーム'
    end

    it 'and can create appropriate date' do
      expect(event.start.date).to eq '2019-04-14'
      expect(event.end.date).to eq '2019-04-14'
    end

  end

end