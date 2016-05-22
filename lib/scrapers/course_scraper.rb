require 'nokogiri'
require_relative '../models/course'
require_relative './nokogiri_scraper'
require_relative './section_scraper'

class CourseScraper < NokogiriScraper
  attr_accessor :courses, :section_scraper

  def initialize(options = {})
    @section_scraper = options.fetch(:section_scraper)
    @courses = []
  end

  def extract(uri, semester)
    doc = load_uri uri
    course = Course.new(
      name: course_name(doc),
      semester: semester
    )
    data_table = doc.at('table:contains("Instructor")')
    raise 'No data table for course: ' + uri if data_table.nil?
    data = data_table.css('tbody tr td')
    course_data course, data
    puts "Course Scraped: #{course.name}"
    @courses << course
    course
  end

  def course_name(doc)
    doc.css('#maincontent div h1')[0].content
  end

  def course_data(course, data)
    (data.size / 9).times do |i|
      section_data = data[(9 * i)..(9 * i + 7)]
      section = @section_scraper.extract(section_data, course)
      case section.section_type
      when 'Tut'
        course.tutorials << section
      when 'Lab'
        course.laboratories << section
      when 'Lec'
        course.lectures << section
      end
    end
  end
end
