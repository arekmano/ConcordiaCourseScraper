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

  describe 'course info' do
    before(:each) do
      @text = ['COMP 232', 'Computer Class']
    end

    describe 'course code parsing' do
      it 'parses regular things correctly' do
        scraper = FcmsScraper.new

        result = scraper.course_code(@text)

        expect(result).to eq('COMP')
      end
    end

    describe 'course number parsing' do
      it 'parses regular things correctly' do
        scraper = FcmsScraper.new

        result = scraper.course_number(@text)

        expect(result).to eq('232')
      end
    end

    describe 'course title parsing' do
      it 'parses regular things correctly' do
        scraper = FcmsScraper.new

        result = scraper.course_name(@text)

        expect(result).to eq('Computer Class')
      end
    end
  end

  describe 'section type parsing' do
    it 'parses normal things correctly' do
      scraper = FcmsScraper.new

      result = scraper.parse_section_type('WK13-LAB-FSG')

      expect(result).to eq('LAB')
    end

    it 'returns nil when section type is unrecognized' do
      scraper = FcmsScraper.new

      result = scraper.parse_section_type('WK13-BOA-FSG')

      expect(result).to be_nil
    end
  end
end
