require 'csv'

class CsvPopulator
  def initialize(options = {})
    @course_file = options.fetch(:course_file, 'courses.csv')
    @section_file = options.fetch(:section_file, 'sections.csv')
    @semester_file = options.fetch(:semester_file, 'semesters.csv')
  end

  def save(courses, semesters, sections)
    save_courses(courses)
    save_semesters(semesters)
    save_sections(sections)
    puts "Save Completed to following files: #{@course_file}, #{@semester_file}, #{@section_file}"
  end

  def save_courses(courses)
    CSV.open(@course_file, 'w') do |csv|
      courses.each do |course|
        csv << [
          course.id,
          course.name,
          course.code,
          course.number
        ]
      end
    end
  end

  def save_semesters(semesters)
    CSV.open(@semester_file, 'w') do |csv|
      semesters.each do |semester|
        csv << [
          semester.id,
          semester.semester,
          semester.year
        ]
      end
    end
  end

  def save_sections(sections)
    CSV.open(@section_file, 'w') do |csv|
      sections.each do |section|
        csv << [
          section.id,
          section.code,
          section.days,
          section.time_start.strftime('%Y-%m-%d %H:%M:%S'),
          section.time_end.strftime('%Y-%m-%d %H:%M:%S'),
          section.room,
          section.section_type,
          section.semester.id,
          section.course.id
        ]
      end
    end
  end
end
