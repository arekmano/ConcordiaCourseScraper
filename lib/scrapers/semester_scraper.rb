require 'open-uri'
require 'nokogiri'
require 'openssl'
require_relative './course_scraper'
require_relative './nokogiri_scraper'
require_relative '../models/semester'


class SemesterScraper < NokogiriScraper

  def self.extract(uri)
    doc = Nokogiri::HTML(open(uri))
    semester = Semester.new(
      semester: semester(doc),
      year: year(doc)
    )
    courses = doc.css('table tbody tr th a')
    courses.each do |course|
      course_uri =  "#{uri.scheme}://#{uri.host + uri.path + course.attr('href')}"
      begin
        semester.courses << CourseScraper.extract(course_uri)
      rescue
      end
    end
    puts "Semester Scraped: #{semester.year} #{semester.semester}."
    semester
  end

  def self.year(doc)
    doc.css('#maincontent > div.insidecontent > h1')[0].content.gsub(/[^0-9]/, '')[0..3].to_i
  end

  def self.semester(doc)
    doc.css('#maincontent > div.insidecontent > h1')[0].content.gsub(/[^A-Za-z ]/, '').split(' ')[0]
  end
end
