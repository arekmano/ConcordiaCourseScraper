require_relative './base'
require 'digest'
class Course < Base
  attr_accessor :name, :code, :number, :sections
  def initialize(options = {})
    @code = options.fetch(:code, nil)
    @number = options.fetch(:number, nil)
    @name = options.fetch(:name, nil)
    @sections = options.fetch(:sections, [])
    @id = Digest::MD5.hexdigest("#{@code}#{@number}")
  end
end
