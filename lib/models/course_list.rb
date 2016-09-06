require_relative './course'

class CourseList
  attr_accessor :courses

  def initialize(options = {})
    @courses = options.fetch(:courses, [])
  end

  def get(code, name)
    course = @courses.find { |e| e.name == name && e.code == code }
    if course.nil?
      course = Course.new(name: name, code: code)
      @courses << course
    else
      puts 'Old Course, reusing'
    end
    course
  end
end
