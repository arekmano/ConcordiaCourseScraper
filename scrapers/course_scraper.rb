require 'open-uri'
require 'nokogiri'
require 'openssl'
require_relative '../models/course'
require_relative './nokogiri_scraper'
require_relative './section_scraper'


class CourseScraper < NokogiriScraper
  def self.extract(uri)
    doc = Nokogiri::HTML(open(uri))
    course = Course.new(name: course_name(doc))
    data_table = doc.at('table:contains("Instructor")')
    raise 'No data table for course: ' + uri if data_table.nil?
    data = data_table.css('tbody tr td')
    course_data course, data
    puts "Course Scraped: #{course.name}"
    course
  end

  def self.course_name(doc)
    doc.css('#maincontent div h1')[0].content
  end

  def self.course_data(course, data)
    (data.size / 9).times do |i|
      section_data = data[(9 * i)..(9 * i + 7)]
      section = SectionScraper.extract(section_data)
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
