require_relative './base'

class Semester < Base
  attr_accessor :year, :semester, :sections
  def initialize(options = {})
    super
    @year = options.fetch(:year, nil)
    @semester = options.fetch(:semester, nil)
    @sections = options.fetch(:sections, [])
  end
end
