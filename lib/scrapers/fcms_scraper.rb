require 'nokogiri'

require_relative './nokogiri_scraper'
require_relative '../models/course'
require_relative '../models/section'

class FcmsScraper < NokogiriScraper
  def extract
    courses = []
    doc = Nokogiri::HTML(open('test.html'))
    doc.children[2].css('.PAGROUPBOXLABELLEVEL1.PSLEFTCORNER').each_with_index do |title, offset|
      title_text = title.text.gsub(/(^[[:space:]]|[[:space:]]$)/, '').split(' - ')
      course = parse_course(title_text)
      courses << course
      parse_sections(sections_table(doc, offset), course)
    end
    courses
  end

  def parse_course(title_text)
    Course.new(
      code: title_text[0].gsub(' ', ''),
      name: title_text[1]
    )
  end

  def parse_section_type(section_text)
    section_text.match(/(LEC|TUT|LAB)/)[0]
  end

  def parse_sections(table, course)
    (table.size / 16).times do |i|
      section = Section.new(
        code: table[(i * 16) + 9].split('-')[0],
        days: table[(i * 16) + 11].split(' ')[0],
        time_start: table[(i * 16) + 11].split(' ')[1],
        time_end: table[(i * 16) + 11].split(' ')[3],
        room: table[(i * 16) + 12],
        section_type: parse_section_type(table[(i * 16) + 9]),
        semester: '',
        course: course
      )
      course.add_section(section)
    end
  end

  def sections_table(doc, offset)
    sections_table = doc.children[2].css('#ACE_\$ICField48\$' + offset.to_s).text.split(/\n/)
    sections_table.delete('')
    sections_table.delete_if { |e| e.match(/Notes:.*/) }
  end
end

FcmsScraper.new.extract
