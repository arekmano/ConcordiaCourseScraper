require_relative './models/semester_list'
require_relative './models/course_list'
require_relative './scrapers/selenium_scraper'
require_relative './scrapers/fcms_scraper'
require_relative './database_populators/csv_populator'

class ConcordiaCourseScraper
  attr_accessor :fcms_scraper, :selenium_scraper, :database_populator
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
    if options[:course_codes] == 'ALL'
      @course_codes = File.open('./course_codes.txt').readlines.map(&:chomp)
    else
      @course_codes = File.open('./course_codes_short.txt').readlines.map(&:chomp)
    end
  end

  def extract_all
    @selenium_scraper.start
    @course_codes.each do |course_code|
      begin
        @fcms_scraper.extract(@selenium_scraper.get_results(course_code, '2162'))
      rescue
        puts "#{course_code} has no classes in Fall 2016"
      end
      begin
        @fcms_scraper.extract(@selenium_scraper.get_results(course_code, '2164'))
      rescue
        puts "#{course_code} has no classes in Winter 2016"
      end
    end
    @selenium_scraper.end
  end

  def extract(course_code)
    @selenium_scraper.start
    begin
      @fcms_scraper.extract(@selenium_scraper.get_results(course_code, '2162'))
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
    database_populator.save(courses, semesters, sections)
  end
end
