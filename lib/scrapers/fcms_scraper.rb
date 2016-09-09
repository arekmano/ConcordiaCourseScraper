require 'nokogiri'

require_relative '../models/course'
require_relative '../models/semester'
require_relative '../models/course_list'
require_relative '../models/semester_list'
require_relative '../models/section'

class FcmsScraper
  attr_accessor :course_list, :semester_list, :section_list
  def initialize(options = {})
    @course_list = options.fetch(:course_list, CourseList.new)
    @semester_list = options.fetch(:semester_list, SemesterList.new)
    @section_list = options.fetch(:section_list, [])
  end

  def extract(html)
    doc = Nokogiri::HTML(html)
    doc.children[1].css('.PAGROUPBOXLABELLEVEL1.PSLEFTCORNER').each_with_index do |title, offset|
      course_text = title.text.gsub(/(^[[:space:]]|[[:space:]]$)/, '').split(' - ')
      course = @course_list.get(
        course_code(course_text),
        course_number(course_text),
        course_name(course_text)
      )
      parse_sections(sections_table(doc, offset), course)
    end
  end

  def course_code(course_text)
    course_text[0].split(' ')[0]
  end

  def course_number(course_text)
    course_text[0].split(' ')[1]
  end

  def course_name(course_text)
    course_text[1]
  end

  def parse_section_type(section_text)
    section_text.match(/(LEC|TUT|LAB|STU)/)[0]
  end

  def parse_sections(table, course)
    i = 0
    while table.size / 16 > i
      begin
        remove_duplicates(table, i)
        semester = parse_semester(table[(i * 16) + 15])
        section = Section.new(
          code: table[(i * 16) + 9].split('-')[0],
          days: table[(i * 16) + 11].split(' ')[0],
          time_start: parse_time(table[(i * 16) + 11].split(' ')[1]),
          time_end: parse_time(table[(i * 16) + 11].split(' ')[3]),
          room: table[(i * 16) + 12],
          section_type: parse_section_type(table[(i * 16) + 9]),
          semester: semester,
          course: course
        )
        course.sections << section
        semester.sections << section
        @section_list << section
      rescue
        puts "Issue Encountered when Scraping #{course.code}"
      end
      i += 1
    end
  end

  def remove_duplicates(table, i)
    duplicates = 0
    while table[(i * 16) + 11] == table[(i * 16) + 12]
      duplicates += 1
      table.delete_at((i * 16) + 12)
    end
    table.slice!((i * 16) + 13, duplicates)
    table.slice!((i * 16) + 14, duplicates)
    table.slice!((i * 16) + 15, duplicates)
  end

  def parse_time(text)
    return Time.new(0) if text =~ /TBA/ || text.nil?
    initial = Time.new(0)
    minutes = text.split(':')[1].slice(0..-3).to_i
    hours = text.split(':')[0].to_i
    hours + 12 if text =~ /PM/

    Time.new(initial.year, initial.month, initial.day, hours, minutes)
  end

  def parse_semester(text)
    text_array = text.split(' ')
    @semester_list.get(
      text_array[1].to_i,
      text_array[0]
    )
  end

  def sections_table(doc, offset)
    sections_table = doc.children[1].css('#ACE_\$ICField48\$' + offset.to_s).text.split(/\n/)
    sections_table.map! { |e| e.gsub(/\r/, '') }
    sections_table.delete('')
    sections_table.delete_if { |e| e.match(/(Notes:.*|Topic:.*)/) }
  end
end
