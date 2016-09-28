require_relative './models/semester_list'
require_relative './models/course_list'
require_relative './scrapers/capybara_scraper'
require_relative './scrapers/fcms_scraper'
require_relative './database_populators/csv_populator'

class ConcordiaCourseScraper
  attr_accessor :fcms_scraper, :scraper, :database_populator
  def initialize(options = {})
    @course_list = CourseList.new
    @semester_list = SemesterList.new
    @section_list = []
    @scraper = CapybaraScraper.new
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

  def extract_all(year_code = 216)
    @course_codes.each do |course_code|
      begin
        html = @scraper.get_results(course_code, year_code.to_s)
        @fcms_scraper.extract(html)
      rescue
        begin
          @fcms_scraper.extract(@scraper.get_results(course_code, "#{year_code}2"))
          @fcms_scraper.extract(@scraper.get_results(course_code, "#{year_code}4"))
        rescue
          puts "#{course_code} has no classes in #{year_code}"
        end
      end
    end
  end

  def extract(course_code, year_code = 216)
    begin
      @fcms_scraper.extract(@scraper.get_results(course_code, year_code))
    rescue Exception => e
      puts e.backtrace
    end
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
