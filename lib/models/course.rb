require_relative './base'

class Course < Base
  attr_accessor :name, :code, :sections
  def initialize(options = {})
    super
    @code = options.fetch(:code, nil)
    @name = options.fetch(:name, nil)
    @sections = options.fetch(:sections, [])
  end
end
