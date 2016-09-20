require_relative '../spec_helper'
require_relative '../../lib/models/course'

RSpec.describe Course do
  describe 'initialization' do
    it 'with all attributes completes successfully' do
      code = 'code'
      number = 'number'
      name = 'name'
      sections = 'sections'

      course = Course.new(
        code: code,
        number: number,
        name: name,
        sections: sections
      )

      expect(course.code).to eq(code)
      expect(course.number).to eq(number)
      expect(course.name).to eq(name)
      expect(course.sections).to eq(sections)
    end
  end
end