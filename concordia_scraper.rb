require 'open-uri'
require 'nokogiri'
require 'openssl'
require './semester_scraper'

class ConcordiaScraper
  def self.extract(url)
    doc = Nokogiri::HTML(
      open(
        url,
        ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
      )
    )
    semester_data = []
    semesters = doc.css('#maincontent > div.insidecontent > div > ul > li > a')
    semesters.each do |semester|
      semester_data << SemesterScraper.extract('https://aits.encs.concordia.ca/oldsite/resources/schedules/courses/' + semester.attr('href'))
    end
    puts semester_data
  end
end

ConcordiaScraper.extract('https://aits.encs.concordia.ca/oldsite/resources/schedules/courses/')
