require_relative '../spec_helper'
require_relative '../../lib/scrapers/nokogiri_scraper'

RSpec.describe NokogiriScraper do
  it 'opens urls correctly' do
    response = NokogiriScraper.new.load_uri('https://www.google.ca')

    expect(response.title).to eq('Google')
  end
end
