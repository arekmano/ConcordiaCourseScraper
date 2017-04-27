require_relative './base'
require 'digest'

##
# Represents a room
##
class Room < Base
  attr_accessor :campus, :building, :number
  def initialize(options = {})
    @campus = options.fetch(:campus, nil)
    @building = options.fetch(:building, nil)
    @number = options.fetch(:number, nil)
    @id = Digest::MD5.hexdigest("#{@campus}#{@building}#{@number}")
  end
end
