require 'open-uri'

require_relative '../spec_helper'
require_relative '../../lib/scrapers/course_scraper'

RSpec.describe CourseScraper do

  it 'extracts data from MECH 313 correctly' do
    # Test data
    test_uri = 'https://aits.encs.concordia.ca/oldsite/resources/schedules/courses/details/?ys=20152&d=04&c=MECH313'
    scraper = CourseScraper.new(section_scraper: SectionScraper.new)

    # Execute
    course = scraper.extract(test_uri, double('mock semester'))

    # Verify
    expect(course.tutorials.size).to eq(2)
    expect(course.lectures.size).to eq(1)
    expect(course.name).to eq('Machine Drawing and Design')
  end

  it 'sorts tutorials correctly' do
    # Test data
    scraper = CourseScraper.new(section_scraper: SectionScraper.new)
    test_course = Course.new

    # Mock object
    mock_section_scraper = double('Mock Section Scraper')
    allow(mock_section_scraper).to receive(:extract).with(any_args).and_return(Section.new(section_type: 'Tut'))
    scraper.section_scraper = mock_section_scraper

    # Execute
    scraper.course_data(test_course, (1..18).to_a)

    # Verify
    expect(test_course.tutorials.size).to eq(2)
    expect(test_course.lectures.size).to eq(0)
    expect(test_course.laboratories.size).to eq(0)

  end

  it 'sorts lectures correctly' do
    # Test data
    scraper = CourseScraper.new(section_scraper: SectionScraper.new)
    test_course = Course.new

    # Mock object
    mock_section_scraper = double('Mock Section Scraper')
    allow(mock_section_scraper).to receive(:extract).with(any_args).and_return(Section.new(section_type: 'Lec'))
    scraper.section_scraper = mock_section_scraper

    # Execute
    scraper.course_data(test_course, (1..18).to_a)

    # Verify
    expect(test_course.tutorials.size).to eq(0)
    expect(test_course.lectures.size).to eq(2)
    expect(test_course.laboratories.size).to eq(0)
  end

  it 'sorts labs correctly' do
    # Test data
    scraper = CourseScraper.new(section_scraper: SectionScraper.new)
    test_course = Course.new

    # Mock object
    mock_section_scraper = double('Mock Section Scraper')
    allow(mock_section_scraper).to receive(:extract).with(any_args).and_return(Section.new(section_type: 'Lab'))
    scraper.section_scraper = mock_section_scraper

    # Execute
    scraper.course_data(test_course, (1..18).to_a)

    # Verify
    expect(test_course.tutorials.size).to eq(0)
    expect(test_course.lectures.size).to eq(0)
    expect(test_course.laboratories.size).to eq(2)
  end
end
