require_relative '../spec_helper'
require_relative '../../lib/models/section'

RSpec.describe Section do
  describe 'initialization' do
    it 'with all attributes completes successfully' do
      code = 'code'
      days = 'days'
      time_start = 'time_start'
      time_end = 'time_end'
      room = 'room'
      section_type = 'section_type'
      semester = 'semester'
      course = 'course'

      section = Section.new(
        code: code,
        days: days,
        time_start: time_start,
        time_end: time_end,
        room: room,
        section_type: section_type,
        semester: semester,
        course: course
      )

      expect(section.id).not_to be_nil
      expect(section.code).to eq(code)
      expect(section.days).to eq(days)
      expect(section.time_start).to eq(time_start)
      expect(section.time_end).to eq(time_end)
      expect(section.room).to eq(room)
      expect(section.section_type).to eq(section_type)
      expect(section.semester).to eq(semester)
      expect(section.course).to eq(course)
    end
  end
end
