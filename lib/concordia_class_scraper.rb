require_relative './scrapers/concordia_scraper'
require_relative './scrapers/course_scraper'
require_relative './scrapers/semester_scraper'

class ConcordiaClassScraper
  def self.extract_all
    ConcordiaScraper.extract
  end

  def self.extract_course(url)
    ClassScraper.extract(url)
  end

  def self.extract_semester(url)
    SemesterScraper.extract(url)
  end
end
