require_relative './course'

class CourseList
  attr_accessor :courses

  def initialize(options = {})
    @courses = options.fetch(:courses, [])
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
    end
    course
  end
end
