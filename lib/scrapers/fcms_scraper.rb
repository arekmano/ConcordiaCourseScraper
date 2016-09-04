require 'nokogiri'

require_relative './nokogiri_scraper'
require_relative '../models/course'
require_relative '../models/section'

class FcmsScraper < NokogiriScraper
  def extract
    doc = Nokogiri::HTML(open('test.html'))
    doc.children[2].css('.PAGROUPBOXLABELLEVEL1.PSLEFTCORNER').each_with_index do |title, offset|
      title_text =  title.text.gsub(/(^[[:space:]]|[[:space:]]$)/, '').split(' - ')
      course = Course.new(
        code: title_text[0].gsub(' ', ''),
        name: title.text.gsub(/(^[[:space:]]|[[:space:]]$)/, '')
      )

      new_doc =  doc.children[2].css('#ACE_\$ICField48\$0').text.split(/\n/)
      new_doc.delete('')
      aa = Section.new(
        code: new_doc[(offset * 16) + 9].split('-')[0],
        days: new_doc[(offset * 16) + 11].split(' ')[0],
        time_start: new_doc[(offset * 16) + 11].split(' ')[1],
        time_end: new_doc[(offset * 16) + 11].split(' ')[3],
        room: new_doc[(offset * 16) + 12],
        section_type: new_doc[(offset * 16) + 9].split('-')[1],
        semester: '',
        course: course
      )
      p aa
    end
    puts '----------------'
  end
end

FcmsScraper.new.extract