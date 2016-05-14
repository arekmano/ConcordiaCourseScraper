require 'rspec'
require_relative '../lib/scrapers/course_scraper'
require 'open-uri'
require 'nokogiri'

RSpec.describe CourseScraper do
  it 'extracts time from a string correctly' do
    expect(CourseScraper.extract_time('11:21').class).to eq(Time)
    expect(CourseScraper.extract_time('11:21').class).to eq(Time)
  end

  it 'extracts data from MECH 313 correctly' do
    test_uri = 'https://aits.encs.concordia.ca/oldsite/resources/schedules/courses/details/?ys=20152&d=04&c=MECH313'
    course = CourseScraper.extract(test_uri)
    expect(course.tutorials.size).to eq(3)
    expect(course.lectures.size).to eq(1)
    expect(course.name).to eq('MECH313 - Machine Drawing and Design')
  end
end
