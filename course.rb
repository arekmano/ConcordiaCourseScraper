class Course
  attr_accessor :name, :course_code, :lectures, :laboratories, :tutorials
  def initialize(options = {})
    @name = options.fetch(:name, nil)
    @course_code = options.fetch(:course_code, nil)
    @lectures = options.fetch(:lectures, [])
    @laboratories = options.fetch(:laboratories, [])
    @tutorials = options.fetch(:tutorials, [])
  end
end