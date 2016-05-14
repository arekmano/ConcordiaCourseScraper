class Section
  attr_accessor :section, :days, :time_start, :time_end, :room, :section_type
  def initialize(options = {})
    @section = options.fetch(:section, nil)
    @days = options.fetch(:days, nil)
    @time_start = options.fetch(:time_start, nil)
    @time_end = options.fetch(:time_end, nil)
    @room = options.fetch(:room, nil)
    @section_type = options.fetch(:section_type, nil)
  end
end
