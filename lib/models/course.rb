require_relative './base'

class Course < Base
  attr_accessor :name, :code, :number, :sections
  def initialize(options = {})
    super
    @code = options.fetch(:code, nil)
    @number = options.fetch(:number, nil)
    @name = options.fetch(:name, nil)
    @sections = options.fetch(:sections, [])
  end
end
