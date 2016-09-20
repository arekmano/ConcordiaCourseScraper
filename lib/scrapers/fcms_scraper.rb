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
      puts "Extracting #{course.code} #{course.number}"
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
    match = section_text.match(/(LEC|TUT|LAB|STU|SEM|PRA|REG|TL|CON|WKS|THE|RSC)/)
    if match.nil?
      puts "Section type unrecognized for #{section_text}"
      return nil
    end
    match[0]
  end

  def parse_sections(table, course)
    split_sections(table).each do |values|
      begin
        remove_duplicates(values)
        semester = parse_semester(values[-1])
        section = Section.new(
          code: values[9].split('-')[0],
          days: values[11].split(' ')[0],
          time_start: parse_time(values[11].split(' ')[1]),
          time_end: parse_time(values[11].split(' ')[3]),
          room: values[12],
          section_type: parse_section_type(values[9]),
          semester: semester,
          course: course
        )
        course.sections << section
        semester.sections << section
        @section_list << section
      rescue
        puts "Issue Encountered when Scraping #{course.code} #{course.number}"
      end
    end
  end

  def split_sections(table)
    table.slice_before('Class')
  end

  def remove_duplicates(table)
    duplicates = (table.size - 16) / 4
    table.slice!(12, duplicates)
    table.slice!(13, duplicates)
    table.slice!(14, duplicates)
    table.slice!(15, duplicates)
  end

  def parse_time(text)
    return Time.new(0) if text =~ /TBA/ || text.nil?
    initial = Time.new(0)
    minutes = text.split(':')[1].to_i
    hours = text.split(':')[0].to_i
    hours += 12 if text =~ /PM/

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
