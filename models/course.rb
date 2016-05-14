class Course
  attr_accessor :name, :code, :lectures, :laboratories, :tutorials
  def initialize(options = {})
    @name = options.fetch(:name, nil)
    @code = options.fetch(:code, nil)
    @lectures = options.fetch(:lectures, [])
    @laboratories = options.fetch(:laboratories, [])
    @tutorials = options.fetch(:tutorials, [])
  end
end