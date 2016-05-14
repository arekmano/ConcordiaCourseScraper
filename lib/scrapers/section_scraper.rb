require_relative '../models/section'

class SectionScraper < NokogiriScraper

  def self.extract(section_data)
    Section.new(
      section_type: get_data(section_data[0]),
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
end
