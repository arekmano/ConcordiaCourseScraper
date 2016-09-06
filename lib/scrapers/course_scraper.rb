require 'nokogiri'

require_relative '../models/course'
require_relative '../models/course_list'
require_relative './nokogiri_scraper'
require_relative './section_scraper'

class CourseScraper < NokogiriScraper
  attr_accessor :course_list, :section_scraper

  def initialize(options = {})
    @section_scraper = options.fetch(:section_scraper, SectionScraper.new)
    @course_list = options.fetch(:course_list, CourseList.new)
  end

  def extract(uri, semester)
    doc = load_uri uri
    course = @course_list.get(
      course_name(doc).split(' - ')[0],
      course_name(doc).split(' - ')[1]
    )
    data_table = doc.at('table:contains("Instructor")')
    raise 'No data table for course: ' + uri if data_table.nil?
    data = data_table.css('tbody tr td')
    course_data course, semester, data
    puts "Course Scraped: #{course.name}"
    course
  end

  def course_name(doc)
    doc.css('#maincontent div h1')[0].content
  end

  def course_data(course, semester, data)
    (data.size / 9).times do |i|
      section_data = data[(9 * i)..(9 * i + 7)]
      section = @section_scraper.extract(section_data, course, semester)
    end
  end
end
