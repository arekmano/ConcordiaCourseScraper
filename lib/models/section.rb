require_relative './base'

class Section < Base
  attr_accessor :code, :days, :time_start, :time_end, :room, :section_type, :semester, :course
  def initialize(options = {})
    super
    @code = options.fetch(:code, nil)
    @days = options.fetch(:days, nil)
    @time_start = options.fetch(:time_start, nil)
    @time_end = options.fetch(:time_end, nil)
    @room = options.fetch(:room, nil)
    @section_type = options.fetch(:section_type, nil)
    @semester = options.fetch(:semester, nil)
    @course = options.fetch(:course, nil)
  end
end
