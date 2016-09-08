require_relative './models/semester_list'
require_relative './models/course_list'
require_relative './scrapers/selenium_scraper'
require_relative './scrapers/fcms_scraper'
require_relative './database_populators/csv_populator'

class ConcordiaCourseScraper
  attr_accessor :fcms_scraper, :selenium_scraper, :database_populator
  COURSE_LEVELS = %w(200 300 400 500 600 700 800)
  # COURSE_CODES = File.open('./course_codes_short.txt').readlines.map(&:chomp)
  def initialize(options = {})
    @course_list = CourseList.new
    @semester_list = SemesterList.new
    @section_list = []
    @selenium_scraper = SeleniumScraper.new
    @fcms_scraper = FcmsScraper.new(
      course_list: @course_list,
      semester_list: @semester_list,
      section_list: @section_list
    )
    @database_populator = options.fetch(:database_populator, CsvPopulator.new)
  end

  def extract_all
    @selenium_scraper.start
    COURSE_LEVELS.each do |course_level|
      COURSE_CODES.each do |course_code|
        begin
          @fcms_scraper.extract(@selenium_scraper.get_results(course_code, course_level))
        rescue
          puts "#{course_code} #{course_level} category has no classes"
        end
      end
    end
    @selenium_scraper.end
  end

  def extract(course_code, course_level)
    @selenium_scraper.start
    begin
      @fcms_scraper.extract(@selenium_scraper.get_results(course_code, course_level))
    rescue Exception => e
      puts e.backtrace
    end
    @selenium_scraper.end
  end

  def courses
    @course_list.courses
  end

  def semesters
    @semester_list.semesters
  end

  def sections
    @section_list
  end

  def save
    extract_all
    database_populator.save(courses, semesters, sections)
  end
end

ConcordiaCourseScraper.new.extract('ELEC', 400)