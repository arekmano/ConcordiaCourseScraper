require 'open-uri'
require 'nokogiri'
require 'openssl'

class CourseScraper
    def self.run
        doc = Nokogiri::HTML(open("https://aits.encs.concordia.ca/oldsite/resources/schedules/courses/details/?ys=20161&d=05&c=COMP352", ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
        course = {}
         course['Name'] = doc.css('#maincontent div h1')[0].content
         course['Lec'] = []
         course['Lab'] = []
         course['Tut'] = []
        data = doc.css('table')[1].css('tbody tr td')
        (data.size / 9).times do |i|
            sectionData = data[9*i..9*i+7]
            course[getData(sectionData[0])] << extractSection(sectionData)
        end
    end

    def self.extractSection(sectionData)
        info = {}
        info['section'] = getData(sectionData[1]) + getData(sectionData[2])
        info['days'] = getData(sectionData[4])
        info['start'] = Time.new(2016,1,1,getData(sectionData[5]).split(':')[0],getData(sectionData[5]).split(':')[1])
        info['end'] = Time.new(2016,1,1,getData(sectionData[6]).split(':')[0],getData(sectionData[6]).split(':')[1])
        info['room'] = getData(sectionData[7])
        info
    end

    def self.getData(nokoObject)
        nokoObject.content.gsub(/[^0-9A-Za-z:]/, '')
    end
end

CourseScraper.run