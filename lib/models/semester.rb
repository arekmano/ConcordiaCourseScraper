require_relative './base'

class Semester < Base
  attr_accessor :year, :semester, :sections
  def initialize(options = {})
    @year = options.fetch(:year, nil)
    @semester = options.fetch(:semester, nil)
    @sections = options.fetch(:sections, [])
    @id = Digest::MD5.hexdigest("#{@year}#{@semester}")
  end
end
