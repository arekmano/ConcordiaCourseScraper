require_relative './lib/concordia_course_scraper'
require_relative './lib/database_populators/sql_populator'

populator = SqlPopulator.new(
  database: ENV['CONCORDIA_COURSE_DB'],
  username: ENV['CONCORDIA_COURSE_USER'],
  password: ENV['CONCORDIA_COURSE_PASS'],
  host: ENV['CONCORDIA_COURSE_HOST']
)
scraper = ConcordiaCourseScraper.new(
  course_codes: 'ALL',
  database_populator: populator
)
scraper.extract_all
scraper.save
