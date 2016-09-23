require_relative '../spec_helper'
require_relative '../../lib/database_populators/csv_populator'
require_relative '../../lib/models/section'
require_relative '../../lib/models/course'
require_relative '../../lib/models/semester'
RSpec.describe CsvPopulator do
  describe 'initialization' do
    it 'defaults correctly' do
      populator = CsvPopulator.new

      expect(
        populator.instance_variable_get(:@course_file)
      ).to eq('courses.csv')
      expect(
        populator.instance_variable_get(:@section_file)
      ).to eq('sections.csv')
      expect(
        populator.instance_variable_get(:@semester_file)
      ).to eq('semesters.csv')
    end

    it 'overrites correctly' do
      populator = CsvPopulator.new(
        course_file: 'course_file',
        section_file: 'section_file',
        semester_file: 'semester_file'
      )

      expect(
        populator.instance_variable_get(:@course_file)
      ).to eq('course_file')
      expect(
        populator.instance_variable_get(:@section_file)
      ).to eq('section_file')
      expect(
        populator.instance_variable_get(:@semester_file)
      ).to eq('semester_file')
    end
  end

  describe 'saving' do
    it 'delegates correctly' do
      # Test Data
      courses = 'courses'
      semesters = 'semesters'
      sections = 'sections'
      populator = CsvPopulator.new

      # Verify
      allow(populator).to receive(:save_courses).with(courses)
      allow(populator).to receive(:save_semesters).with(semesters)
      allow(populator).to receive(:save_sections).with(sections)

      expect(populator).to receive(:save_courses).with(courses)
      expect(populator).to receive(:save_semesters).with(semesters)
      expect(populator).to receive(:save_sections).with(sections)

      # Execute
      populator.save(courses, semesters, sections)
    end
  end

  describe 'section data' do
    it 'returns correct array' do
      # Test data
      code = 'code'
      days = 'days'
      time_start = Time.new
      time_end = Time.new
      room = 'room'
      section_type = 'section_type'
      semester = Semester.new
      course = Course.new

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

      # Execute
      result = CsvPopulator.new.section_data(section)

      # Verify
      expect(result.size).to eq(9)
    end
  end

  describe 'semester data' do
    it 'returns correct array' do
      # Test Data
      year = 'year'
      semester = 'semester'

      semester = Semester.new(
        year: year,
        semester: semester
      )

      # Execute
      result = CsvPopulator.new.semester_data(semester)

      # Verify
      expect(result.size).to eq(3)
    end
  end

  describe 'course data' do
    it 'returns correct array' do
      # Test data
      code = 'code'
      number = 'number'
      name = 'name'

      course = Course.new(
        code: code,
        number: number,
        name: name
      )

      # Execute
      result = CsvPopulator.new.course_data(course)

      # Verify
      expect(result.size).to eq(4)
    end
  end
end
