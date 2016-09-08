require_relative './semester'

class SemesterList
  attr_accessor :semesters

  def initialize(options = {})
    @semesters = options.fetch(:semesters, [])
  end

  def get(year, semester)
    semester_obj = @semesters.find { |e| e.semester == semester && e.year == year }
    if semester_obj.nil?
      semester_obj = Semester.new(semester: semester, year: year)
      @semesters << semester_obj
    end
    semester_obj
  end
end
