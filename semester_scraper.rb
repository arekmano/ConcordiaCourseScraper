require 'open-uri'
require 'nokogiri'
require 'openssl'
require './course_scraper'
require './semester'

class SemesterScraper
  def self.extract(url)
    doc = Nokogiri::HTML(
      open(
        url,
        ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
      )
    )
    semester = Semester.new(
      semester: semester(doc),
      year: year(doc)
    )
    courses = doc.css('table tbody tr th a')
    courses.each do |course|
      semester.courses << CourseScraper.extract('https://aits.encs.concordia.ca/oldsite/resources/schedules/courses/' + course.attr('href'))
    end
    puts "Semester: #{semester.year} #{semester.semester} done!"
    semester
  end

  def self.year(doc)
    doc.css('#maincontent > div.insidecontent > h1')[0].content.gsub(/[^0-9]/, '')[0..3].to_i
  end

  def self.semester(doc)
    doc.css('#maincontent > div.insidecontent > h1')[0].content.gsub(/[^A-Za-z ]/, '').split(' ')[0]
  end
end
