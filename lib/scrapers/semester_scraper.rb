require 'nokogiri'
require_relative './course_scraper'
require_relative './nokogiri_scraper'
require_relative '../models/semester'

class SemesterScraper < NokogiriScraper
  attr_reader :semesters, :course_scraper

  def initialize(options = {})
    @semesters = []
    @course_scraper = options.fetch(:course_scraper)
  end

  def extract(uri)
    doc = load_uri uri
    semester = Semester.new(
      semester: semester(doc),
      year: year(doc)
    )
    courses = doc.css('table tbody tr th a')
    courses.each do |course|
      course_uri =  "#{uri.scheme}://#{uri.host + uri.path + course.attr('href')}"
      begin
        semester.courses << @course_scraper.extract(course_uri, semester)
      rescue
      end
    end
    puts "Semester Scraped: #{semester.year} #{semester.semester}."
    @semesters << semester
    semester
  end

  def year(doc)
    doc.css('#maincontent > div.insidecontent > h1')[0].content.gsub(/[^0-9]/, '')[0..3].to_i
  end

  def semester(doc)
    doc.css('#maincontent > div.insidecontent > h1')[0].content.gsub(/[^A-Za-z ]/, '').split(' ')[0]
  end
end
