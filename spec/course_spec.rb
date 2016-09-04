require_relative '../lib/models/course'
require_relative '../lib/models/section'

RSpec.describe Course do
  describe 'adds sections correctly' do
    it 'to tutorials' do
      # Test Data
      section = Section.new
      section.section_type = 'TUT'
      course = Course.new

      # Execute
      course.add_section(section)

      # Verify
      expect(section).to eq(course.tutorials.first)
    end

    it 'to lectures' do
      # Test Data
      section = Section.new
      section.section_type = 'LEC'
      course = Course.new

      # Execute
      course.add_section(section)

      # Verify
      expect(section).to eq(course.lectures.first)
    end

    it 'to laboratories' do
      # Test Data
      section = Section.new
      section.section_type = 'LAB'
      course = Course.new

      # Execute
      course.add_section(section)

      # Verify
      expect(section).to eq(course.laboratories.first)
    end
  end
end
