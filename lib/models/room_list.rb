require_relative './room'

class RoomList
  attr_accessor :rooms

  def initialize(options = {})
    @rooms = options.fetch(:rooms, [])
    @data_writer = options[:data_writer]
  end

  def tba
    get(nil, nil, nil)
  end

  def get(campus, building, number)
    room = @rooms.find do |e|
      e.campus == campus &&
        e.building == building &&
        e.number == number
    end
    if room.nil?
      room = Room.new(
        number: number,
        campus: campus,
        building: building
      )
      @rooms << room
      @data_writer.save_room(room)
    end
    room
  end
end
