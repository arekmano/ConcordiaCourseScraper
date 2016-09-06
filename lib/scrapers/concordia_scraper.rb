require 'nokogiri'
require_relative './nokogiri_scraper'
require_relative './semester_scraper'

class ConcordiaScraper < NokogiriScraper
  attr_accessor :semester_scraper
  DEFAULT_SITE = URI.parse('https://aits.encs.concordia.ca/oldsite/resources/schedules/courses/')

  def initialize(options = {})
    @semester_scraper = options.fetch(:semester_scraper, SemesterScraper.new)
  end

  def extract(uri = DEFAULT_SITE)
    doc = load_uri uri
    semester_data = []
    semester_links = doc.css('#maincontent > div.insidecontent > div > ul > li > a')
    semester_links.each do |semester|
      semester_uri_string = "#{uri.scheme}://#{uri.host + uri.path + semester.attr('href')}"
      semester_uri = URI.parse(semester_uri_string)
      semester_data << @semester_scraper.extract(semester_uri)
    end
    semester_data
  end
end
