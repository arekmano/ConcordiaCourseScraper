require 'csv'

##
# Writer used to write Concordia course information to 3
# separate csv files
##
class CsvWriter
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
        csv << course_data(course)
      end
    end
  end

  def save_semesters(semesters)
    CSV.open(@semester_file, 'w') do |csv|
      semesters.each do |semester|
        csv << semester_data(semester)
      end
    end
  end

  def save_sections(sections)
    CSV.open(@section_file, 'w') do |csv|
      sections.each do |section|
        csv << section_data(section)
      end
    end
  end

  def save_course(course)
    CSV.open(@course_file, 'a') do |csv|
      csv << course_data(course)
    end
  end

  def save_semester(semester)
    CSV.open(@semester_file, 'a') do |csv|
      csv << semester_data(semester)
    end
  end

  def save_section(section)
    CSV.open(@section_file, 'a') do |csv|
      csv << section_data(section)
    end
  end

  def semester_data(semester)
    [
      semester.id,
      semester.semester,
      semester.year
    ]
  end

  def section_data(section)
    [
      section.id,
      section.code,
      section.days,
      section.time_start.strftime('%Y-%m-%d %H:%M:%S'),
      section.time_end.strftime('%Y-%m-%d %H:%M:%S'),
      section.room,
      section.section_type,
      section.semester,
      section.course
    ]
  end

  def course_data(course)
    [
      course.id,
      course.name,
      course.code,
      course.number
    ]
  end
end
