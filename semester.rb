class Semester
  attr_accessor :year, :semester, :courses
  def initialize(options = {})
    @year = options.fetch(:year, nil)
    @semester = options.fetch(:semester, nil)
    @courses = options.fetch(:courses, [])
  end
end