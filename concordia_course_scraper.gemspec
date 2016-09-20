Gem::Specification.new do |spec|
  spec.name        = 'concordia_course_scraper'
  spec.version     = '1.0.0'
  spec.date        = '2016-05-14'
  spec.summary     = 'Class scraper made specifically for Concordia University'
  spec.description = 'A class scraper gem for Concordia University'
  spec.author      = 'Arek Manoukian'
  spec.email       = 'manoukian.arek@gmail.com'
  spec.homepage    = 'https://github.com/arekmano/ConcordiaCourseScraper'
  spec.license     = 'MIT'
  spec.files       = Dir[
    'lib/concordia_course_scraper.rb',
    'lib/models/*.rb',
    'lib/scrapers/*.rb'
  ]
end
