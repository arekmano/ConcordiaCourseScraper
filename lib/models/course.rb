require_relative './base'

class Course < Base
  attr_accessor :name, :code, :lectures, :laboratories, :tutorials, :semester
  def initialize(options = {})
    super
    @name = options.fetch(:name, nil)
    @code = options.fetch(:code, nil)
    if @code.nil? && !options.fetch(:name, '').match(/\w{4}\d{3,4}/).nil?
      @code = options.fetch(:name, '').match(/\w{4}\d{3,4}/)[0]
    end
    @name.sub!((@code + ' - '), '') unless @code.nil?
    @lectures = options.fetch(:lectures, [])
    @laboratories = options.fetch(:laboratories, [])
    @tutorials = options.fetch(:tutorials, [])
    @semester = options.fetch(:semester, nil)
  end

  def sections
    @lectures + @laboratories + @tutorials
  end
end
