require_relative './lib/concordia_course_scraper'
require_relative './lib/data_writers/sql_writer'

populator = SqlWriter.new(
  username: ENV['CONCORDIA_COURSE_USER'],
  password: ENV['CONCORDIA_COURSE_PASS'],
  host: ENV['CONCORDIA_COURSE_HOST'],
  database: ENV['CONCORDIA_COURSE_DB']
)
scraper = ConcordiaCourseScraper.new(
  course_codes: 'ALL',
  data_writer: populator
)
populator.clear_tables
scraper.extract_all(214)
scraper.extract_all(215)
scraper.extract_all(216)
scraper.extract_all(217)
