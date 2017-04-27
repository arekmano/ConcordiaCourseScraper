require_relative './course'

class CourseList
  attr_accessor :courses

  def initialize(options = {})
    @courses = options.fetch(:courses, [])
    @data_writer = options[:data_writer]
  end

  def get(code, number, name)
    course = @courses.find { |e| e.code == code && e.number == number}
    if course.nil?
      course = Course.new(
        name: name,
        code: code,
        number: number
      )
      @courses << course
      @data_writer.save_course(course)
    end
    course
  end
end
