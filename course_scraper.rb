require 'open-uri'
require 'nokogiri'
require 'openssl'
require './course'
require './section'

class CourseScraper
  def self.extract(url)
    doc = Nokogiri::HTML(
      open(
        url,
        ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
      )
    )
    course = Course.new(name: course_name(doc))
    data_table = doc.at('table:contains("Instructor")')
    if data_table.nil?
      puts 'No data table for course: ' + url
      return
    end
    data = data_table.css('tbody tr td')
    course_data course, data
    course
  end

  def self.course_name(doc)
    doc.css('#maincontent div h1')[0].content
  end

  def self.course_data(course, data)
    (data.size / 9).times do |i|
      section_data = data[(9 * i)..(9 * i + 7)]
      section = extract_section(section_data)
      section.sectionType = get_data(section_data[0])
      case section.sectionType
      when 'Tut'
        course.tutorials << section
      when 'Lab'
        course.laboratories << section
      when 'Lec'
        course.lectures << section
      end
    end
  end

  def self.extract_section(section_data)
    Section.new(
      section: get_data(section_data[1]) + get_data(section_data[2]),
      days: get_data(section_data[4]),
      time_start: extract_time(get_data(section_data[5])),
      time_end: extract_time(get_data(section_data[6])),
      room: get_data(section_data[7])
    )
  end

  def self.extract_time(time_string)
    Time.new 2016, 1, 1, time_string.split(':')[0], time_string.split(':')[1]
  end

  def self.get_data(noko_object)
    noko_object.content.gsub(/[^0-9A-Za-z:]/, '')
  end
end
