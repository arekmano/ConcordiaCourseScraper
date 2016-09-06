require_relative './scrapers/concordia_scraper'
require_relative './scrapers/course_scraper'
require_relative './scrapers/semester_scraper'
require_relative './database_populators/csv_populator'

class ConcordiaCourseScraper
  attr_accessor :uri, :course_scraper, :semester_scraper, :section_scraper, :concordia_scraper, :database_populator
  DEFAULT_SITE = URI.parse('https://aits.encs.concordia.ca/oldsite/resources/schedules/courses/')

  def initialize(options = { uri: DEFAULT_SITE })
    @uri = if options[:uri].class == String
             URI.parse(options[:uri])
           else
             options[:uri]
           end
    @database_populator = options.fetch(:database_populator, CsvPopulator.new)
    @section_scraper = options.fetch(:section_scraper, SectionScraper.new)
    @course_scraper = options.fetch(:course_scraper, CourseScraper.new(section_scraper: @section_scraper))
    @semester_scraper = options.fetch(:semester_scraper, SemesterScraper.new(course_scraper: @course_scraper))
    @concordia_scraper = options.fetch(:concordia_scraper, ConcordiaScraper.new(semester_scraper: @semester_scraper))
  end

  def extract_all(options = {})
    @uri = options.fetch(:uri, @uri)
    @cache = @concordia_scraper.extract(@uri) if @cache.nil?
    @cache
  end

  def courses
    @course_scraper.course_list.courses
  end

  def semesters
    @semester_scraper.semesters
  end

  def sections
    @section_scraper.sections
  end

  def save
    extract_all
    database_populator.save(courses, semesters, sections)
  end
end
