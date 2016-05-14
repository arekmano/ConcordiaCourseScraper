require 'open-uri'
require 'nokogiri'
require 'openssl'
require_relative './semester_scraper'

class ConcordiaScraper
  DEFAULT_SITE = URI.parse('https://aits.encs.concordia.ca/oldsite/resources/schedules/courses/')

  def self.extract(uri = DEFAULT_SITE)
    doc = Nokogiri::HTML(open(uri))
    semester_data = []
    semester_links = doc.css('#maincontent > div.insidecontent > div > ul > li > a')
    semester_links.each do |semester|
      semester_uri_string = "#{uri.scheme}://#{uri.host + uri.path + semester.attr('href')}"
      semester_uri = URI.parse(semester_uri_string)
      semester_data << SemesterScraper.extract(semester_uri)
    end
    puts semester_data
  end
end
