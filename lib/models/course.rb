require_relative './base'

class Course < Base
  attr_accessor :name, :code, :lectures, :laboratories, :tutorials, :semester
  def initialize(options = {})
    super
    @name = options.fetch(:name, nil)
    @code = options.fetch(:code, nil)
    @name = options.fetch(:name, nil)
    @lectures = options.fetch(:lectures, [])
    @laboratories = options.fetch(:laboratories, [])
    @tutorials = options.fetch(:tutorials, [])
    @semester = options.fetch(:semester, nil)
  end

  def sections
    @lectures + @laboratories + @tutorials
  end

  def add_section(section)
    case section.section_type.upcase
    when 'LEC'
      @lectures << section
    when 'LAB'
      @laboratories << section
    when 'TUT'
      @tutorials << section
    else
      raise 'Invalid Section Type'
    end
    section.course = self
  end
end
