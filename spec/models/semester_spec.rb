require_relative '../spec_helper'
require_relative '../../lib/models/semester'

RSpec.describe Semester do
  describe 'initialization' do
    it 'with all attributes completes successfully' do
      year = 'year'
      semester_attr = 'semester'
      sections = 'sections'

      semester = Semester.new(
        year: year,
        semester: semester_attr,
        sections: sections
      )

      expect(semester.year).to eq(year)
      expect(semester.semester).to eq(semester_attr)
      expect(semester.sections).to eq(sections)
    end
  end
end
