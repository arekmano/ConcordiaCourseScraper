require_relative './models/semester_list'
require_relative './models/course_list'
require_relative './scrapers/capybara_scraper'
require_relative './scrapers/fcms_scraper'
require_relative './data_writers/csv_writer'

class ConcordiaCourseScraper
  attr_accessor :fcms_scraper, :scraper, :data_writer
  def initialize(options = {})
    @data_writer = options.fetch(:data_writer, CsvWriter.new)
    @course_list = CourseList.new(data_writer: @data_writer)
    @semester_list = SemesterList.new(data_writer: @data_writer)
    @section_list = []
    @scraper = CapybaraScraper.new
    @fcms_scraper = FcmsScraper.new(
      course_list: @course_list,
      semester_list: @semester_list,
      section_list: @section_list,
      data_writer: @data_writer
    )
    if options[:course_codes] == 'ALL'
      @course_codes = File.open('./course_codes.txt').readlines.map(&:chomp)
    else
      @course_codes = File.open('./course_codes_short.txt').readlines.map(&:chomp)
    end
  end

  def extract_all(year_code = 216)
    @course_codes.each do |course_code|
      begin
        extract(course_code, year_code)
      rescue TooManyClassesError
        begin
          extract(course_code, "#{year_code}2")
          extract(course_code, "#{year_code}4")
        rescue NoMatchError
          puts "#{course_code} has no classes in #{year_code}"
        rescue StateError
          puts "State Error when parsing #{course_code} in #{year_code}"
        end
      rescue NoMatchError
        puts "#{course_code} has no classes in #{year_code}"
      rescue StateError
        puts "State Error when parsing #{course_code} in #{year_code}"
      end
    end
  end

  def extract(course_code, year_code)
    @fcms_scraper.extract(@scraper.get_results(course_code, year_code.to_s))
  end

  ##
  # Extracts course information for the given course code, during the course
  # year. Year_code format is 2XXY, where XX are the 2 last digits of the year,
  # and Y is optionally the semester number, Winter is 2, Fall is 4
  ##
  def extract_single(course_code, year_code = 216)
    begin
      extract(course_code, year_code)
    rescue TooManyClassesError
      extract(course_code, "#{year_code}2")
      extract(course_code, "#{year_code}4")
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

  ##
  # Saves all courses, sections and semesters that have been scraped so far
  # using the data populator
  ##
  def save
    data_writer.save(courses, semesters, sections)
  end
end
