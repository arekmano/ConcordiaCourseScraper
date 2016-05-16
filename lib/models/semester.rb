require_relative './base'

class Semester < Base
  attr_accessor :year, :semester, :courses
  def initialize(options = {})
    super
    @year = options.fetch(:year, nil)
    @semester = options.fetch(:semester, nil)
    @courses = options.fetch(:courses, [])
  end
end
