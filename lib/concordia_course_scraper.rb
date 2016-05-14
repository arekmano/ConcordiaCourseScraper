require_relative './scrapers/concordia_scraper'
require_relative './scrapers/course_scraper'
require_relative './scrapers/semester_scraper'

class ConcordiaCourseScraper
  attr_accessor :uri
  DEFAULT_SITE = URI.parse('https://aits.encs.concordia.ca/oldsite/resources/schedules/courses/')
  def self.extract_all(uri = DEFAULT_SITE)
    ConcordiaScraper.extract(uri)
  end

  def self.extract_course(uri)
    ClassScraper.extract(uri)
  end

  def self.extract_semester(uri)
    SemesterScraper.extract(uri)
  end

  def initialize(uri = DEFAULT_SITE)
    uri = URI.parse(uri) if uri.class == String
    @uri = uri
  end

  def extract_all(uri = @uri)
    ConcordiaScraper.extract(uri)
  end

  def extract_course(uri = @uri)
    ClassScraper.extract(uri)
  end

  def extract_semester(uri = @uri)
    SemesterScraper.extract(uri)
  end
end
