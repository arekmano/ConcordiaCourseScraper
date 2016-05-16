require_relative '../models/section'

class SectionScraper < NokogiriScraper
  attr_reader :sections

  def initialize
    @sections = []
  end

  def extract(section_data, course)
    section = Section.new(
      section_type: get_data(section_data[0]),
      code: get_data(section_data[1]) + get_data(section_data[2]),
      days: get_data(section_data[4]),
      time_start: extract_time(get_data(section_data[5])),
      time_end: extract_time(get_data(section_data[6])),
      room: get_data(section_data[7]),
      course: course,
      semester: course.semester
    )
    @sections << section
    section
  end

  def extract_time(time_string)
    Time.new 2016, 1, 1, time_string.split(':')[0], time_string.split(':')[1]
  end
end
