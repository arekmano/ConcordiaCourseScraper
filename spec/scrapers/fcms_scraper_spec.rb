require_relative '../spec_helper'
require_relative '../../lib/scrapers/fcms_scraper'

RSpec.describe FcmsScraper do
  describe 'correctly scrapes the time' do
    it 'in the AM' do
      scraper = FcmsScraper.new

      time = scraper.parse_time('3:15AM')

      expect(time).not_to be_nil
      expect(time.year).to eq(0)
      expect(time.month).to eq(1)
      expect(time.day).to eq(1)
      expect(time.hour).to eq(3)
      expect(time.min).to eq(15)
    end

    it 'in the PM' do
      scraper = FcmsScraper.new

      time = scraper.parse_time('3:15PM')

      expect(time).not_to be_nil
      expect(time.year).to eq(0)
      expect(time.month).to eq(1)
      expect(time.day).to eq(1)
      expect(time.hour).to eq(15)
      expect(time.min).to eq(15)
    end
  end
end
